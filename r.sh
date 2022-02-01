#!/bin/bash

#Author : Ryan Haddadi
#Program name: Right Triangles
#Purpose: This is a bash file used to compile assignment 4

echo "Remove old executable files if there are any"
rm *.o
rm *.out

echo "Compile isfloat.cpp file"
g++ -c -m64 -Wall -fno-pie -no-pie -o isfloat.o isfloat.cpp -std=c++17

echo "Assemble the X86 file hertz.asm"
nasm -f elf64 -l hertz.lis -o hertz.o hertz.asm

echo "Compile the C file Maxwell.c"
g++ -c -m64 -Wall -fno-pie -no-pie -l  Maxwell.lis -o Maxwell.o Maxwell.c -std=c++17

echo "Link the three 'O' files isfloat.o hertz.o and Maxwell.o"
g++ -m64 -o input.out isfloat.o hertz.o Maxwell.o -fno-pie -no-pie -std=c++17

echo "Now the program will run"
./input.out
