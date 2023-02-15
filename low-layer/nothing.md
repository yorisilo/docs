# 何もしないプログラムをアセンブリで書いてみる
# 目標
x86_64 のアセンブリで何もしないプログラムを書く

# 方法
今回は、以下の方法でやっていく
1. c で何もしないプログラムを書く
1. そのアセンブリを見る。
1. 自分でそのアセンブリを参考に何もしないアセンブリを書く

Linux プログラムを書く上で環境の差異に困ることがあるので、 Dockerfile を用意する

``` dockerfile
FROM ubuntu:latest
WORKDIR /workspace

RUN apt-get update && apt-get install -y gcc man less && yes | unminimize
```

``` shell
(/ º﹃º)/ < docker build -t low-layer-dev:latest .
(/ º﹃º)/ < docker run -i -t --rm --mount type=bind,src=`pwd`,dst=/workspace -w /workspace low-layer-dev:latest
```

# どうやって書くの？
なんかレジストリに値を入れて、命令を叩けば良いという雑な理解

- レジストリに値を入れる
- syscall でそのレジスタを呼ぶ

# まずは c で何もしないプログラムを書く
何もしないを安全に終わるには exit を呼べば良さそう。
ちなみにライブラリが提供するサブルーチンの使い方を見るには、  `man 3 hoge` みたいにすれば良い。

``` shell
man 3 exit
```

test.c
``` c
#include <stdlib.h>

int main() {
  exit(0);
}
```

# アセンブリを出す

`-S` はアセンブリまで行うオプション
``` shell
gcc -S test.c -o test.s -masm=intel
```

``` assembly
        .file   "test.c"
        .intel_syntax noprefix
        .text
        .globl  main
        .type   main, @function
main:
.LFB6:
        .cfi_startproc
        endbr64
        push    rbp
        .cfi_def_cfa_offset 16
        .cfi_offset 6, -16
        mov     rbp, rsp
        .cfi_def_cfa_register 6
        mov     edi, 0
        call    exit@PLT
        .cfi_endproc
.LFE6:
        .size   main, .-main
        .ident  "GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
        .section        .note.GNU-stack,"",@progbits
        .section        .note.gnu.property,"a"
        .align 8
        .long    1f - 0f
        .long    4f - 1f
        .long    5
0:
        .string  "GNU"
1:
        .align 8
        .long    0xc0000002
        .long    3f - 2f
2:
        .long    0x3
3:
        .align 8
4:
```


``` assembly
call	exit@PLT # <==== ここで呼んでそう
```

# PLT とは
- procedure Linkage Table: 動的ライブラリのシンボル解決を遅延させるための仕組み
exit の呼び出しを PLT に任せている

# しかし、
今回は、直接 exit のシステムコールの番号を呼んで実行したいので、 static link を利用して、直接システムコールの番号を知る必要がある。

普通に以下を行っても、 static link なアセンブリは出力されない。

``` shell
gcc test.c -S -o test.s -static
```

static なリンクはリンカーのオプションなので、コンパイル時に指定しても意味がない。
`gcc test.c -S -o test.s` はあくまで、オブジェクトファイルを生成し(コンパイル)そのアセンブリを出力するからである。

- コンパイル: ソースコード -> オブジェクトファイル <= ここまでしか行わない
- リンク: オブジェクトファイル -> 実行ファイル

# 実行ファイルを逆アセンブルしてみる
static なリンクが施された実行ファイルを dump(機械語をアセンブリに変換する) して、 exit が何番のものなのかを把握する

``` shell
gcc test.c -o test.bin -static
```

``` shell
objdump -M intel -d test.bin | less
```

ここらへんがそうっぽい
``` shell
...
4013e0:       e8 cb 69 04 00          call   447db0 <_exit>
...
0000000000447db0 <_exit>:
  447db0:       f3 0f 1e fa             endbr64
  447db4:       49 c7 c1 c0 ff ff ff    mov    r9,0xffffffffffffffc0
  447dbb:       89 fa                   mov    edx,edi
  447dbd:       41 b8 e7 00 00 00       mov    r8d,0xe7
  447dc3:       be 3c 00 00 00          mov    esi,0x3c
  447dc8:       eb 15                   jmp    447ddf <_exit+0x2f>
  447dca:       66 0f 1f 44 00 00       nop    WORD PTR [rax+rax*1+0x0]
  447dd0:       89 d7                   mov    edi,edx
  447dd2:       89 f0                   mov    eax,esi
  447dd4:       0f 05                   syscall
  447dd6:       48 3d 00 f0 ff ff       cmp    rax,0xfffffffffffff000
  447ddc:       77 22                   ja     447e00 <_exit+0x50>
  447dde:       f4                      hlt
  447ddf:       89 d7                   mov    edi,edx
  447de1:       44 89 c0                mov    eax,r8d
  447de4:       0f 05                   syscall
  447de6:       48 3d 00 f0 ff ff       cmp    rax,0xfffffffffffff000
  447dec:       76 e2                   jbe    447dd0 <_exit+0x20>
  447dee:       f7 d8                   neg    eax
  447df0:       64 41 89 01             mov    DWORD PTR fs:[r9],eax
  447df4:       eb da                   jmp    447dd0 <_exit+0x20>
  447df6:       66 2e 0f 1f 84 00 00    nop    WORD PTR cs:[rax+rax*1+0x0]
  447dfd:       00 00 00
  447e00:       f7 d8                   neg    eax
  447e02:       64 41 89 01             mov    DWORD PTR fs:[r9],eax
  447e06:       eb d6                   jmp    447dde <_exit+0x2e>
  447e08:       0f 1f 84 00 00 00 00    nop    DWORD PTR [rax+rax*1+0x0]
  447e0f:       00
```

システムコールを呼んでいるところは、 `syscall` の部分
その `syscall` は eax レジスタに入っているシステムコール番号を呼ぶ。
eax には esi レジスタを介して、 `0x3c` が入ってそう。

x86 の場合 syscall を呼ぶときは eax を呼ぶようにしているっぽい。

# ではアセンブリを書いてみよう

nothing.s
``` assembly
  .intel_syntax noprefix
  .global main
main:
  mov eax, 0x3c
  syscall
```

## アセンブリをコンパイル、リンクを行い、実行ファイルを生成

コンパイル、リンク一気にやるとうまくいかないので注意
``` shell
gcc nothing.s -o nothing.bin <== ダメ
```

``` shell
root@4179c28ea15b:/workspace# gcc nothing.s -c -o nothing.o
root@4179c28ea15b:/workspace# objdump -D nothing.o

nothing.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
   0:   b8 3c 00 00 00          mov    $0x3c,%eax
   5:   0f 05                   syscall
```

``` shell
root@4179c28ea15b:/workspace# ld -e main -o nothing.bin nothing.o
```

## 実行してみる

``` shell
root@4179c28ea15b:/workspace# ./nothing.bin
```
やったね。

## テキトーな番号でシステムコールを呼んだらどうなる？

nothing.s
``` assembly
  .intel_syntax noprefix
  .global main
main:
  mov eax, 0x1c
  syscall
```

``` shell
root@4179c28ea15b:/workspace# gcc nothing.s -c -o nothing.o
root@4179c28ea15b:/workspace# objdump -D nothing.o
root@4179c28ea15b:/workspace# ld -e main -o nothing.bin nothing.o
root@4179c28ea15b:/workspace# ./nothing.bin
Segmentation fault
```

ちゃんと失敗する

# 参考
- https://www.youtube.com/watch?v=HFzk0fKDm_w
