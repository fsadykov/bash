#!/bin/bash

function fun1 {

	echo "This is function one "



}

fun2() {

	echo "This is function two"

}

#returing multiplication
multiples() {
	return $((100 * $1))

}



##################################
#             MAIN
##################################

fun1
fun2


i=2

multiples $i

echo "100 * $i = $?"
