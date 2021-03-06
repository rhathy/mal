GOTO MAIN

REM $INCLUDE: 'readline.in.bas'
REM $INCLUDE: 'types.in.bas'
REM $INCLUDE: 'reader.in.bas'
REM $INCLUDE: 'printer.in.bas'

REM $INCLUDE: 'debug.in.bas'

REM READ(A$) -> R
MAL_READ:
  GOSUB READ_STR
  RETURN

REM EVAL(A, E) -> R
SUB EVAL
  R=A
END SUB

REM PRINT(A) -> R$
MAL_PRINT:
  AZ=A:PR=1:GOSUB PR_STR
  RETURN

REM REP(A$) -> R$
SUB REP
  GOSUB MAL_READ
  IF ER<>-2 THEN GOTO REP_DONE

  A=R:CALL EVAL
  IF ER<>-2 THEN GOTO REP_DONE

  A=R:GOSUB MAL_PRINT
  RT$=R$

  REP_DONE:
    REM Release memory from EVAL
    AY=R:GOSUB RELEASE
    R$=RT$
END SUB

REM MAIN program
MAIN:
  GOSUB INIT_MEMORY

  ZT=ZI: REM top of memory after base repl_env

  REPL_LOOP:
    A$="user> ":GOSUB READLINE: REM call input parser
    IF EZ=1 THEN GOTO QUIT

    A$=R$:CALL REP: REM call REP

    IF ER<>-2 THEN GOSUB PRINT_ERROR:GOTO REPL_LOOP
    PRINT R$
    GOTO REPL_LOOP

  QUIT:
    REM GOSUB PR_MEMORY_SUMMARY
    END

  PRINT_ERROR:
    PRINT "Error: "+ER$
    ER=-2:ER$=""
    RETURN

