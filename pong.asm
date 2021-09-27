Assume cs:code, ds:data, ss:stk

data segment
message db 100 dup(?)
data ends

stk segment stack
dw 100 dup(?)
stacktop:
stk ends

code segment
org 100h
jmp begin

;SCORE
pScore1    db 0000b
pScore2    db 0000b

;COLORS
colorRed   db 0100b
colorBlue  db 0001b
colorGreen db 0010b
colorBlack db 0000b
boardColor db 0010b

;Ball Position
ballX      dw 149
ballY      dw 99
ballL	   dw 101
ballW      dw 151
ballColor  db 0010b

;Paddles
P1PX       dw 30
P1PY       dw 91
P1PL       dw 121
P1PW       dw 34

P2PX       dw 267
P2PY       dw 91
P2PL       dw 121
P2PW       dw 270
;Controls
p1up       db 077h
p1dwn      db 073h
p2up       db 069h
p2dwn      db 06Bh

playerCtrl db 00h

;RESET
reset      db 0000b
nextRound  db 0000b


;Ball Direction
ballDir    db 0aah ;NW,  NE,   SW,   SE
					;aaaa, bbbb, cccc, dddd

begin:
call checkWinner
call delay
call checkMOV
call ballCollision
call moveBall
;call RT1
call UPDATE
;call updateScore
jmp begin

checkWinner:
push ax
push bx
push cx
push dx

mov cl, [pScore1]
cmp cl, 9
je P1WIN

mov cl, [pScore2]
cmp cl, 9
je P2WIN

pop dx
pop cx
pop bx
pop ax
RET
P1WIN:
mov bl, [colorRed]
mov [boardColor], bl
call dispBoard
jmp Exit
P2WIN:
mov bl, [colorBlue]
mov [boardColor], bl
call dispBoard
jmp restart


Exit:
mov ah,4ch
int 21h
;///////////////////RESET INITIALIZE/////////////////////////
restart:
mov bl, [colorGreen]
mov [boardColor], bl
call dispBoard
call next
;Ball Direction
mov[ballDir], 0aah 

mov[pScore1], 0000b
mov[pScore2], 0000b

RET

next:
push ax
push bx
push cx
push dx

mov [ballX], 149
mov [ballY], 99
mov [ballL], 101
mov [ballW], 151
mov [ballColor], 0010b

;Paddles
mov[P1PX], 30
mov[P1PY], 91
mov[P1PL], 121
mov[P1PW], 34

mov[P2PX], 267
mov[P2PY], 91
mov[P2PL], 121
mov[P2PW], 270

mov[playerCtrl], 00h

;RESET
mov[reset], 0000b
mov[nextRound], 0000b

pop dx
pop cx
pop bx
pop ax
RET
;////////////////////////Display score/////////////////////////////

updateScore:
push ax
push bx
push cx
push dx

mov bl, [pScore1]
mov al,[colorRed]
cmp bl, 0
je zerop1

cmp bl, 1
je onep1

cmp bl, 2
je twop1

cmp bl, 3
je threep1

cmp bl, 4
je fourp1

cmp bl, 5
je fivep1

cmp bl, 6
je sixp1

cmp bl, 7
je sevenp1

cmp bl, 8
je eightp1

cmp bl, 9
je ninep1

zerop1:
call P1ZERO
jmp p2scorecheck

onep1:
call P1ONE
jmp p2scorecheck

twop1:
call P1TWO
jmp p2scorecheck

threep1:
call P1THREE
jmp p2scorecheck

fourp1:
call P1FOUR
jmp p2scorecheck

fivep1:
call P1FIVE
jmp p2scorecheck

sixp1:
call P1SIX
jmp p2scorecheck

sevenp1:
call P1SEVEN
jmp p2scorecheck

eightp1:
call P1EIGHT
jmp p2scorecheck

