!
! Copyright (C) 2019-2020 by NEC Corporation
!
! Permission is hereby granted, free of charge, to any person obtaining a copy
! of this software and associated documentation files (the "Software"), to
! deal in the Software without restriction, including without limitation the
! rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
! sell copies of the Software, and to permit persons to whom the Software is
! furnished to do so, subject to the following conditions:
!
! The above copyright notice and this permission notice shall be included in
! all copies or substantial portions of the Software.
!
! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
! IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
! AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
! LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
! FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
! IN THE SOFTWARE.
!-------------------------------------------------------------------------------
!
!-------------------------------------------------------------------------------
!> \mainpage Introduction
!>
!> The libvhcall-fortran package contains a library which is used by VE
!> programs to invoke Fortran subroutine or function on VH side.
!>
!> To build VE programs using a library in the libvhcall-fortran package,
!> libvhcall-fortran-devel package needs to be installed.
!>
!> \author NEC Corporation
!> \copyright 2019-2022. Licensed under the terms of the MIT license.
!>
!> @par Revision History
!>      Revision,
!>      Date,
!>      Updates/Remarks
!> @par
!>      Rev.7,
!>      Mar. 2022, @n
!>      This revision covers libvhcall-fortran-2.11.0 or later. @n
!>      Added descriptions for new APIs to pass an INTEGER(KIND=8) array, and a CHARACTER array.
!> @par 
!>      Rev.6, 
!>      Mar. 2021, @n
!>      This revision covers libvhcall-fortran-2.7 or later. @n
!>      Added "Revision History".
!> @par 
!>      Rev.5,
!>      Sep. 2020, @n
!>      This revision covers libvhcall-fortran-2.7 or later. @n
!>      Added descriptions for new APIs to pass an INTEGER array.
!> @par 
!>      Rev.4, 
!>      Mar. 2020, @n
!>      This revision covers libvhcall-fortran-2.5 or later. @n
!>      Updated a note for supporting gfortran.
!>
!>
!-------------------------------------------------------------------------------
!
!-------------------------------------------------------------------------------
!> @file vhcall_fortran.F03
!> @brief Fortran wrapper for VH Call
!> fortran_vhcall VH call Fortran wrapper
!
!> VH call Fortran API provides features which invoke Fortran
!> subroutine or function on VH side from a VE program.
!>
!> The arguments need to be string, scalar or 1-3 dimensional array.
!> - Type of scalar and array is INTEGER, INTEGER(kind=8), REAL, DOUBLE, COMPLEX ,DOUBLE 
!>   COMPLEX or CHARACTER.
!> - Array object needs to be contiguous on memory e.g. array(::-1) or
!>   array(1,:) can't be specified.
!>
!> The return value of function needs to be 64bit INTEGER.
!>
!> @note To define VH function with variable length string or array, passing the
!>       length of it from VE is required e.g. can't use asterisk or double
!>       colon like CHARACTER(LEN=*) or array(:). Here is a sample of
!>       definition:
!>        @code
!>              Function func(len, str, ...)
!>              INTEGER(8) :: func
!>              INTEGER    :: len
!>              CHARACTER(len=len) :: str ! Can't use CHARACTER(len=*)
!>              ...
!>
!>              Function func(len, arr, ...)
!>              INTEGER(8) :: func
!>              INTEGER    :: len
!>              REAL :: arr(len)          ! Can't use REAL :: arr(:)
!>              ...
!>        @endcode
!>
!> @note The arguments of VH function/subroutine can't be defined with
!>       VALUE, POINTER or ALLOCATABLE.
!>
!> Please add the following code and specify -lvhcall_fortran option to 
!> compile VE fortran program.
!> @code
!> USE VHCALL_FORTRAN
!> @endcode
!> @note  Fortran compiler for VH is only supported gfortran 4.8.5 or 8.3.1.
!>        Using other fortran compilers may cause unexpected behavior.
!-------------------------------------------------------------------------------
MODULE vhcall_fortran
!-------------------------------------------------------------------------------
!-fortran2003 interfaces to the vhcall_cfunctions
!-------------------------------------------------------------------------------
!
!-------------------------------------------------------------------------------
USE, INTRINSIC :: ISO_FORTRAN_ENV
USE, INTRINSIC :: ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
!-------------------------------------------------------------------------------
!> @brief Interface of setting value to VH Call arguments object.
!>
!> @detail By using generic name vhcall_args_set, one of function in the 
!>         following list is invoked depending on type of argument given.
!>
!> @detail For detail of the argument, please refer to API of each function.
!>
!> - fvhcall_args_set_string
!> - fvhcall_args_set_integer
!> - fvhcall_args_set_iarr_d1
!> - fvhcall_args_set_iarr_d2
!> - fvhcall_args_set_iarr_d3
!> - fvhcall_args_set_integer8
!> - fvhcall_args_set_i8arr_d1
!> - fvhcall_args_set_i8arr_d2
!> - fvhcall_args_set_i8arr_d3
!> - fvhcall_args_set_real
!> - fvhcall_args_set_rarr_d1
!> - fvhcall_args_set_rarr_d2
!> - fvhcall_args_set_rarr_d3
!> - fvhcall_args_set_double
!> - fvhcall_args_set_darr_d1
!> - fvhcall_args_set_darr_d2
!> - fvhcall_args_set_darr_d3
!> - fvhcall_args_set_complex
!> - fvhcall_args_set_carr_d1
!> - fvhcall_args_set_carr_d2
!> - fvhcall_args_set_carr_d3
!> - fvhcall_args_set_double_complex
!> - fvhcall_args_set_dcarr_d1
!> - fvhcall_args_set_dcarr_d2
!> - fvhcall_args_set_dcarr_d3
!> - fvhcall_args_set_charr_d1
!> - fvhcall_args_set_charr_d2
!> - fvhcall_args_set_charr_d3
INTERFACE fvhcall_args_set
    PROCEDURE fvhcall_args_set_string,  &
             &fvhcall_args_set_integer, fvhcall_args_set_iarr_d1, &
             &fvhcall_args_set_iarr_d2, fvhcall_args_set_iarr_d3, &
             &fvhcall_args_set_integer8, fvhcall_args_set_i8arr_d1, &
             &fvhcall_args_set_i8arr_d2, fvhcall_args_set_i8arr_d3, &
             &fvhcall_args_set_real,    fvhcall_args_set_rarr_d1, &
             &fvhcall_args_set_rarr_d2, fvhcall_args_set_rarr_d3, &
             &fvhcall_args_set_double,  fvhcall_args_set_darr_d1, &
             &fvhcall_args_set_darr_d2, fvhcall_args_set_darr_d3, &
             &fvhcall_args_set_complex, fvhcall_args_set_carr_d1, &
             &fvhcall_args_set_carr_d2, fvhcall_args_set_carr_d3, &
             &fvhcall_args_set_double_complex, fvhcall_args_set_dcarr_d1, &
             &fvhcall_args_set_dcarr_d2,       fvhcall_args_set_dcarr_d3, &
             &fvhcall_args_set_charr_d1, &
             &fvhcall_args_set_charr_d2, fvhcall_args_set_charr_d3
