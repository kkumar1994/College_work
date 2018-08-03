*-----------------------------------------------------------
* Title      :  68K MONITOR PROGRAM
* Written by :  Karthikeyan 
* Date       :  08.2017
* Description:  
*-----------------------------------------------------------
    ORG    $1000
    
CR      EQU     $0D     ; CARRIAGE RETURN
LF      EQU     $0A     ; LINE FEED

STACK       EQU $3000   ;TO INITIALIZE STACK POINTER VALUE

INPUT       EQU $2A00   ;TO INITIALIZE THE INPUT MEMORY

;----------------------BUFFER ALLOCATION---------------------------------
COMMAND_BUF    EQU $3600    

OUTPUT_BUF    EQU $3700

INPUT_BUF     EQU $3A00

;-------------------------MENU TABLE-----------------------------------------
MENU_TBL
        DC.B 'HELP ',0
        DC.B 'MDSP ',0
        DC.B 'SORTW ',0
        DC.B 'MM ',0
        DC.B 'MS ',0
        DC.B 'BF ',0
        DC.B 'BMOV ',0
        DC.B 'BTST ',0
        DC.B 'BSCH ',0
        DC.B 'GO ',0
        DC.B 'DF ',0
        DC.B 'EXIT ',0
        DC.B 'MULT ',0
        DC.B 'SF',0
END_TBL DC.B 'SWAP ',0

;------------------------LIST OF MESSAGES-------------------------------

SR_MSG      DC.B	'SR=',0
REG_MSG     DC.B 'D0=D1=D2=D3=D4=D5=D6=D7=A0=A1=A2=A3=A4=A5=A6=A7='

MEM_MSG
    DC.B 'MEMORY IN THIS LOCATION IS  ',0
    
BLKTST_PASS              
    DC.B  'BLOCK TEST PASSED! ',0
ERROR_AA
    DC.B  'UNABLE TO WRITE AA IN LOCATION: ',0
ERROR_55   
    DC.B  'UNABLE TO WRITE 55 IN LOCATION: ',0 
NULL
    DC.B ' ',CR,LF,0
    
BLKSRCH_MSG
    DC.B 'ENTER THE STRING TO BE SEARCHED: ',0
BLKSRCH_OUT_MSG
    DC.B 'THE MATCHED PATTERN IS (IF NOT MATCHED, NULL OUTPUT): ',0
BLKSRCH_TEST_MSG
    DC.B 'HELLO WORLD',0
    
;------------------------------ERROR MESSAGES-------------------------------
CMD_ERROR 
    DC.B 'UNACCEPTABLE COMMAND',0       
PM_ERROR_MSG
    DC.B 'PARAMETERS FORMAT ERROR',0
TST_ERROR_MSG
    DC.B 'ACCESS FAILURE AT: ',0

BUS_ERROR_MSG
    DC.B    'A BUS ERROR HAS OCCURRED',CR,LF,0
ADDR_ERROR_MSG
    DC.B    'AN ADDRESS ERROR HAS OCCURRED',CR,LF,0    
ILL_CMD_MSG
    DC.B    'INVALID COMMAND',CR,LF,0
PRI_VIO_MSG
    DC.B    'PRIVILEGE VIOLATION',CR,LF,0
DIV_ZERO_MSG
    DC.B    'YOU CANNOT DIVIDE BY ZERO',CR,LF,0
CHK_CMD_MSG
    DC.B    'TRACE EXCEPTION',CR,LF,0
LINE_A_MSG
    DC.B    'LINE A EXCEPTION',CR,LF,0
LINE_F_MSG
    DC.B    'LINE F EXCEPTION',CR,LF,0
        
        
PROMPT  DC.B 'Monitor 441> ',0

;-----------------------Help Display----------------------------------------
 