ninep1:
call P1NINE
jmp p2scorecheck
;/////////////////////////////////////////////////
;;///////////////////////////////////////////////////////////////////
p2scorecheck:
mov cl, [pScore2]
mov al,[colorBlue]
cmp cl, 0
je zerop2

cmp cl, 1
je onep2

cmp cl, 2
je twop2

cmp cl, 3
je threep2

cmp cl, 4
je fourp2

cmp cl, 5
je fivep2

cmp cl, 6
je sixp2

cmp cl, 7
je sevenp2

cmp cl, 8
je eightp2

cmp cl, 9
je ninep2

zerop2:
call P2ZERO
jmp endscore

onep2:
call P2ONE
jmp endscore

twop2:
call P2TWO
jmp endscore

threep2:
call P2THREE
jmp endscore

fourp2:
call P2FOUR
jmp endscore

fivep2:
call P2FIVE
jmp endscore

sixp2:
call P2SIX
jmp endscore

sevenp2:
call P2SEVEN
jmp endscore

eightp2:
call P2EIGHT
jmp endscore

ninep2:
call P2NINE
jmp endscore

endscore:
pop dx
pop cx
pop bx
pop ax
RET

;/////////////////////////end display score/////////////////////
Exit2:
mov ah,4ch
int 21h
;///////////////////PLAYERCONTROL////////////////////////////////
checkMOV:
push ax
push bx
push cx
push dx

MOV ah, 01H
int 16h
jz preendmove

mov ah, 00h
int 16h

cmp al, 08H
je Exit2

;mov dl, [playerCtrl]
;cmp dl, 0011b 
;je p1move
jmp p1move

;cmp dl, 1100b
;je p2move
jmp p2move

preendmove:
jmp endmove

p1move:   ;;;;;P1 MOVE
cmp al, 077H
je p1moveup

cmp al, 073h
je p1movedown

;jmp endmove

p2move:    ;;;;;;P2 MOVE
cmp al, 069h
je p2moveup

cmp al, 06Bh
je p2moveDown

jmp endmove

p1moveup:
mov cx, [P1PY]
mov bx, [P1PL]
cmp cx, 53 ;check is p1 is at top of board
je p2move ; if at top of board, no move, skip to checking player 2
dec cx
dec bx
dec cx
dec bx
mov [P1PY], cx
mov [P1PL], bx
;jmp endmove
jmp p2move

p1movedown:
mov cx, [P1PY]
mov bx, [P1PL]
cmp cx, 165 ;check is p1 is at bottom of board
je p2move ; if at bottom of board, no move, skip to checking player 2
inc cx
inc bx
inc cx
inc bx
mov [P1PY], cx
mov [P1PL], bx
;jmp endmove
jmp p2move

p2moveup:
mov cx, [P2PY]
mov bx, [P2PL]
cmp cx, 53 ;check is p2 is at top of board
je endmove ; if at top of board, no move, skip to endmove
dec cx
dec bx
dec cx
dec bx
mov [P2PY], cx
mov [P2PL], bx
jmp endmove

p2movedown:
mov cx, [P2PY]
mov bx, [P2PL]
cmp cx, 165 ;check is p2 is at bottom of board
je endmove ; if at bottom of board, no move, skip to endmove
inc cx
inc bx
inc cx
inc bx
mov [P2PY], cx
mov [P2PL], bx
jmp endmove

endmove:

pop dx
pop cx
pop bx
pop ax
RET


;/////////////////PLAYERCONTROLEND///////////////////////////////

;////////////////////UPDATE////////////////////////////////////////////////
;All graphical stuff happens here
UPDATE:
push ax
push bx
push cx
push dx

mov ah, 0   ; set display mode function.
mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
;mov al, 12h ; mode 12h = 640x480 pixels, 16 colors.
int 10h     ; set it!


call dispBoard
call drawBall
call drawPaddles
call updateScore


pop dx
pop cx
pop bx
pop ax

