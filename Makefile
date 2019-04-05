#Generic Makefile for c compilation with explanations

#MAKEFILE BASE SETUP

#Added to avoid problems for make if SHELL is defined by environment elsewhere
SHELL = /bin/sh
#In case different make programs have different suffix lists and implicit rules
#Done to improve portability. First line clears list, second adds only suffixes
#needed for this particular makefile.
.SUFFIXES:
.SUFFIXES: .c .o

#MACROS

__MKDIR ?= mkdir -p


#VARIABLES

#= is to recursively expand vars(any variables are expanded and those inside)
#:= simply expand only first level e.g var= $(vars) only expands vars once and
#none of those inside prevents infinite recursion Cflags = $(Cflags)
#?= assigns if not already, =+ appends to value of variable.
#****REMEMBER you can set vars at cli "make [target] FOO=bar" *****

TARGET_EXEC ?= test
BUILD_DIR ?= ./build
SRC_DIR ?= ./src

#makes list of source files of cpp, c and assembly (commented out)
C_SRC := $(shell find $(SRC_DIR) -name *.c)

#CPP_SRC := $(shell find $(SRC_DIR) -name *.cpp)
#ASMB_SRC := $(shell find $(SRC_DIR) -name *.s)
#ALL_SRC_F := $(shell find $(SRC_DIR) -name *.s -or -name *.cpp -or -name *.c)


#makes list of c object files in build dir (generic vers commented out)
OBJS := $(C_SRC:%=$(BUILD_DIR)/%.o)
#OBJS := $(ALL_SRC_F:%=$(BUILD_DIR)/%.o)


#fully optimized with all warnings including ISOC/C++ and stops forbidden exten-
#-ions. Warns if multiple pointers to same address(aliasing). Debug included max
#level
LFLAGS = 
CFLAGS = -std=gnu11 -O3 -Wall -Wextra -Wpedantic -Wstrict-aliasing 
CC = gcc
CPP = gcc
#CPPFLAGS ?= $(CLFAGS) -MMD -MP


#EXECUTABLE RULES
#remembr the .o file rule below will not compile if there isn't a call for it 
#in the prereqs of another rule. Same with all % pattern rules.

#puts target in build directory
$(BUILD_DIR)/$(TARGET_EXEC) : $(OBJS)
	$(CC) $^ -o $@ $(LFLAGS)


#DEPENDENCY RULES

# c build and src directory version. Puts .o files in src dir in build dir
#$(BUILD_DIR)/%.c.o : %.c
#	$(__MKDIR) $(dir $@)
#	$(CC) $(CFLAGS) -c $< -o $@

#*****TO DO******
#problem with puting into object directory vs src directory
$(BUILD_DIR)/objects/%.c.o : %.c
#the makes directory named for directory each file came from. For multiple 
#target executables.
	$(__MKDIR) ./build/objects
	$(CC) $(CFLAGS) -c $< -o $@

#assembly version
#$(BUILD_DIR)/%.a.o : %.s
#	$(__MKDIR) $(dir $@)
#	$(AS) $(ASFLAGS) -c $< -o $@

#cpp version
#$(BUILD_DIR)/%.cpp.o : %.cpp
#	$(__MKDIR) $(dir $@)
#	$(CPP) $(CPPFLAGS) -c $< -o $@


#generic version
#Rule below compiles all .c files to .o files, -c compiles and does not link(ma
#kes .o files) -o for named file output
#$@ is target of rule (target is left of : and right is prereqs for that target
# % is pattern rule prereq (finds all matching following pattern), $<name of 
#first prereq, $^ names of all prereq with spaces between.

#%*.o : %*.c
#	$(CC) $< -o $@ $(CFLAGS)

#OTHER RULES

#@ symbol is used at beginning of recipe to not print execution
clean:
	@rm -rf *.o
