        USE VHCALL_FORTRAN
        INTEGER(8) :: HANDLE
        INTEGER(8) :: SYM
        INTEGER(8) :: CA
        INTEGER(8) :: RETVAL
        INTEGER    :: IR
        REAL       :: VAL(5) = (/ 1.0,2.0,3.0,4.0,5.0 /)
        HANDLE = FVHCALL_INSTALL('./libvhcall.so')
        ! Case of subroutine
        SYM    = FVHCALL_FIND(HANDLE,'VH_SBR')
        CA     = FVHCALL_ARGS_ALLOC()
        IR     = FVHCALL_ARGS_SET(CA, FVHCALL_INTENT_INOUT, 1, VAL)
        IR     = FVHCALL_ARGS_SET(CA, FVHCALL_INTENT_IN, 2, SIZE(VAL))
        WRITE(*,*)"VH subroutine INPUT > ",VAL
        IR     = FVHCALL_INVOKE_WITH_ARGS(SYM, CA)
        IF (IR==1) THEN
            WRITE(*,*)"Fail to invoke subroutine"
            STOP(1)
        ENDIF
        WRITE(*,*)"VH subroutine OUTPUT> ",VAL
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