HELP_DISPLAY
    DC.B    'To display Commands and Usage description, Type "Help"',CR,LF,CR,LF
    DC.B    'MDSP (Memory Display)',CR,LF
    DC.B    'Output the address and memory contents from <address1> to <address2>. ',CR,LF
    DC.B    'MDSP <ADDR1> <ADDR2> e.g. MDSP $1000 $1040 ',CR,LF
    DC.B    'Output the address and memory contents from <address1> to <address1 + 16bytes>',CR,LF
    DC.B    'MDSP <ADDR1> W e.g. MDSP $1000 W ',CR,LF,CR,LF
    DC.B    'SORTW (Sort)',CR,LF
    DC.B    'Sort a block of memory. ',CR,LF
    DC.B    'The order (A or D) specifies whether the list is sorted in Ascending or Descending order.',CR,LF
    DC.B    'The size of the data to be sorted is a word',CR,LF
    DC.B    'SORTW <ADDR1> <ADDR2> A/D e.g. SORTW $1000,$1100 D',CR,LF,CR,LF
    DC.B    'MM (Memory Modify)',CR,LF
    DC.B    'Display memory and modify or enter new data. Size: B(Byte), W(Word), L(Long Word)',CR,LF
    DC.B    'MM <ADDR> B/W/L e.g. MM $1000 L (Then enter the data)',CR,LF,CR,LF
    DC.B    'MS (Memory Set)',CR,LF
    DC.B    'Alter memory by setting data into the specified address. Data is ASCII(A) string or hexadecimal(H)',CR,LF
    DC.B    'MS <ADDR1> <ADDR2> A/H DATA e.g. MS $4000 $4100 A/H HI/$1F0A ',CR,LF,CR,LF
    DC.B    'BF (Block Fill)',CR,LF
    DC.B    'Fill memory from <address1>(even addr)to <address2>(even addr) with word size data',CR,LF
    DC.B    'BF <ADDR1> <ADDR2> DATA.W e.g. BF $1000 $1020 FFFF',CR,LF,CR,LF
    DC.B    'BMOV (Block Move)',CR,LF
    DC.B    'Duplicate blocks of memory from <ADDR1>-<ADDR2> to the address from <ADDR3>',CR,LF
    DC.B    'BMOV <ADDR1> <ADDR2> <ADDR3>  e.g. BMOV $1000 $1100 $4000 ',CR,LF,CR,LF
    DC.B    'BTST (Block Test)',CR,LF
    DC.B    'Test of a block of memory from <address1> to <address2>. ',CR,LF
    DC.B    'Output tested memory and failure memory if test failed',CR,LF
    DC.B    'BTST <ADDR1> <ADDR2> e.g. BTST $3000 $3060 ',CR,LF,CR,LF
    DC.B    'BSCH (Block Search)',CR,LF
    DC.B    'Search a string in a memory block from <address1> to <address2>. ',CR,LF
    DC.B    'Display data if found matched',CR,LF
    DC.B    'BSCH <ADDR1> <ADDR2> DATA e.g. BSCH $1000 $2000 HELLO WORLD',CR,LF,CR,LF
    DC.B    'GO (Execute Program)',CR,LF
    DC.B    'Start execution from a specified address',CR,LF
    DC.B    'GO <ADDR> e.g. GO $2700 ',CR,LF,CR,LF
    DC.B    'DF (Display Formatted Registers)',CR,LF
    DC.B    'Display internal registers including current PC, SR, US, SS and D, A registers',CR,LF
    DC.B    'DF e.g. DF ',CR,LF,CR,LF
    DC.B    'EXIT (Exit Monitor Program)',CR,LF
    DC.B    'Terminates monitor program',CR,LF
    DC.B    'EXIT e.g. EXIT ',CR,LF,CR,LF
    DC.B    'SF (SET FONT COLOR AND STYLE)',CR,LF
    DC.B    'FIRST PARAMETER IS COLOR AS &00BBGGRR (BLUE GREEN RED). EACH BIT FROM 0-9 ONLY.',CR,LF
    DC.B    'SECOND PARAMETER IS FONT STYLE. I IS Italic, B IS BOLD',CR,LF
    DC.B    'SF COLOR_PARAMETER I/B, SF &00983402 I',CR,LF,CR,LF
    DC.B    'SWAP (Swap the Upper and Lower Byte of the Word)',CR,LF
    DC.B    'SWAP <ADDR> e.g. SWAP $1000 ',CR,LF,CR,LF,0
    DC.B    'MULT <ADDR> ',CR,LF,CR,LF,0
    DC.B    'MULT <ADDR1> <ADDR2> e.g. MULT $1000 $2000',CR,LF,CR,LF,0


    
    ORG $1C00        
CMD_ADDR                                        ; COMMAND ADDRES
        DC.L HELP
        DC.L MDSP
        DC.L SORTW
        DC.L MM
        DC.L MS
        DC.L BF
        DC.L BMOV
        DC.L BTST
        DC.L BSCH
        DC.L GO
        DC.L DF
        DC.L EXIT
        DC.L MULT
        DC.L SF
        DC.L SWAP
        

    ORG $2700               ;SAMPLE PROGRAM FOR GO
    LEA GO_DISP, A1
    MOVE.B #13, D0
    TRAP #15
    JMP MONITOR_MAIN    
GO_DISP
    DC.B    'THIS SAMPLE PROGRAM FOR GO INSTRUCTION',CR,LF
    DC.B    'DISPLAY AND RETURN TO PROMPT',CR,LF,CR,LF,0
 
    ORG $1D00


START
    MOVE.L #STACK, $0           ;INITIALIZE SSP
    MOVE.L #BUS_ERR,$8          ;MOVE EXCEPTION HANDLERS
    MOVE.L #ADDR_ERR, $C 
    MOVE.L #ILL_CMD, $10
    MOVE.L #DIV_ZERO, $14
    MOVE.L #CHK_CMD, $18
    MOVE.L #PRI_VIO, $20
    MOVE.L #LINE_A, $28
    MOVE.L #LINE_F, $2C
    
    

MONITOR_MAIN
    LEA PROMPT, A1  
    MOVE.B #14, D0  
    TRAP #15
    LEA INPUT, A1       ;INPUT
    MOVE.B #2, D0
    TRAP #15    
    
    LEA COMMAND_BUF, A2     ;ASSIGN COMMAND BUFFER
IN_STORE
    MOVE.B (A1)+, (A2)+ ;COPY INPUT COMMAND TO A2
    CMPI.B #$20, (A1)   ;COMPARE FOR SPACE, GO TO SAVE_CMD TABLE
    BEQ SAVE_CMD        
    CMPI.B #$00, (A1)   ;IF NULL, SAME AS ABOVE
    BEQ SAVE_CMD
    BRA IN_STORE        ;NONE OF ABOVE, COPY NEXT BYTE