END INTERFACE fvhcall_args_set

!> @brief Intent of argument. Argument is used as input
INTEGER, PARAMETER :: FVHCALL_INTENT_IN=1
!> @brief Intent of argument. Argument is used as output.
!> @note  Don't use this for literal or value with PARAMETER attribute.
INTEGER, PARAMETER :: FVHCALL_INTENT_OUT=3
!> @brief Intent of argument. Argument is used as input and output.
!> @note  Don't use this for literal or value with PARAMETER attribute.
INTEGER, PARAMETER :: FVHCALL_INTENT_INOUT=2

contains
!-------------------------------------------------------------------------------
!> @brief Load a VH library.
!> @param[in] libName file name to load on VH
!> @return On success, returns 64-bit integer specifying handle of the VH
!>         library. On failure, returns -1.
FUNCTION fvhcall_install (libName)
USE, INTRINSIC :: ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER(int64)           :: fvhcall_install
    CHARACTER(LEN=*),INTENT(IN)    :: libName
    fvhcall_install=vhcall_install(TRIM(libName) // C_NULL_CHAR)
END FUNCTION fvhcall_install

!> @brief Find a symbol in VH library.
!> @param[in] handle 64-bit integer specifying handle of VH library
!> @param[in] symbolName the name of function or subroutine.
!>            Function or subroutine in module is found
!>            by moduleName::symbolName.
!> @return On success, returns 64-bit integer specifying symbol of the VH
!>         function or subroutine. On failure, returns -1.
FUNCTION fvhcall_find (handle, symbolName)
USE, INTRINSIC :: ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER(int64)           :: fvhcall_find
    INTEGER(int64),    VALUE :: handle
    CHARACTER(LEN=*),INTENT(IN)    :: symbolName
    CHARACTER(LEN=LEN_TRIM(symbolName)) c_symbol
    INTEGER i, d1, d2
    c_symbol = TRIM(symbolName)
    DO I=1, LEN_TRIM(c_symbol)
        IF (c_symbol(i:i) >= 'A' .AND. c_symbol(i:i) <= 'Z') THEN
            c_symbol(i:i) = achar(iachar(c_symbol(i:i))+32)
        END IF
    END DO
    d1 = SCAN(c_symbol,':')
    d2 = SCAN(c_symbol,':',BACK=.TRUE.)
    IF (d1+1 == d2) THEN
        fvhcall_find=vhcall_find(handle, '__' // c_symbol(1:d1-1) // '_MOD_' // &
        &c_symbol(d2+1:LEN(c_symbol)) // C_NULL_CHAR)
    ELSE
        fvhcall_find=vhcall_find(handle, c_symbol // '_' // C_NULL_CHAR)
    END IF
END FUNCTION fvhcall_find

!> @brief Unload a VH library.
!> @param[in] handle 64-bit integer specifying handle of the VH library
!> @return On success, returns 0. On failure, returns non-zero value returned 
!>         from dlclose() on VH.
FUNCTION fvhcall_uninstall (handle)
USE, INTRINSIC :: ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER             :: fvhcall_uninstall
    INTEGER(int64),    VALUE :: handle
    fvhcall_uninstall=vhcall_uninstall(handle)
END FUNCTION fvhcall_uninstall

!> @brief Allocate VH Call arguments object.
!> @return On success, returns 64-bit integer specifying arguments object.
!>         On failure, returns 0.
FUNCTION fvhcall_args_alloc()
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER(int64)          :: fvhcall_args_alloc
    fvhcall_args_alloc=vhcall_args_alloc()
END FUNCTION fvhcall_args_alloc

!> @brief Allocate VH Call arguments object which can contain optional argument.
!> @param[in] num number of arguments.
!> @return On success, returns 64-bit integer specifying arguments object.
!>         On failure, returns 0.
FUNCTION fvhcall_args_alloc_num(num)
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER(int64)          :: fvhcall_args_alloc_num
    INTEGER,          VALUE :: num
    fvhcall_args_alloc_num=vhcall_args_alloc_num(num)
END FUNCTION fvhcall_args_alloc_num

!> @brief Clear VH Call arguments object.
!> @param[in] args 64-bit integer specifying arguments object
SUBROUTINE fvhcall_args_clear (args)
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER(int64),    VALUE :: args
    CALL vhcall_args_clear(args)
END SUBROUTINE fvhcall_args_clear

!> @brief Free VH Call arguments object.
!> @param[in] args 64-bit integer specifying arguments object
SUBROUTINE fvhcall_args_free (args)
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER(int64),    VALUE :: args
    CALL vhcall_args_free(args)
END SUBROUTINE fvhcall_args_free

!> @brief Invoke a function or subroutine in VH library with passing arguments.
!> @note  If values in args are changed before invoking 
!>        fvhcall_invoke_with_args, the changed value is passed
!>        to VH function or subroutine.
!> @note  A function in VH library need to return 64-bit integer.
!> @param[in] symID 64-bit integer specifying symbol of 
!>            the VH subroutine or function
!> @param[in] args 64-bit integer specifying arguments object
!> @param[out] retval 64-bit integer return value of VH library function.
!>             This is omitted when symID specifies subroutine.
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_invoke_with_args (symID, args, retval)
USE, INTRINSIC :: ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER             :: fvhcall_invoke_with_args
    INTEGER(int64),   VALUE :: symID
    INTEGER(int64),   VALUE :: args
    INTEGER(int64),OPTIONAL,   TARGET :: retval
    IF (PRESENT(retval)) THEN
        fvhcall_invoke_with_args=vhcall_invoke_with_args(symID, args, &
        &C_LOC(retval))
    ELSE
        fvhcall_invoke_with_args=vhcall_invoke_with_args(symID, args, &
        &C_NULL_PTR)
    END IF
END FUNCTION fvhcall_invoke_with_args

!> @brief Set a character(len=n) argument: n is the length of character (n>=1).
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!>
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_string (args, intent, argnum, val)
USE, INTRINSIC :: ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_string
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    CHARACTER(LEN=*),TARGET :: val
    INTEGER(int64)            :: BUFLEN
    BUFLEN = LEN(val)
    fvhcall_args_set_string=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION  fvhcall_args_set_string

!> @brief Set an integer argument.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_integer (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_integer
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    INTEGER,      TARGET :: val
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val)
    fvhcall_args_set_integer=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_integer

!> @brief Set an argument of 1 dimensional array of type integer.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_iarr_d1 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_iarr_d1
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    INTEGER,     TARGET :: val(:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1))*size(val)
    fvhcall_args_set_iarr_d1=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_iarr_d1

!> @brief Set an argument of 2 dimensional array of type integer.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_iarr_d2 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_iarr_d2
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    INTEGER,         TARGET :: val(:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1))*size(val)
    fvhcall_args_set_iarr_d2=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_iarr_d2

!> @brief Set an argument of 3 dimensional array of type integer.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_iarr_d3 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_iarr_d3
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    INTEGER,         TARGET :: val(:,:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1,1))*size(val)
    fvhcall_args_set_iarr_d3=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_iarr_d3

