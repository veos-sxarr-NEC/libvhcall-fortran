        SUBROUTINE VH_SBR1(STR, LEN)
        IMPLICIT NONE
        INTEGER LEN
        CHARACTER(LEN) STR
        STR = "World!!"
        RETURN
        END SUBROUTINE VH_SBR1

        SUBROUTINE VH_SBR2(VAL, LEN1, LEN2, LEN3)
        IMPLICIT NONE
        INTEGER LEN1, LEN3, LOC_LEN2
        INTEGER, OPTIONAL :: LEN2
        REAL VAL(LEN1,2,LEN3)
        IF (present(LEN2)) THEN
               WRITE(*,*) "LEN2 ",LEN2
               LOC_LEN2=LEN2
        ELSE
               WRITE(*,*) "LEN2 ABSENT"
               LOC_LEN2=2
        END IF
        VAL = VAL(LEN1:1:-1,LOC_LEN2:1:-1,LEN3:1:-1)
        RETURN
        END SUBROUTINE VH_SBR2

        MODULE VH_MOD
        CONTAINS
            FUNCTION VH_FUNC()
            IMPLICIT NONE
            INTEGER(8) VH_FUNC
            WRITE(*,*) "[This is function in module on VH]"
            VH_FUNC=1
            RETURN
            END FUNCTION VH_FUNC
        END MODULE VH_MOD
