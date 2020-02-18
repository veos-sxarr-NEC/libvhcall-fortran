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
!
!-------------------------------------------------------------------------------
MODULE vhcall_fortran_lowlevel
!-------------------------------------------------------------------------------
!-fortran2003 interfaces to the vhcall_cfunctions
!-------------------------------------------------------------------------------
USE, INTRINSIC :: ISO_FORTRAN_ENV
USE, INTRINSIC :: ISO_C_BINDING
IMPLICIT NONE
!-------------------------------------------------------------------------------

!=typedef uint64_t vhcall_handle;
INTERFACE 
!=vhcall_handle vhcall_install(const char *);
FUNCTION vhcall_install (libName) BIND(C,NAME='vhcall_install')
USE, INTRINSIC :: ISO_C_BINDING
IMPLICIT NONE
    INTEGER (KIND=C_INT64_T)                          :: vhcall_install
    CHARACTER (KIND=C_CHAR), DIMENSION(*), INTENT(in) :: libName
END FUNCTION vhcall_install

!=int64_t vhcall_find(vhcall_handle, const char *);
FUNCTION vhcall_find (h, symbolName) BIND(C,NAME='vhcall_find')
USE, INTRINSIC :: ISO_C_BINDING
IMPLICIT NONE
    INTEGER (KIND=C_INT64_T)                          :: vhcall_find
    INTEGER (KIND=C_INT64_T), VALUE,       INTENT(in) :: h   ! vhcall_handle
    CHARACTER (KIND=C_CHAR), DIMENSION(*), INTENT(in) :: symbolName
END FUNCTION vhcall_find

!=long vhcall_invoke(int64_t, const void *, size_t, void *, size_t);
FUNCTION vhcall_invoke (symID, inPtr, in_len, outPtr, out_len) &
                       & BIND(C,NAME='vhcall_invoke')
USE, INTRINSIC :: ISO_C_BINDING
IMPLICIT NONE
    INTEGER (KIND=C_LONG)           :: vhcall_invoke
    INTEGER (KIND=C_INT64_T), VALUE :: symID
    TYPE (C_PTR),             VALUE :: inPtr     ! pointer to object of any type
    INTEGER (KIND=C_SIZE_T),  VALUE :: in_len
    TYPE (C_PTR),             VALUE :: outPtr    ! pointer to object of any type
    INTEGER (KIND=C_SIZE_T),  VALUE :: out_len
END FUNCTION vhcall_invoke

!=int vhcall_uninstall(vhcall_handle);
FUNCTION vhcall_uninstall (h) BIND(C,NAME='vhcall_uninstall')
USE, INTRINSIC :: ISO_C_BINDING
IMPLICIT NONE
    INTEGER (KIND=C_INT)                         :: vhcall_uninstall
    INTEGER (KIND=C_INT64_T), VALUE, INTENT(in)  :: h   !  vhcall_handle
END FUNCTION vhcall_uninstall
!
END INTERFACE

#ifndef VHCALLNOENHANCE
!-from file "vhcall.h"
!
ENUM , BIND(C) ! :: vhcall_args_intent
    ENUMERATOR :: VHCALL_INTENT_IN = 1
    ENUMERATOR :: VHCALL_INTENT_INOUT
    ENUMERATOR :: VHCALL_INTENT_OUT
END ENUM !  vhcall_args_intent
INTEGER, PARAMETER :: vhcall_args_intent = KIND(VHCALL_INTENT_IN)
!

!-interfaces from file "libvhcall.h"
INTERFACE 

!=vhcall_args *vhcall_args_alloc(void);
FUNCTION vhcall_args_alloc ()    BIND(C,NAME='vhcall_args_alloc')
USE, INTRINSIC :: ISO_C_BINDING
IMPLICIT NONE
INTEGER (KIND=C_INT64_T)            :: vhcall_args_alloc
END FUNCTION vhcall_args_alloc

!=int vhcall_args_set_pointer(vhcall_args *, enum vhcall_args_intent,
!                             int, void *, size_t);
FUNCTION vhcall_args_set_pointer (args, argIntent, num, buffer, bufferLen) &
                                & BIND(C,NAME='vhcall_args_set_pointer')
USE, INTRINSIC :: ISO_C_BINDING
IMPORT :: vhcall_args_intent
IMPLICIT NONE
INTEGER (KIND=C_INT)                     :: vhcall_args_set_pointer
INTEGER (KIND=C_INT64_T),                         VALUE :: args
INTEGER (KIND=vhcall_args_intent), VALUE :: argIntent
INTEGER (KIND=C_INT),              VALUE :: num
TYPE (C_PTR),                      VALUE :: buffer         ! object of any kind
INTEGER (KIND=C_SIZE_T),           VALUE :: bufferLen
END FUNCTION vhcall_args_set_pointer

!=int vhcall_invoke_with_args( int64_t, vhcall_args *, uint64_t*);
FUNCTION vhcall_invoke_with_args (symID, args, retval) &
                                & BIND(C,NAME='vhcall_invoke_with_args')
USE, INTRINSIC :: ISO_C_BINDING
IMPLICIT NONE
    INTEGER (KIND=C_INT)            :: vhcall_invoke_with_args
    INTEGER (KIND=C_INT64_T), VALUE :: symID
    INTEGER (KIND=C_INT64_T),                VALUE :: args
    TYPE (C_PTR),             VALUE :: retval              ! C_INT64_T
END FUNCTION vhcall_invoke_with_args

!=void vhcall_args_clear(vhcall_args *);
SUBROUTINE vhcall_args_clear (args) BIND(C,NAME='vhcall_args_clear')
USE, INTRINSIC :: ISO_C_BINDING
IMPLICIT NONE
INTEGER (KIND=C_INT64_T),    VALUE :: args
END SUBROUTINE vhcall_args_clear

!=void vhcall_args_free(vhcall_args *);
SUBROUTINE vhcall_args_free (args) BIND(C,NAME='vhcall_args_free')
USE, INTRINSIC :: ISO_C_BINDING
IMPLICIT NONE
INTEGER (KIND=C_INT64_T),    VALUE :: args
END SUBROUTINE vhcall_args_free

END INTERFACE 

!
#endif
!-------------------------------------------------------------------------------
END MODULE vhcall_fortran_lowlevel

