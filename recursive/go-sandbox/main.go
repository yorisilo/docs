package main

import "fmt"

func main() {
	factAcc(100, 1)
	fmt.Printf("a")
}

// func pow(x, a int) int {
// 	sum := 1
// 	for i := a; i > 0; i-- {
// 		sum = x * sum
// 	}
// 	return sum
// }

// y が acc 的なものになってる
// func Fib(n int) int {
// 	x, y := 0, 1
// 	for i := 0; i < n; i++ {
// 		x, y = y, x+y
// 	}
// 	return x
// }

// func fact(n int) int {
// 	sum := 1
// 	if n == 0 {
// 		return 1
// 	}

// 	for i := n; i > 0; i-- {
// 		sum = sum * i
// 	}
// 	return sum
// }

// func factDirect(n int) int {
// 	if n == 0 {
// 		return 1
// 	}
// 	return n * fact(n-1)
// }

func factAcc(n, acc int) int {
	if n == 0 {
		return acc
	}
	return factAcc(n-1, n*acc)
}