!> @brief Set an integer(kind=8) argument.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_integer8 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_integer8
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    INTEGER(kind=8),      TARGET :: val
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val)
    fvhcall_args_set_integer8=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_integer8

!> @brief Set an argument of 1 dimensional array of type integer(kind=8).
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_i8arr_d1 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_i8arr_d1
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    INTEGER(kind=8),     TARGET :: val(:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1))*size(val)
    fvhcall_args_set_i8arr_d1=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_i8arr_d1

!> @brief Set an argument of 2 dimensional array of type integer(kind=8).
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_i8arr_d2 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_i8arr_d2
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    INTEGER(kind=8),         TARGET :: val(:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1))*size(val)
    fvhcall_args_set_i8arr_d2=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_i8arr_d2

!> @brief Set an argument of 3 dimensional array of type integer(kind=8).
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_i8arr_d3 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_i8arr_d3
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    INTEGER(kind=8),         TARGET :: val(:,:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1,1))*size(val)
    fvhcall_args_set_i8arr_d3=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_i8arr_d3

!> @brief Set a real argument.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_real (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_real
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    REAL,         TARGET :: val
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val)
    fvhcall_args_set_real=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_real

!> @brief Set an argument of 1 dimensional array of type real.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_rarr_d1 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_rarr_d1
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    REAL,         TARGET :: val(:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1))*size(val)
    fvhcall_args_set_rarr_d1=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_rarr_d1