SAVE_CMD
    MOVE.B #$20, (A2)   ;ADD A SPACE TO INPUT COMMAND
    LEA COMMAND_BUF, A2     ;POINT BACK TO THE START OF THE A2
    LEA CMD_ADDR, A4    ;SAVE COMMAND ADDRESS TO A4
    LEA MENU_TBL, A5     ;COPY TABLE TO A5

    
COMPARE_CMD
    CMPM.B (A2)+, (A5)+ ;COMPARE COMMAND AND THE TABLE
    BNE NEXT_CMD        ;IF NOT THIS COMMAND, GO TO NEXT ONE
    CMPI.B #$20, (A2)   ;CHECK IF INPUT COMMAND REACHES A SPACE, IF NOT,KEEP COMPARING
    BNE COMPARE_CMD       

    MOVE.L (A4),A6      ;COMMAND ADDRESS POINTER SAVE TO A6
    JMP (A6)            ;JUMP TO THAT COMMAND LOCATION
    
    
NEXT_CMD
    LEA     COMMAND_BUF, A2 ;POINT BACK TO THE START OF THE COMMAND TO COMPARE TO THE NEXT ONE OF THE TABLE
NEXT_LOOP
    CMPI.B  #$00, (A5)+ ;CHECK FOR NULL 
    BNE     NEXT_LOOP   ;IF NOT, SKIP NEXT LETTER
    ADD     #$04, A4    ;POINTER A4 ADD ONE BYTE (NEXT INSTRUCTOIN IN THE TABLE)
    CMPA    #END_TBL, A5 ;CHECK FOR END OF THE TABLE
    BGT     ERR         ;NONE MATCHED
    JMP     COMPARE_CMD    ;KEEP SEARCHING
    
    
ERR                     ;PRINT COMMAND ERROR MESSAGE
    LEA     CMD_ERROR, A1
    MOVE.B  #13, D0
    TRAP #15
    JMP     MONITOR_MAIN
    
    
SCAN_ADDR            
    CMPI.B  #$24, (A5)   ;SCAN FOR ADDRESS STARTS WITH $
    BNE     PARA_ERR     ;IF NOT A $, ERROR
    CLR D7              
    CLR D6
SAVE_PARA
    ADD     #$01, A5    ;MOVE THE POINTER TO THE RIGHT, SKIP $ IN THE FIRST CYCLE
    MOVE.B  (A5),D6     ;MOVE ONE NUMBER TO D6
    SUB.B   #$30, D6    ;CONVERT TO HEX    
    CMPI.B  #$00, (A5)  ;CHECK FOR END OF THE STRING
    BEQ     PARA_RX     
    CMPI.B  #$20, (A5)  ;CHECK FOR SPACE
    BEQ     PARA_RX
    ROL.L   #4, D7      ;THE NUMBER SHIFT LEFT FOR ONE BYTE
    ADD.L   D6, D7      ;ADD THE NUMBER TO D7
    BRA     SAVE_PARA    ;NEXT NUMBER
    
PARA_ERR                ;PRINT PARAMETER ERROR MESSAGE
    LEA     PM_ERROR_MSG, A1
    MOVE.B  #13, D0
    TRAP #15
    JMP     MONITOR_MAIN
     
PARA_RX
    RTS
    
    
        
	ORG $2000
        
HELP
    LEA HELP_DISPLAY, A1
    MOVE.B #13, D0
    TRAP #15
    JMP MONITOR_MAIN 

MDSP
    LEA     OUTPUT_BUF, A2 ;A2 POINTS TO OUTPUT BUFFER
    LEA     INPUT, A5   ;A5 POINTS TO INPUT
    ADD     #$05, A5    ;SKIP "MDSP "
    JSR     SCAN_ADDR   ;FIRST ADDRESS
    MOVE.L  D7, A2      ;START ADDRESS OF THE OUTPUT 
    ADD     #$01, A5    ;SKIP THE SPACE
    CMPI.B  #$57, (A5)  ;'W'
    BEQ     MDSPW
    JSR MDSPW ;JSR     SCAN_ADDR   ;SECOND ADDRESS
MDSPW_RTS   
    MOVE.L  D7, A3      ;END ADDRESS OF THE OUTPUT
    CLR.L   D1    
    LEA     INPUT, A1   ;GO BACK TO WHERE A1 ORINGINALLY POINTED
CARRIAGE_RETURN
    MOVE.B  #$00, (A1)  ;OPEN UP NEW LINE WITH CR
    MOVE.B  #13, D0
    TRAP    #15
    MOVE.B  #$24, D1
    MOVE    #6, D0
    TRAP    #15
    MOVE.L  A2, D0      ;STARTING ADDRESS SAVE TO D0
    LEA     OUTPUT_BUF, A1 ;A1 POINTS TO BEGINNING OF OUTPUT BUFFER
    MOVE.W  #8, D2      ;LOOP 8 TIMES    
ADDR_LOW
    ROL.L   #4, D0      ;SHIFT LEFT ONE DIGIT
    MOVE.L  D0, D3      ;SAVE SHIFTED DATA TO D3
    AND.L   #$0F, D3    ;CLEAR THE UPPER 4 BITS
    CMPI.B  #$09, D3    ;CAN DISPLAY 9 DIGITS
    BLE     LA
    ADD     #$07, D3  