RET
;///////////////////////////////////END UPDATE//////////////////////////////

;///////////PADDLES/////////////////////////////////////////////

drawPaddles:
push ax
push bx
push cx
push dx

mov al, [colorRed]
mov cx, [P1PX]  ;col
mov dx, [P1PY]  ;row
mov ah, 0ch ; put pixel

paddle1:
;mov al, 0100b
mov bx, [P1PW]
inc cx
int 10h
cmp cx, bx
JNE paddle1
mov bx, [P1PL]
mov cx, [P1PX]  ; reset to start of col
inc dx      ;next row
cmp dx, bx
JNE paddle1

mov al, [colorBlue]
mov cx, [P2PX]  ;col
mov dx, [P2PY]  ;row
mov ah, 0ch ; put pixel

paddle2:
inc cx
int 10h
mov bx, [P2PW]
inc bx
cmp cx, bx
JNE paddle2

mov bx, [P2PL]
inc bx
mov cx, [P2PX]  ; reset to start of col
inc dx      ;next row
cmp dx, bx
JNE paddle2

pop dx
pop cx
pop bx
pop ax

RET

;////////////END PADDLES////////////////////////////////////////
;////////BALL///////////////////////////////////////////////////////////////
;INCLUDES LOGIC AND GRAPHICS
drawBall:

push ax
push bx
push cx
push dx

mov al, [ballColor]
mov cx, [ballX]  ;col
mov dx, [ballY]  ;row
mov ah, 0ch ; put pixel

Bdraw:
;mov al, 0100b

inc cx
int 10h
mov bx, [ballW]
inc bx
cmp cx, bx
JNE Bdraw

mov bx, [ballL]
inc bx
mov cx, [ballX]  ; reset to start of col
inc dx      ;next row
cmp dx, bx
JNE Bdraw

pop dx
pop cx
pop bx
pop ax

RET

moveBall:
push ax
push bx
push cx
push dx
push si

mov cl, [ballDir]
mov bx, [ballX] ;X coordinate
mov dx, [ballY] ;Y coordinate
mov ax, [ballW] 
mov si, [ballL]

cmp cl, 0aah
je NW

cmp cl, 0bbh
je NNE

cmp cl, 0cch
je SW

cmp cl, 0ddh
je SE

NW:
dec bx
dec dx
dec ax
dec si
mov [ballX], bx
mov [ballY], dx
mov [ballW], ax
mov [ballL], si
;mov [playerCtrl], 0011b
jmp movEND      ;so it doesn't go through the other directions

NNE:
inc bx
dec dx
inc ax
dec si
mov [ballX], bx
mov [ballY], dx
mov [ballW], ax
mov [ballL], si
;mov [playerCtrl], 1100b
jmp movEND

SW:
dec bx
inc dx
dec ax
inc si
mov [ballX], bx
mov [ballY], dx
mov [ballW], ax
mov [ballL], si
;mov [playerCtrl], 0011b
jmp movEND

SE:
inc bx
inc dx
inc ax
inc si
mov [ballX], bx
mov [ballY], dx
mov [ballW], ax
mov [ballL], si
;mov [playerCtrl], 1100b
jmp movEND

movEND:

pop si
pop dx
pop cx
pop bx
pop ax

RET

ballCollision: ;;DO NOT TOUCH AX REGISTER HERE
push ax
push bx
push cx
push dx
push si
push di

mov cx, [ballX]
mov dx, [ballY]
mov bl, [ballDir]


cmp bl, 0aah
je COLNW

cmp bl,0bbh
je COLNE

cmp bl, 0cch
je COLSW

cmp bl, 0ddh
je COLSE



jmp endColCheck
;;;collision check
COLNW:
cmp dx,52
je changeSW
cmp cx,6
je scoreP2checkpoint ;;;;;;SCOREHANDLING GOES HERE

