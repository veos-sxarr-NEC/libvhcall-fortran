        USE VHCALL_FORTRAN
        INTEGER(8)    :: HANDLE
        INTEGER(8)    :: SYM
        INTEGER(8)    :: CA
        INTEGER(8)    :: RETVAL
        INTEGER       :: IR
        CHARACTER(10) :: STR = "Hello"
        REAL          :: VAL(2,2,3)
        data VAL / 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0 /
        HANDLE = FVHCALL_INSTALL('./libvhcall.so')
        ! Case of subroutine(1)
        SYM    = FVHCALL_FIND(HANDLE,'VH_SBR1')
        CA     = FVHCALL_ARGS_ALLOC()
        IR     = FVHCALL_ARGS_SET(CA, FVHCALL_INTENT_INOUT, 1, STR)
        IR     = FVHCALL_ARGS_SET(CA, FVHCALL_INTENT_IN, 2, 10)
        WRITE(*,*)"VH subroutine INPUT(1) > ",STR
        IR     = FVHCALL_INVOKE_WITH_ARGS(SYM, CA)
        IF (IR==1) THEN
            WRITE(*,*)"Fail to invoke subroutine"
            STOP(1)
        ENDIF
        WRITE(*,*)"VH subroutine OUTPUT(1) > ",STR
        ! Case of subroutine(2)
        SYM    = FVHCALL_FIND(HANDLE,'VH_SBR2')
        CA     = FVHCALL_ARGS_ALLOC()
        IR     = FVHCALL_ARGS_SET(CA, FVHCALL_INTENT_INOUT, 1, VAL)
        IR     = FVHCALL_ARGS_SET(CA, FVHCALL_INTENT_IN, 2, 2)
        IR     = FVHCALL_ARGS_SET(CA, FVHCALL_INTENT_IN, 3, 2)
        IR     = FVHCALL_ARGS_SET(CA, FVHCALL_INTENT_IN, 4, 3)
        WRITE(*,*)"VH subroutine INPUT(2) > ",VAL
        IR     = FVHCALL_INVOKE_WITH_ARGS(SYM, CA)
        IF (IR==1) THEN
            WRITE(*,*)"Fail to invoke subroutine"
            STOP(1)
        ENDIF
        WRITE(*,*)"VH subroutine OUTPUT(2) > ",VAL
        ! Case of function
        SYM    = FVHCALL_FIND(HANDLE,'VH_MOD::VH_FUNC')
        CALL     FVHCALL_ARGS_CLEAR(CA)
        IR     = FVHCALL_INVOKE_WITH_ARGS(SYM, CA, RETVAL)
        IF (IR==1) THEN
            WRITE(*,*)"Fail to invoke function"
            STOP(1)
        ENDIF
        WRITE(*,*)"VH function return ",RETVAL
        CALL     FVHCALL_ARGS_FREE(CA)
        IR     = FVHCALL_UNINSTALL(HANDLE)
        STOP
        END