LA
    ADD     #$30, D3
    MOVE.B  D3, (A1)+
    SUB.W  #1, D2
    BNE     ADDR_LOW
    
    MOVE.B  #$00, (A1)+     ;PUT AN END TO THE STRING
    LEA     OUTPUT_BUF, A1
    MOVE.B  #14, D0
    TRAP #15
    MOVE.B	#$3A, D1    ;ADD A ':'
    MOVE.B	#6, D0
    TRAP	#15
    MOVE.W  #08, D6     ;ONLY DIPLAY 8 BYTES OF MEMORY IN ONE LINE
DISP_MEM
    MOVE.B  #16, D2     ;DISPLAY 16-BASED NUMBER
    CMPA    A2, A3      ;CHECK FOR END OF THE DOCUMENT
    BNE     POP_PROMPT        
    MOVE.B  #$00, D1    ;NEW LINE FOR PROMPT
    MOVE.B  #0, D0  
    TRAP    #15
    JMP     MONITOR_MAIN

POP_PROMPT
    MOVE.B  (A2)+, D1   ;DISPLAY NUMBER
    MOVE.B  #15, D0
    TRAP    #15
    MOVE.B  #$20, D1    ;ADD A SPACE
    MOVE.B  #6, D0
    TRAP    #15
    SUB     #01, D6     ;ONE LESS BYTE TO DISPLAY
    BEQ     CARRIAGE_RETURN ;NEXT LINE
    BRA     DISP_MEM
    
MDSPW
    ADD.B  #$40, D7
    MOVE.L  D7, A3
    BRA  MDSPW_RTS

SORTW
    CLR.L   D7
    CLR.L   D4
    LEA     INPUT, A5   ;POINT TO START OF INPUT STRING
    ADD     #06, A5     ;THEN, SKIP THE "SORTW "
    JSR     SCAN_ADDR   ;JUMP TO SUBROUTINE SCAN_ADDR
    MOVE.L  D7, A2      ;FIRST PARAMETER IN A2
    MOVE.L  D7, A4
    ADD     #01, A5     ;SKIP A SPACE
    JSR     SCAN_ADDR   
    MOVE.L  D7, A3      ;SECOND PARAMETER IN A3
    ADD     #01, A5     ;SKIP SPACE
    CMPI.B  #$41, (A5)  ;'A'
    BEQ     SORTWA
    CMPI.B  #$44, (A5)  ;'D'
    BEQ     SORTWD 
    JMP     PARA_ERR      
  
SORTWA
    MOVE.L A4,A2
SORTA    
    CMP.W  (A2)+,(A2)+   ;COMPARE THE CONTINUOUS TWO WORDS
    BLT.S   EXCHANGEA     	;IF THE LATER IS LARGER
    SUBQ.L  #2,A2     	;A2 SUBSTRATE 2 TO THE NEXT TWO NUMBER TO BE COMPARED
    CMP.L  A2,A3     	;CHECK IF REACHED THE LAST NUMBER
    BNE	SORTA     	;IF NOT RAECH, BACK AND COMPARE THE NEXT TWO NUMBERS
    JMP MONITOR_MAIN 
EXCHANGEA
    MOVE.L -(A2),D4  	;SUBSTRATE TO COMPENSATE THE POST-DECREMENT AND SAVE TWO WORDS TO D0
    SWAP.W D4		;EXCHANGE THE 16-BIT HALVES OF THE REGISTER
    MOVE.L D4,(A2)	;SAVE THE SORTED ORDER INTO A2
    BRA    SORTWA


SORTWD
    MOVE.L A4,A2
SORTD    
    CMP.W  (A2)+,(A2)+   ;COMPARE THE CONTINUOUS TWO WORDS
    BHI.S   EXCHANGED     	;IF THE LATER IS LARGER
    SUBQ.L  #2,A2     	;A2 SUBSTRATE 2 TO THE NEXT TWO NUMBER TO BE COMPARED
    CMP.L  A2,A3     	;CHECK IF REACHED THE LAST NUMBER
    BNE	SORTD     	;IF NOT RAECH, BACK AND COMPARE THE NEXT TWO NUMBERS
    JMP MONITOR_MAIN 
EXCHANGED
    MOVE.L -(A2),D4  	;SUBSTRATE TO COMPENSATE THE POST-DECREMENT AND SAVE TWO WORDS TO D0
    SWAP.W D4		;EXCHANGE THE 16-BIT HALVES OF THE REGISTER
    MOVE.L D4,(A2)	;SAVE THE SORTED ORDER INTO A2
    BRA    SORTWD
SORT_DONE  
    JMP MONITOR_MAIN 



MM
    CLR.L   D7
    LEA     INPUT, A5
    ADD     #03, A5
    JSR     SCAN_ADDR
    LEA     MEM_MSG, A1
    MOVE.B  #13, D0
    TRAP    #15
    MOVE.L  D7, A2      ;ADDRESS IS IN A2
    ADD     #01, A5     ;SKIP SPACE
    CMPI.B  #$42, (A5)  ;'B'
    BEQ     MMB
    CMPI.B  #$57, (A5)  ;'W'
    BEQ     MMW
    CMPI.B  #$4C, (A5)  ;'L'
    BEQ     MML         
    JMP     PARA_ERR    
    
MMB
    JSR     MM_ONE
    MOVE.B  #$3F, D1    ;ADD A ?
    MOVE.B  #6, D0
    TRAP    #15
    LEA INPUT, A1       ;INPUT 
    MOVE.B #2, D0
    TRAP #15
    MOVE.L  D7, A2
    MOVE.B  (A1),(A2)
    SUB.B   #$30,(A2)
    JMP     MM_DIS
