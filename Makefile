#Generic Makefile for c compilation with explanations

#Added to avoid problems for make if SHELL is defined by environment elsewhere
SHELL = /bin/sh
#In case different make programs have different suffix lists and implicit rules
#Done to improve portability. First line clears list, second adds only suffixes
#needed for this particular makefile.
.SUFFIXES:
.SUFFIXES: .c .o

#Variables
#= is to recursively expand vars(any variables are expanded and those inside)
#:= simply expand only first level e.g var= $(vars) only expands vars once and
#none of those inside prevents infinite recursion Cflags = $(Cflags)
#?= assigns if not already, =+ appends to value of variable.

#fully optimized with all warnings including ISOC/C++ and stops forbidden exten-
#-ions. Warns if multiple pointers to same address(aliasing). Debug included max
#level
CFLAGS = -std=gnu11 -O3 -Wall -Wextra -Wpedantic -Wstrict-aliasing 
CC = gcc

#Executable Rules
#remember the .o file rule below will not compile if there isn't a call for it 
#in the prereqs of another rule. Same with all % pattern rules.
test : test.o
	$(CC) $^ -o $@
#Dependency Rules
#Rule below compiles all .c files to .o files, -c compiles and does not link(ma
#kes .o files) -o for named file output
#$@ is target of rule (target is left of : and right is prereqs for that target
# % is pattern rule prereq (finds all matching following pattern), $<name of 
#first prereq, $^ names of all prereq with spaces between.
%*.o : %*.c
	$(CC) $< -o $@ $(CFLAGS)

#@ symbol is used at beginning of recipe to not print execution
clean:
	@rm -rf *.o
