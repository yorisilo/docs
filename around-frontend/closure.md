# クロージャ

``` typescript
const counter = (() => {
  let count = 0;

  return {
    increment: () => {
      count++;
      console.log(count);
    },
    decrement: () => {
      count--;
      console.log(count);
    },
  };
})();

// counter は IIFE になっている。
counter.increment(); // 1
counter.increment(); // 2
counter.decrement(); // 1

const counter2 = () => {
  let count = 0;

  return {
    increment: () => {
      count++;
      console.log(count);
    },
    decrement: () => {
      count--;
      console.log(count);
    },
  };
};

// counter2() を呼び出すとべつのクロージャーになる
counter2().increment(); // 1
counter2().increment(); // 1

// c に宣言してから increment すると同じクロージャを参照する
const c = counter2()
c.increment()
c.increment()

```

cf.
- [クロージャ \- JavaScript \| MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Closures)