MMW
    JSR     MM_ONE
    JSR     MM_ONE  
    MOVE.B  #$3F, D1    ;ADD A ?
    MOVE.B  #6, D0
    TRAP    #15
    LEA INPUT, A1       ;INPUT 
    MOVE.B #2, D0
    TRAP #15
    MOVE.L  D7, A2
    MOVE.W  (A1),(A2)
    SUB.B   #$30,(A2)+
    SUB.B   #$30,(A2)
    JMP     MM_DIS
MML
    JSR     MM_ONE
    JSR     MM_ONE
    JSR     MM_ONE
    JSR     MM_ONE
    MOVE.B  #$3F, D1    ;ADD A ?
    MOVE.B  #6, D0
    TRAP    #15
    LEA INPUT, A1       ;INPUT 
    MOVE.B #2, D0
    TRAP #15
    MOVE.L  D7, A2
    MOVE.L  (A1),(A2)
    SUB.B   #$30,(A2)+
    SUB.B   #$30,(A2)+
    SUB.B   #$30,(A2)+
    SUB.B   #$30,(A2)                  
    JMP     MM_DIS
    
MM_DIS
    JMP MONITOR_MAIN 

MM_ONE
    MOVE.B  (A2)+, D1
    MOVE.B  #16, D2
    MOVE.L  #15,D0
    TRAP    #15    
    MOVE.B  #$20, D1    ;SPACE
    MOVE.B  #6, D0
    TRAP    #15
    RTS



MS
    CLR.L   D7
    LEA     INPUT, A5   ;POINT TO START OF INPUT STRING
    ADD     #03, A5     ;THEN, SKIP THE "MS "
    JSR     SCAN_ADDR   ;JUMP TO SUBROUTINE SCAN_ADDR
    MOVE.L  D7, A2      ;FIRST PARAMETER IN A2
    ADD     #01, A5     ;SKIP A SPACE
    JSR     SCAN_ADDR   
    MOVE.L  D7, A3      ;SECOND PARAMETER IN A3
    ADD     #01, A5     ;SKIP SPACE
    CMPI.B  #$41, (A5)  ;'A'
    BEQ     MSA
    CMPI.B  #$48, (A5)  ;'H'
    BEQ     MSH  
    JMP     PARA_ERR    
    
MSA
    MOVE.B  #$3F, D1    ;ADD A ?
    MOVE.B  #6, D0
    TRAP    #15
    LEA INPUT, A1       ;INPUT MAPPING
    MOVE.B  #2, D0
    TRAP    #15
MS_MOVA
    MOVE.B  (A1)+, (A2)+
    CMPA    A3, A2
    BGE     MS_DONE
    CMPI.B  #$00, (A1)
    BEQ     MS_DONE
    BRA     MS_MOVA
    
MSH
    MOVE.B  #$3F, D1    ;ADD A ?
    MOVE.B  #6, D0
    TRAP    #15
    LEA INPUT, A1       ;INPUT MAPPING
    MOVE.B  #2, D0
    TRAP    #15
MS_MOVH
    CMPI.B  #$24, (A1)  ;SCAN FOR HEX STARTS WITH $
    BEQ     MS_SKIP        
    MOVE.B  (A1)+, (A2)+   
    CMPA    A3, A2
    BGE     MS_DONE
    BRA     MS_NOT_SKIP
MS_SKIP
    ADD     #$1, A1
MS_NOT_SKIP
    CMPI.B  #$00, (A1)
    BEQ     MS_DONE
    BRA     MS_MOVH
    JMP     MS_DONE
    
MS_DONE
    JMP MONITOR_MAIN 



BF
    LEA     INPUT, A5
    ADD     #$03, A5    ;SKIP "BF "
    JSR     SCAN_ADDR   
    MOVE.L  D7, A2      ;START ADDRESS IN A2
    ADD     #$01, A5    ;SKIP A SPACE
    JSR     SCAN_ADDR
    MOVE.L  D7, A3      ;END ADDRESS IN A3
    CLR D5
    CLR D7
    CLR D6
GET_DATA
    ADD     #$01, A5    ;MOVE THE POINTER TO THE RIGHT, SKIP SPACE IN THE FIRST CYCLE
    ADD     #$01, D5
    MOVE.B  (A5),D6     ;MOVE ONE NUMBER TO D6
    SUB.B   #$30, D6    ;CONVERT TO BCD   
    CMPI.B  #$05, D5    ;CHECK FOR END OF THE STRING
    BEQ     FILL_BLK     

    ROL.L   #4, D7      ;THE NUMBER SHIFT LEFT FOR ONE BYTE
    ADD.L   D6, D7      ;ADD THE DATA TO D7
    BRA     GET_DATA    ;NEXT NUMBER
FILL_BLK
    CMPA    A3, A2
    BGE     FILLED
    MOVE.W  D7, (A2)+
    BRA     FILL_BLK

FILLED
    JMP MONITOR_MAIN 


    

BMOV
    LEA     INPUT, A5   ;POINT TO START OF INPUT STRING
    ADD     #05, A5     ;THEN, SKIP THE "BMOV "
    JSR     SCAN_ADDR   ;JUMP TO SUBROUTINE SCAN_ADDR
    MOVE.L  D7, A2      ;FIRST PARAMETER
    ADD     #01, A5     ;SKIP A SPACE
    JSR     SCAN_ADDR   
    MOVE.L  D7, A3      ;SECOND PARAMETER
    ADD     #01, A5     
    JSR     SCAN_ADDR
    MOVE.L  D7, A4      ;THIRD PARAMETER
