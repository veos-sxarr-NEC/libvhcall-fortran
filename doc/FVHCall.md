# Getting Started with VH Call Fortran API
VH call Fortran API is a mechanism to append functions or subroutines in shared 
libraries on Vector Host (VH) as system calls on Vector Engine (VE).

## Introduction
SX-Aurora TSUBASA provides VH call Fortran API for invoking functions or 
subroutines in shared libraries on VH from a VE program as system calls.
VH call Fortran API enables to develop a Fortran program using both VE 
and VH computing resources.
It would be useful for offloading I/O and procedures not well-vectorized.

## Prerequisite

To develop VE programs using VH call Fortran API, please install 
libvhcall-fortran-devel package,
which has vhcall_fotran.mod file declaring VH call Fortran API functions.

For example, execute the following command as root.
~~~
# yum install libvhcall-fortran-devel
~~~

If you execute a program using VH call only, no extra packages are required.

## VE APIs of VH Call Fortran to invoke function or subroutines
A VE program using VH Call needs to declare `"USE VHCALL_FORTRAN"` and specify -lvhcall_fortran with compiling by nfort.
In the module, the following API functions or subroutines are declared.

- `fvhcall_install()` loads a VH shared library.
- `fvhcall_find()` searches an address of a symbol a function in the VH library.
- `fvhcall_args_alloc()` allocates FVHCall arguments object (vhcall_args).
- `fvhcall_args_set()` sets an argument of string, scalar or 1-3 dimensional array.
- `fvhcall_args_clear()` clears arguments set in FVHCall arguments object.
- `fvhcall_args_free()` frees FVHCall arguments object.
- `fvhcall_invoke_with_args()` invokes a function or subroutine on VH side with passing arguments.
- `fvhcall_uninstall()` unloads a VH shared library.

For VE side, sending data to VH is implemented as API of passing arguments which INTENT is IN or INOUT. Receiving data from VH is also implemented as return value or argument which INTENT is OUT or INOUT.

Please see [VH Call Fortran](classvhcall__fortran.html) for more detail.

## VH shared library Function or Subroutine
User can define Fortran function or subroutine for VH as below:
- The arguments need to be string, scalar or 1-3 dimension array.
- Type of scalar and array is INTEGER, REAL, DOUBLE, COMPLEX or DOUBLE COMPLEX.
- Array object needs to be contiguous on memory e.g. array(::-1) or array(1,:) can't be specified.
- The return value of function needs to be 8byte INTEGER.

Please see [VH Call Fortran](classvhcall__fortran.html#details) for more detail.

## Example programs

This is a simple program using VH Call Fortran API.

Program invokes VH Fortran library subroutine and function.
Subroutine has two arguments, real 1-dimensional array and integer of array size.
Function has no argument and is defined in module.

Steps of program are below.
1. Load a VH Fortran library by `fvhcall_install()`, which returns a FVHCall handle,
 an identifier to specify the VH library loaded.
2. Get a symbol ID, an identifier of a subroutine in a VH library,
 by `fvhcall_find()` with the name of a subroutine and a VH call handle.
3. Create an arguments object by `fvhcall_args_alloc()` and set value by `fvhcall_args_set()`
4. Invoke a subroutine `fvhcall_invoke_with_args()`.
  - The subroutine is specified by its symbol ID of 1st argument.
  - The arguments are passed as an arguments object of 2nd argument.
5. Get a symbol ID, an identifier of a function in module of a VH library.
6. Clear an arguments object.
7. Invoke a function `fvhcall_invoke_with_args()`.
  - The function is specified by its symbol ID of 1st argument.
  - The arguments are passed as an arguments object of 2nd argument.
  - The return values is got as 8byte integer of 3rd argument.
8. Free the arguments object by`fvhcall_args_free()`.
9. Unload the VH library by `fvhcall_uninstall()`.


#### Files

 - [examples/sample.f](sample_8f-example.html) is VE program using VH Call Fortran API
 - [examples/libvhcall.f](libvhcall_8f-example.html) is VH Fortran library invoked from VE
 - [examples/Makefile](Makefile-example.html) builds programs

#### Build programs

Put all files of this sample in the same directory.

Build the programs.
~~~
$ make
~~~

#### Execute programs


~~~
$ ./sample
 VH subroutine INPUT >    1.0000000   2.0000000   3.0000000   4.0000000   5.0000000
 VH subroutine OUTPUT>    5.0000000   4.0000000   3.0000000   2.0000000   1.0000000
 [This is function in module on VH]
 VH function return  1
~~~


@example sample.f
@example libvhcall.f
@example Makefile