!> @brief Set an argument of 2 dimensional array of type real.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_rarr_d2 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_rarr_d2
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    REAL,         TARGET :: val(:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1))*size(val)
    fvhcall_args_set_rarr_d2=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_rarr_d2

!> @brief Set an argument of 3 dimensional array of type real.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_rarr_d3 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_rarr_d3
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    REAL,         TARGET :: val(:,:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1,1))*size(val)
    fvhcall_args_set_rarr_d3=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_rarr_d3

!> @brief Set a double argument.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_double (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_double
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    DOUBLE PRECISION,TARGET ::val
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val)
    fvhcall_args_set_double=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_double

!> @brief Set an argument of 1 dimensional array of type double.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_darr_d1 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_darr_d1
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    DOUBLE PRECISION,TARGET ::val(:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1))*size(val)
    fvhcall_args_set_darr_d1=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_darr_d1

!> @brief Set an argument of 2 dimensional array of type double.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_darr_d2 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_darr_d2
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    DOUBLE PRECISION,TARGET ::val(:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1))*size(val)
    fvhcall_args_set_darr_d2=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_darr_d2

!> @brief Set an argument of 3 dimensional array of type double.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_darr_d3 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_darr_d3
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    DOUBLE PRECISION,TARGET ::val(:,:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1,1))*size(val)
    fvhcall_args_set_darr_d3=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_darr_d3