MOV_BLOCK
    MOVE.B  (A2)+, (A4)+ ;MOVE ONE BYTE A TIME
    CMPA    A3, A2       ;CHECK FOR MOVED ALL
    BNE     MOV_BLOCK    ;IF NOT, LOOP. IF SO, RETURN TO MONITOR MAIN PROGRAM

    JMP MONITOR_MAIN 


BTST
    LEA     INPUT, A5
    ADD     #$05, A5    ;SKIP "BTST "
    JSR     SCAN_ADDR   
    MOVE.L  D7, A2      ;START ADDRESS IN A2
    MOVE.L  D7, A4
    ADD     #$01, A5    ;SKIP A SPACE
    JSR     SCAN_ADDR
    MOVE.L  D7, A3      ;END ADDRESS IN A3
FILL_AA
    MOVE.B  #$AA,(A2)   ;WRITE $AA TO MEMORY
    CMPA.L  A3,A2    	;CHECK FOR END OF MEMORY 
    BEQ     END_AA          
    CMP.B   #$AA,(A2)
    BNE     FILL_ERROR_AA
    ADD     #1, A2
    BRA     FILL_AA
END_AA
    MOVE.L  A4, A2      ;RESTORE START ADDRESS
FILL_55
    MOVE.B  #$55,(A2)   ;WRITE $55 TO MEMORY
    CMPA.L  A3,A2       ;CHECK FOR END OF MEMORY 
    BEQ     END_FILL          
    CMP.B   #$55,(A2)
    BNE     FILL_ERROR_55
    ADD     #1, A2
    BRA     FILL_55
FILL_ERROR_AA
    LEA     ERROR_AA, A1
    MOVE.B  #13, D0
    TRAP    #15    
    LEA     OUTPUT_BUF, A1
    MOVE.L  A2, (A1)+
    ADD     #1, A1
    MOVE.B  (A2),(A1)+
    MOVE.B  (A2),(A1)+
    MOVE.B  #$00, (A1)
    LEA     OUTPUT_BUF, A1
    MOVE.B  #13, D0
    TRAP    #15     
    ADD     #1, A2           
    JMP     MONITOR_MAIN
FILL_ERROR_55
    LEA     ERROR_55, A1
    MOVE.B  #13, D0
    TRAP    #15     
    LEA     OUTPUT_BUF, A1
    MOVE.L  A2, (A1)+
    ADD     #1, A1
    MOVE.B  (A2),(A1)+
    MOVE.B  (A2),(A1)+
    MOVE.B  #$00, (A1)
    LEA     OUTPUT_BUF, A1
    MOVE.B  #13, D0
    TRAP    #15   
    ADD     #1, A2          
    JMP     MONITOR_MAIN      
END_FILL               
    LEA BLKTST_PASS, A1
    MOVE.B  #13, D0
    TRAP    #15
    JMP MONITOR_MAIN 



BSCH
    CLR.L   D1
    CLR.L   D2
    LEA     INPUT, A5   
    ADD     #05, A5     ;THEN, SKIP THE "BSCH "
    JSR     SCAN_ADDR  
    MOVE.L  D7, A2      ;START ADDRESS IN A2
    ADD     #01, A5     ;SKIP A SPACE
    JSR     SCAN_ADDR   
    MOVE.L  D7, A3      ;END ADDRESS IN A3
    LEA     BLKSRCH_MSG, A1
    MOVE.B  #13, D0
    TRAP    #15
    LEA     INPUT_BUF, A1     
    MOVE.B  #2, D0
    TRAP    #15
    LEA     BLKSRCH_OUT_MSG, A1
    MOVE.B  #13, D0
    TRAP    #15
    LEA     INPUT_BUF, A1
    LEA     OUTPUT_BUF, A4
SCH_STRING
    CMPA    A3, A2
    BGE     SCH_NEXT
    CMP.B  (A1)+,(A2)+
    SUB     #$1, A1
    BEQ     SCH_STORE
    BRA     SCH_STRING    
SCH_NEXT
    ADD     #$1, A1
    ADD     #$1, D2
    CMP     D1, D2
    BGE     SCH_DONE   
SCH_STORE
    MOVE.L  D7, A2    
	MOVE.B  (A1),(A4)
	MOVE.B  (A4),D1    
    MOVE.B  #6, D0
    TRAP    #15
    ADD     #$1, A4
	BRA     SCH_STRING
SCH_DONE
    LEA     NULL, A1
    MOVE.B  #13, D0
    TRAP    #15    

    JMP MONITOR_MAIN




GO
    LEA     INPUT, A5    ;FETCH INPUT FROM THE START
    ADD     #$03, A5     ;SKIP"GO "
    JSR     SCAN_ADDR     
    MOVE.L  D7, A4
    JMP     (A4)


DF
        LEA     STACK, A7
    MOVEM.L D0-D7/A0-A7, -(A7)
    MOVEQ   #00, D5
NXT_REG
    LEA     REG_MSG, A1
    ADD     D5, A1
    ADD     #$03, D5
    MOVE.W  #03, D1
    MOVE.B  #01, D0
    TRAP    #15
    LEA     OUTPUT_BUF, A1
    MOVE.W  #8, D2
    MOVE.L  (A7)+, D0
