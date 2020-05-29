        SUBROUTINE VH_SBR(VAL, LEN)
        IMPLICIT NONE
        INTEGER LEN
        REAL VAL(LEN)
        VAL = VAL(LEN:1:-1)
        RETURN
        END SUBROUTINE VH_SBR

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