dec cx
dec dx
mov ah, 0dh
int 10h
cmp al, [colorRed]
je changeNE
jmp endColCheck

COLNE:
inc cx
cmp dx,52
je changeSE
cmp cx,293
je scoreP1


inc cx
inc cx
inc cx
dec dx
mov ah, 0dh
int 10h
cmp al, [colorBlue]
je changeNW
jmp endColCheck

COLSE:
inc cx
inc dx
cmp dx,195
je changeNE
cmp cx,293
je scoreP1

inc cx
inc cx
inc cx
inc dx
mov ah, 0dh
int 10h
cmp al, [colorBlue]
je changeSW
jmp endColCheck

scoreP2checkpoint:
jmp scoreP2

COLSW:
inc dx
cmp dx,195
je changeNW
cmp cx,6
je scoreP2

dec cx
inc dx
mov ah, 0dh
int 10h
cmp al, [colorRed]
je changeSE
jmp endColCheck

;;;;;direction change
changeSW:
mov [ballDir], 0cch
jmp endColCheck

changeSE:
mov [ballDir], 0ddh
jmp endColCheck

changeNW:
mov [ballDir], 0aah
jmp endColCheck

changeNE:
mov [ballDir], 0bbh
jmp endColCheck

scoreP1:
mov bl, [pScore1]
inc bl
mov [pScore1],bl
jmp goal

scoreP2:
mov bl, [pScore2]
inc bl
mov [pScore2],bl
jmp goal

goal:
call updateScore
call next

endColCheck:

pop di
pop si
pop dx
pop cx
pop bx
pop ax

RET
;////////END BALL////////////////////////////////////////////////////////////
;/////////////////////NUMBERS///////////////////////////////////////////

;;;;;;;;;;;;;;;;;;PLAYER 1;;;;;;;;;;;;;;;;;;;;;;
P1ZERO:
call T1
call RT1
call RB1
call LT1
call LB1
call B1

P1ONE:
call RT1
call RB1

RET

P1TWO:
call T1
call RT1
call M1
call LB1
call B1

RET

P1THREE:
call T1
call M1
call B1
call RT1
call RB1

RET

P1FOUR:
call P1ONE
call LT1
call M1

RET

P1FIVE:
call T1
call LT1
call M1
call RB1
call B1

RET

P1SIX:
call P1FIVE
call LB1

RET

P1SEVEN:
call P1ONE
call T1

RET

P1EIGHT:
call P1SIX
call RT1

RET

P1NINE:
call P1ONE
call T1
call LT1
call M1

RET

;;;;;;;;;;;;;;;;;;;;;PLAYER 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
P2ZERO:
call T2
call RT2
call RB2
call LT2
call LB2
call B2

P2ONE:
call RT2
call RB2

RET

P2TWO:
call T2
call RT2
call M2
call LB2
call B2

RET

P2THREE:
call T2
call M2
call B2
call RT2
call RB2

RET

P2FOUR:
call P2ONE
call LT2
call M2

RET

P2FIVE:
call T2
call LT2
call M2
call RB2
call B2

RET

P2SIX:
call P2FIVE
call LB2

RET

P2SEVEN:
call P2ONE
call T2

RET

P2EIGHT:
call P2SIX
call RT2

RET

P2NINE:
call P2ONE
call T2
call LT2
call M2

RET

;/////////////////////////////////END NUMBER//////////////////////////////////////




;////////////////////////DISPLAY BOARD/////////////////////////////////////////////////
dispBoard:
mov al, [boardColor]
call BTOP
call BLEFT
call BRIGHT
call BBOT

RET

BTOP:
mov cx, 5  ;col
mov dx, 50  ;row
mov ah, 0ch ; put pixel
TOP:
;mov al, 0100b
inc cx
int 10h
cmp cx, 295
JNE TOP

mov cx, 5  ; reset to start of col
inc dx      ;next row
cmp dx, 52
JNE TOP

RET