NXT_DIG
    ROL.L   #4, D0
    MOVE.L  D0, D3
    AND.L   #$0F, D3
    CMPI.B  #$09, D3
    BLE     LESS
    ADD     #$07, D3
LESS
    ADD     #$30, D3
    MOVE.B  D3, (A1)+
    SUBQ.W  #1, D2
    BNE     NXT_DIG
    
    MOVE.B  #$00, (A1)+
    LEA     OUTPUT_BUF, A1
    MOVE.B  #13, D0
    TRAP #15
    
    CMPA    #STACK, A7
    BLT     NXT_REG   
    
SR
	LEA		STACK, A7
	MOVE	SR, -(A7)
	LEA		SR_MSG, A1
	MOVE.B	#14, D0
	TRAP	#15
	LEA		OUTPUT_BUF, A1
	MOVE.W	#4, D2
	MOVE.L	(A7)+, D0
NXT_SR
    ROL.L   #4, D0
    MOVE.L  D0, D3
    AND.L   #$0F, D3
    CMPI.B  #$09, D3
    BLE     LESS_SR
    ADD     #$07, D3
LESS_SR
    ADD     #$30, D3
    MOVE.B  D3, (A1)+
    SUBQ.W  #1, D2
    BNE     NXT_SR
    
    MOVE.B  #$00, (A1)+
    LEA     OUTPUT_BUF, A1
    MOVE.B  #13, D0
    TRAP #15

    JMP MONITOR_MAIN 



EXIT
    MOVE.B #9, D0
    TRAP #15 
    
SWAP
    CLR D5
    CLR D6
    LEA     INPUT, A5
    ADD     #05, A5     ;SKIP "SWAP "
    JSR     SCAN_ADDR   
    MOVE.W  D7, A2      ;DESINATED ADDRESS STORE IN A2'S LOCATION
    MOVE.B  (A2)+, D5
    MOVE.B  (A2),D6
    MOVE.W  D7, A2
    MOVE.B  D6, (A2)+
    MOVE.B  D5, (A2)

    JMP     MONITOR_MAIN
    
MULT
    LEA     OUTPUT_BUF, A2 ;A2 POINTS TO OUTPUT BUFFER
    LEA     INPUT, A5   ;A5 POINTS TO INPUT
    ADD     #$05, A5    ;SKIP "MULT "
    JSR     SCAN_ADDR   ;FIRST ADDRESS
    MOVE.L  D7, A2      ;START ADDRESS OF THE OUTPUT 
    ADD     #$01, A5    ;SKIP THE SPACE
    JSR SCAN_ADDR     ;SCAN_ADDR   ;SECOND ADDRESS
    MOVE.L  D7,A3       ; multiplier
    MOVE.B  (A3),D4     ;MOVE VALUE OF A3 TO D4
    CLR D5

COMPAREMULT
    CMPI.B   #00,(A2)
    BNE ADDITION
    MOVE.L D5,D1
    MOVE.B #15,D0
    TRAP #15
    JMP MONITOR_MAIN

ADDITION
    ADD.B D4,D5
    SUB.B #01,(A2)
    BRA COMPAREMULT

    
SF
    CLR.L     D2
    CLR.L     D1
    CLR.L     D7              
    CLR.L     D6
    CLR.L     D5
    LEA     INPUT, A5   ;POINT TO START OF INPUT STRING
    ADD     #03, A5    
    CMPI.B  #$26, (A5)+  ;SCAN FOR &

    BNE     PARA_ERR    
    CMPI.B  #$30, (A5)+  ;SCAN FOR 0
    BNE     PARA_ERR  
    CMPI.B  #$30, (A5)  ;SCAN FOR 0
    BNE     PARA_ERR    
    SUB     #$2, A5  
    JSR     SF_PARA   
    MOVE.L  D7, A2      ;FIRST PARAMETER
    ADD     #01, A5     ;SKIP A SPACE

    
    CMPI.B  #$42, (A5)  ;SCAN FOR B  
    BEQ     BOLD
    CMPI.B  #$49, (A5)  ;SCAN FOR I
    BEQ     ITALIC
    BNE     PARA_ERR
    BRA     SET

BOLD
    MOVE.B  #0, D2
    BRA     SET 
ITALIC
    MOVE.B  #1, D2
    BRA     SET 

SET
    MOVE.L  A2, D1
    MOVE.B  #21, D0
    TRAP    #15
    
    JMP     MONITOR_MAIN
    
SF_PARA  
    CLR D7              
    CLR D6
    CLR D5
SAVE_SF_PARA
    ADD     #$01, A5    ;MOVE THE POINTER TO THE RIGHT, SKIP & IN THE FIRST CYCLE
    MOVE.B  (A5),D6     ;MOVE ONE NUMBER TO D6  
    SUB.B   #$30, D6
    CMPI.B  #$00, (A5)  ;SCHECK FOR END OF STRING
    BEQ     SF_RX     
    CMPI.B  #$20, (A5)  ;CHECK FOR SPACE
    BEQ     SF_RX
    ROL.L   #4, D7      ;THE NUMBER SHIFT LEFT FOR ONE BYTE
    ADD.L   D6, D7      ;ADD THE NUMBER TO D7
    ADD     #$1, D5
    CMPI    #$9, D5
    BNE     SAVE_SF_PARA    ;NEXT NUMBER 
    BGE     PARA_ERR    