!> @brief Set a complex argument.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_complex (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_complex
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    COMPLEX,         TARGET :: val
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val)
    fvhcall_args_set_complex=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_complex

!> @brief Set an argument of 1 dimensional array of type complex.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_carr_d1 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_carr_d1
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    COMPLEX,      TARGET :: val(:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1))*size(val)
    fvhcall_args_set_carr_d1=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_carr_d1

!> @brief Set an argument of 2 dimensional array of type complex.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_carr_d2 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_carr_d2
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    COMPLEX,      TARGET :: val(:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1))*size(val)
    fvhcall_args_set_carr_d2=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_carr_d2

!> @brief Set an argument of 3 dimensional array of type complex.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_carr_d3 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_carr_d3
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    COMPLEX,      TARGET :: val(:,:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1,1))*size(val)
    fvhcall_args_set_carr_d3=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_carr_d3

!> @brief Set a double complex argument.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_double_complex (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_double_complex
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    COMPLEX(kind(0d0)), TARGET :: val
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val)
    fvhcall_args_set_double_complex=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_double_complex

!> @brief Set an argument of 1 dimensional array of type double complex.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_dcarr_d1 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_dcarr_d1
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    COMPLEX(kind(0d0)), TARGET :: val(:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1))*size(val)
    fvhcall_args_set_dcarr_d1=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_dcarr_d1

!> @brief Set an argument of 2 dimensional array of type double complex.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_dcarr_d2 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_dcarr_d2
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    COMPLEX(kind(0d0)), TARGET :: val(:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1))*size(val)
    fvhcall_args_set_dcarr_d2=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_dcarr_d2

!> @brief Set an argument of 3 dimensional array of type double complex.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_dcarr_d3 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_dcarr_d3
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    COMPLEX(kind(0d0)), TARGET :: val(:,:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1,1))*size(val)
    fvhcall_args_set_dcarr_d3=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_dcarr_d3

!> @brief Set an argument of 1 dimensional array of type character.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_charr_d1 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_charr_d1
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    CHARACTER,         TARGET :: val(:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1))*size(val)
    fvhcall_args_set_charr_d1=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_charr_d1

!> @brief Set an argument of 2 dimensional array of type character.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_charr_d2 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_charr_d2
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    CHARACTER,         TARGET :: val(:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1))*size(val)
    fvhcall_args_set_charr_d2=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_charr_d2

!> @brief Set an argument of 3 dimensional array of type character.
!> @note  Value set to args need to be able to be referenced at invoking
!>        fvhcall_invoke_with_args.
!> @note  Value set to args need to have same type(kind) and shape
!>        of argument on VH side because VE and VH would like to access
!>        same data.
!> @param[in] args 64-bit integer specifying arguments object
!> @param[in] intent parameter of fvhcall_intent_[in/out/inout].
!>            This specifies what the argument is used for input,
!>            output or input/output.
!> @param[in] argnum the argnum-th argument of callee function (counting
!>            from 1).
!> @param[in] val value to be set
!> @return On success, returns 0. On failure, returns -1.
FUNCTION fvhcall_args_set_charr_d3 (args, intent, argnum, val)
USE ISO_C_BINDING
USE VHCALL_FORTRAN_LOWLEVEL
IMPLICIT NONE
    INTEGER              :: fvhcall_args_set_charr_d3
    INTEGER(int64),     VALUE :: args
    INTEGER,     VALUE :: intent
    INTEGER,     VALUE :: argnum
    CHARACTER,         TARGET :: val(:,:,:)
    INTEGER(int64)            :: BUFLEN
    BUFLEN = C_SIZEOF(val(1,1,1))*size(val)
    fvhcall_args_set_charr_d3=vhcall_args_set_pointer(args, &
    intent, argnum-1, C_LOC(val), BUFLEN)
END FUNCTION fvhcall_args_set_charr_d3

!-------------------------------------------------------------------------------
END MODULE vhcall_fortran