BLEFT:
mov cx, 5  ;col
mov dx, 50  ;row
mov ah, 0ch ; put pixel

LEFT:
inc cx
int 10h
cmp cx, 7
JNE LEFT

mov cx, 5  ; reset to start of col
inc dx      ;next row
cmp dx, 196
JNE LEFT

RET

BRIGHT:
mov cx, 295  ;col
mov dx, 50  ;row
mov ah, 0ch ; put pixel

RIGHT:
inc cx
int 10h
cmp cx, 297
JNE RIGHT

mov cx, 295  ; reset to start of col
inc dx      ;next row
cmp dx, 196
JNE RIGHT

RET

BBOT:
mov cx, 5  ;col
mov dx, 196  ;row
mov ah, 0ch ; put pixel
BOT:
;mov al, 0100b
inc cx
int 10h
cmp cx, 297
JNE BOT

mov cx, 5  ; reset to start of col
inc dx      ;next row
cmp dx, 198
JNE BOT

RET
;//////////////////////////////////END DISPLAY BOARD///////////////////////////////////////////


;;;;;;;;;;SCORE DISPLAY;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;CAN REMOVE THE MOVE TO AL AND MOVE IT BEFORE EVERYTHING
;;;;;;;;;;INSTEAD OF MOVING TO CX ADD THE DIFFERENCE TO CX (STORES AUTOMATICALLY)
;;;;;;;;;;P1 SCORE
LT1:
mov cx, 10  ;col
mov dx, 10  ;row
mov ah, 0ch ; put pixel

leftTop1:
;mov al, 0100b
inc cx
int 10h
cmp cx, 12
JNE leftTop1

mov cx, 10  ; reset to start of col
inc dx      ;next row
cmp dx, 20
JNE leftTop1

RET

RT1:
mov cx, 18  ;col
mov dx, 10  ;row
mov ah, 0ch ; put pixel

rightTop1:
;mov al, [colorRed]
inc cx
int 10h
cmp cx, 20
JNE rightTop1

mov cx, 18  ; reset to start of col
inc dx      ;next row
cmp dx, 20
JNE rightTop1

RET

LB1:
mov cx, 10  ;col
mov dx, 20  ;row
mov ah, 0ch ; put pixel
leftBot1:
;mov al, 0100b
inc cx
int 10h
cmp cx, 12
JNE leftBot1

mov cx, 10  ; reset to start of col
inc dx      ;next row
cmp dx, 30
JNE leftBot1

RET

RB1:
mov cx, 18  ;col
mov dx, 20  ;row
mov ah, 0ch ; put pixel
rightBot1:
;mov al, 0100b
inc cx
int 10h
cmp cx, 20
JNE rightBot1

mov cx, 18  ; reset to start of col
inc dx      ;next row
cmp dx, 30
JNE rightBot1

RET

T1:
mov cx, 10  ;col
mov dx, 10  ;row
mov ah, 0ch ; put pixel
top1:
;mov al, 0100b
inc cx
int 10h
cmp cx, 20
JNE top1

mov cx, 10  ; reset to start of col
inc dx      ;next row
cmp dx, 12
JNE top1

RET

M1:
mov cx, 10  ;col
mov dx, 19 ;row
mov ah, 0ch ; put pixel
mid1:
;mov al, 0100b
inc cx
int 10h
cmp cx, 20
JNE mid1

mov cx, 10  ; reset to start of col
inc dx      ;next row
cmp dx, 21
JNE mid1

RET

B1:
mov cx, 10  ;col
mov dx, 28 ;row
mov ah, 0ch ; put pixel
bot1:
;mov al, 0100b
inc cx
int 10h
cmp cx, 20
JNE bot1

mov cx, 10  ; reset to start of col
inc dx      ;next row
cmp dx, 30
JNE bot1

RET