SF_RX
    RTS
    

    ORG $4000
EXCEPTION
    MOVE.L  (A7)+, D0   ;POP STACK
    MOVE.L  (A7)+, D1
    MOVE.L  (A7)+, D2
    MOVE.L  (A7)+, D3
    MOVE.L  (A7)+, D4
    MOVE.L  (A7)+, D5
    MOVE.L  (A7)+, D6
    MOVE.L  (A7)+, D7
    MOVE.L  (A7)+, A0
    MOVE.L  (A7)+, A1
    MOVE.L  (A7)+, A2
    MOVE.L  (A7)+, A3
    MOVE.L  (A7)+, A4
    MOVE.L  (A7)+, A5
    MOVE.L  (A7)+, A6
    MOVE.L  (A7)+, A7
    MOVE    (A7),SR
	
    JMP     MONITOR_MAIN        

BUS_ERR
    LEA     STACK, A7
    MOVE	SR, -(A7)
    MOVEM.L D0-D7/A0-A7, -(A7)
    LEA     BUS_ERROR_MSG, A1
    MOVE.B  #13, D0
    TRAP #15
    
    JMP    EXCEPTION

ADDR_ERR
    LEA     STACK, A7
    MOVE	SR, -(A7)
    MOVEM.L D0-D7/A0-A7, -(A7)
    LEA     ADDR_ERROR_MSG, A1
    MOVE.B  #13, D0
    TRAP #15
    
    JMP    EXCEPTION

ILL_CMD
    LEA     STACK, A7
    MOVE	SR, -(A7)
    MOVEM.L D0-D7/A0-A7, -(A7)
    LEA     ILL_CMD_MSG, A1
    MOVE.B  #13, D0
    TRAP #15
    
    JMP    EXCEPTION

PRI_VIO
    LEA     STACK, A7
    MOVE	SR, -(A7)
    MOVEM.L D0-D7/A0-A7, -(A7)
    LEA     PRI_VIO_MSG, A1
    MOVE.B  #13, D0
    TRAP #15
    
    JMP    EXCEPTION

DIV_ZRO
    LEA     STACK, A7
    MOVE	SR, -(A7)
    MOVEM.L D0-D7/A0-A7, -(A7)
    LEA     DIV_ZERO_MSG, A1
    MOVE.B  #13, D0
    TRAP #15
    
    JMP    EXCEPTION

CHK_CMD
    LEA     STACK, A7
    MOVE	SR, -(A7)
    MOVEM.L D0-D7/A0-A7, -(A7)
    LEA     CHK_CMD_MSG, A1
    MOVE.B  #13, D0
    TRAP #15
    
    JMP    EXCEPTION

LINE_A
    LEA     STACK, A7
    MOVE	SR, -(A7)
    MOVEM.L D0-D7/A0-A7, -(A7)
    LEA     LINE_A_MSG, A1
    MOVE.B  #13, D0
    TRAP #15
    
    JMP    EXCEPTION

LINE_F
    LEA     STACK, A7
    MOVE	SR, -(A7)
    MOVEM.L D0-D7/A0-A7, -(A7)
    LEA     LINE_F_MSG, A1
    MOVE.B  #13, D0
    TRAP #15
    
    JMP    EXCEPTION

TST_ERR                 
    LEA     TST_ERROR_MSG, A1
    MOVE.B  #13, D0
    TRAP    #15
    JMP     MONITOR_MAIN


    ORG $5000
BUS_ERROR
    MOVE.L  #$1234, $8000
    MOVE.L $8000,$2000000
    ;CLR.L $2000000
    BRA    BUS_ERROR
    
    
    ORG $5100
ADDRESS_ERROR
A_ERR   EQU $5051
    LEA A_ERR, A2
    MOVE.L  A5, (A2)
    BRA   ADDRESS_ERROR
    
    
    ORG $6200
ILLEGAL_COMMAND  EQU $5200 
    LEA   ILLEGAL_COMMAND, A5
    MOVE.W  #$4AFA, (A5)
    BRA   MONITOR_MAIN   
    ORG $5200
ILLEGAL_COMMAND
    BRA   ILLEGAL_COMMAND
    
    
    ORG $5300
PRI_VIOLATION    
    ANDI.W #$0700,SR
    BRA PRI_VIOLATION


    ORG $5400
DIV_ZERO
    MOVE.W  #0, D1
    MOVE.W  #9, D2
    DIVU D1,D2
    BRA   DIV_ZRO
    
    
    ORG $5500
CHK_COMMAND
    MOVE.W  #$3000,D6
    MOVE.W  #$3010,D7
    CHK.W D6,D7
    BRA  CHK_COMMAND 
    
    
    ORG $6000
LINEA  EQU $5600 
    LEA   LINEA, A5
    MOVE.W  #$A000, (A5)
    BRA   MONITOR_MAIN   
    ORG $5600
LINEA_LOOP    
    BRA   LINEA_LOOP
    
    
    ORG $6100
LINEF  EQU $5700 
    LEA   LINEF, A5
    MOVE.W  #$F000, (A5)
    BRA   MONITOR_MAIN
    ORG $5700
LINEF_LOOP    
    BRA   LINEF_LOOP
    
    
    END    START       






































































*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