;;;;;;;;;;;;;;;;;;;;P2 SCORE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LT2:
mov cx, 270  ;col
mov dx, 10  ;row
mov ah, 0ch ; put pixel

leftTop2:
;mov al, 0100b
inc cx
int 10h
cmp cx, 272
JNE leftTop2

mov cx, 270  ; reset to start of col
inc dx      ;next row
cmp dx, 20
JNE leftTop2

RET

RT2:
mov cx, 278  ;col
mov dx, 10  ;row
mov ah, 0ch ; put pixel

rightTop2:
;mov al, [colorRed]
inc cx
int 10h
cmp cx, 280
JNE rightTop2

mov cx, 278  ; reset to start of col
inc dx      ;next row
cmp dx, 20
JNE rightTop2

RET

LB2:
mov cx, 270  ;col
mov dx, 20  ;row
mov ah, 0ch ; put pixel
leftBot2:
;mov al, 0100b
inc cx
int 10h
cmp cx, 272
JNE leftBot2

mov cx, 270  ; reset to start of col
inc dx      ;next row
cmp dx, 30
JNE leftBot2

RET

RB2:
mov cx, 278  ;col
mov dx, 20  ;row
mov ah, 0ch ; put pixel
rightBot2:
;mov al, 0100b
inc cx
int 10h
cmp cx, 280
JNE rightBot2

mov cx, 278 ; reset to start of col
inc dx      ;next row
cmp dx, 30
JNE rightBot2

RET

T2:
mov cx, 270  ;col
mov dx, 10  ;row
mov ah, 0ch ; put pixel
top2:
;mov al, 0100b
inc cx
int 10h
cmp cx, 280
JNE top2

mov cx, 270 ; reset to start of col
inc dx      ;next row
cmp dx, 12
JNE top2

RET

M2:
mov cx, 270  ;col
mov dx, 19 ;row
mov ah, 0ch ; put pixel
mid2:
;mov al, 0100b
inc cx
int 10h
cmp cx, 280
JNE mid2

mov cx, 270  ; reset to start of col
inc dx      ;next row
cmp dx, 21
JNE mid2

RET

B2:
mov cx, 270  ;col
mov dx, 28 ;row
mov ah, 0ch ; put pixel
bot2:
;mov al, 0100b
inc cx
int 10h
cmp cx, 280
JNE bot2

mov cx, 270  ; reset to start of col
inc dx      ;next row
cmp dx, 30
JNE bot2

RET
;;;;;;;;;;;;;;;END SCORE DISPLAY;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;CLEAR SCREEN;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; clrSCREEN:
; push ax
; push bx
; push cx
; push dx


; mov ah, 0h   ; set display mode function.
; mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
; int 10h     ; set it!
;;;;;;;;;;;;;;;;;;;FOUND ANSWER ON STACK OVERFLOW FOR CLEAR SCREEN;;;;;;;;;;;
; mov ax,0a000h
; mov es, ax
; xor di,di
; xor ax, ax
; mov cx, 32000d
; cld
; rep stosw

; pop dx
; pop cx
; pop bx
; pop ax

; RET
;;;;;;;;;;;;;;;;;;;;;DELAY;;;;;;;;;;;;;;;;;;;;;;;;;;;
delay:
; push AX
; push BX
; push CX
; push DX

; MOV CX, 0001H
; MOV BX, 0ffffH

; CCCC:
; MOV BX, 0ffffH

; bbbb:
; NOP
; dec BX
; cmp BX, 00h
; jne bbbb
; dec CX
; cmp CX, 00h
; jne CCCC

; pop DX
; pop CX
; pop BX
; pop AX

push ax
push bx
push cx
push dx

mov cx, 10000

dstart:
NOP 
NOP 
NOP
NOP 
NOP 
NOP
NOP
NOP
NOP
NOP
cmp cx, 0
je  dstop
dec cx
jmp dstart

dstop:
pop dx
pop cx
pop bx
pop ax

RET
code ends
end begin





