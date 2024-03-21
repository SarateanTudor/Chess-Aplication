.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
;;; Pentru printf
	format_decimal db "%u ", 0 ; Format specifier for decimal integers
	format_string db "%s", 0
	text db "/", 0
	
Pion_Alb DB "Pion_Alb", 0
Cal_Alb DB "Cal_Alb", 0
Nebun_Alb DB "Nebun_Alb", 0
Tura_Alb DB "Tura_Alb", 0
Regina_Alb DB "Regina_Alb", 0
Rege_Alb DB "Rege_Alb", 0
Pion_Negru DB "Pion_Negru", 0
Cal_Negru DB "Cal_Negru", 0
Nebun_Negru DB "Nebun_Negru", 0
Tura_Negru DB "Tura_Negru", 0
Regina_Negru DB "Regina_Negru", 0
Rege_Negru DB "Rege_Negru", 0
;;;;;
STARE_CLICK DD 1 ;; Daca trebuie sa apasam sau sa mutam piesa
ROUND DD 0 ;; Care culoare e la rand
EN_PASSANT_OK DD 0 ;; In caz ca exista un en passant
WIN DD 0
;;;;;
matrix  dd 151,131,141,190,199,141,131,152	   ; row 1
		dd 111,111,111,111,111,111,111,111	   ; row 2
        dd 0,0,0,0,0,0,0,0     			   ; row 3
		dd 0,0,0,0,0,0,0,0	   			   ; row 4
		dd 0,0,0,0,0,0,0,0	   			   ; row 5
		dd 0,0,0,0,0,0,0,0	   			   ; row 6
		dd 10,10,10,10,10,10,10,10 			   ; row 7
		dd 51,31,41,90,99,41,31,52			   ; row 8
		
		
Mutari  dd 0, 0, 0, 0, 0, 0, 0, 0	; row 1
		dd 0, 0, 0, 0, 0, 0, 0, 0	; row 2
		dd 0, 0, 0, 0, 0, 0, 0, 0	; row 3
		dd 0, 0, 0, 0, 0, 0, 0, 0	; row 4
		dd 0, 0, 0, 0, 0, 0, 0, 0	; row 5
		dd 0, 0, 0, 0, 0, 0, 0, 0	; row 6
		dd 0, 0, 0, 0, 0, 0, 0, 0	; row 7
		dd 0, 0, 0, 0, 0, 0, 0, 0	; row 8
		
White_Attack  	dd 0, 0, 0, 0, 0, 0, 0, 0	; row 1
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 2
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 3
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 4
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 5
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 6
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 7
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 8
				
Black_Attack  	dd 0, 0, 0, 0, 0, 0, 0, 0	; row 1
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 2
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 3
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 4
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 5
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 6
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 7
				dd 0, 0, 0, 0, 0, 0, 0, 0	; row 8
INTERMEDIAR DD ?
INTERMEDIAR_1 DD ?
window_title DB "Exemplu proiect desenare",0
area_width EQU 1000
area_height EQU 1000
area DD 0

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20
include digits.inc
include letters.inc
;;;; Cand desenam o noua piesa
Piesa_Generata_x DD ?
Piesa_Generata_y DD ?
Pozitionare_x DD ?
Pozitionare_y DD ?
Pozitionare DD ?
;;;;;;;;
Piesa_x DD 0 ;; Piesa aleasa (sau nimic)
Piesa_y DD 0 ;; Piesa aleasa (sau nimic)
Piesa_x_prec DD 10 ;; Piesa pe care urmeaza sa o mutam
Piesa_y_prec DD 10 ;; Piesa pe care urmeaza sa o mutam
Precedent_x DD 0 ;; Piesa cu poz x care a fost mutata precedent
Precedent_y DD 0 ;; Piesa cu poz y care a fost mutata precedent
Precedent_Piesa DD 0 ;; Piesa care a fost mutata precedent
Mutare_Posibila DD 0 ;; Daca e posibil sa mutam acolo
En_passant_x dd 0
En_passant_y dd 0
En_passant_legit dd 0
Rocada_drepata dd 0
Rocada_stanga dd 0
Rocada_Rege_negru dd 0
Rocada_Rege_alb dd 0
Tura_Alba_stanga_mutata dd 0
Tura_Alba_dreapta_mutata dd 0
Tura_Neagra_stanga_mutata dd 0
Tura_Neagra_dreapta_mutata dd 0
;;;;;;;;;;;
patrat_x EQU 500
patrat_y EQU 150
patrat_size EQU 80

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm
;;; AFISARE
Afisare macro x
	push eax
	push ecx
	push edx
	mov eax, x
	push eax
	push offset format_decimal
    call printf
    add esp, 8
	pop edx
	pop ecx
	pop eax
endm
Afisare_Enter macro
	push eax
	push ecx
	push edx
	mov eax, offset text
	push eax
	push offset format_string
    call printf
    add esp, 8
	pop edx
	pop ecx
	pop eax
endm
Afisare_Mutari macro
local loop_x
local loop_y
	pusha
	
	mov INTERMEDIAR_1, 0 ; y
	mov ecx, 8
loop_y:
	push ecx
	mov ecx, 8
	mov INTERMEDIAR, 0 ; x
	loop_x:
		mov eax, INTERMEDIAR
		mov ebx, INTERMEDIAR_1
		imul ebx, 8
		add ebx, eax
		mov ebx, [Mutari + ebx * 4]
		afisare ebx
		inc eax
		mov INTERMEDIAR, eax
	loop loop_x
	Afisare_Enter
	pop ecx
	mov eax, INTERMEDIAR_1
	inc eax
	mov INTERMEDIAR_1, eax
loop loop_y
	popa
endm

Afisare_Matrice macro
local loop_x
local loop_y
	pusha
	
	mov INTERMEDIAR_1, 0 ; y
	mov ecx, 8
loop_y:
	push ecx
	mov ecx, 8
	mov INTERMEDIAR, 0 ; x
	loop_x:
		mov eax, INTERMEDIAR
		mov ebx, INTERMEDIAR_1
		imul ebx, 8
		add ebx, eax
		mov ebx, [Matrix + ebx * 4]
		afisare ebx
		inc eax
		mov INTERMEDIAR, eax
	loop loop_x
	Afisare_Enter
	pop ecx
	mov eax, INTERMEDIAR_1
	inc eax
	mov INTERMEDIAR_1, eax
loop loop_y
	popa
endm
;; AICI SE CREEAZA LINIILE

line_horizontal macro x, y, x_dec, y_dec, len, color ;; cu decalaje
local bucla_line
    push ecx ; Preserve ecx
	push eax;
	push edx
    mov eax, y ; EAX = y
	add eax, y_dec ;; add eax, y_dec
    mov ebx, area_width 
    mul ebx ; EAX = y * area_width
    add eax, x ; EAX = y * area_width + x
	add eax, x_dec
    shl eax, 2 ; EAX = (y * area_width + x) * 4
    add eax, area
    mov ecx, len
bucla_line:
    mov dword ptr[eax], color
    add eax, 4
    loop bucla_line
	 pop edx
	 pop eax
     pop ecx ; Restore ecx
endm

line_vertical macro x, y, x_dec, y_dec, len, color ;; cu decalaje
local bucla_line
	push eax
	push ecx
	mov eax, y ; EAX = y
	add eax, y_dec
	mov ebx, area_width 
	mul ebx ; EAX = y * area_width
	add eax, x ; EAX = y * area_width + x
	add eax, x_dec
	shl eax, 2 ; EAX = (y * area_width + x) * 4
	add eax, area
	mov ecx, len
bucla_line:
	mov dword ptr[eax], color
	add eax, 4 * area_width
	loop bucla_line
	pop ecx
	pop eax
endm
;;; AICI CREEM PATRATELE ALBE SI NEGRE
;;; ALB -> GRI : E5E4E2
;;; NEGRU -> NEGRU : 000000
Linie_Patrate_Desen_NegruAlb macro x, y, len
local bucla_Linie_Patrat
	push eax
	push ecx
    mov eax, y
    Patrat_Desen x, eax, len, 000000h
    add eax, len
	Patrat_Desen x, eax, len, 0FFFFFFh
    add eax, len
	Patrat_Desen x, eax, len, 000000h
    add eax, len
	Patrat_Desen x, eax, len, 0FFFFFFh
    add eax, len
	Patrat_Desen x, eax, len, 000000h
    add eax, len
	Patrat_Desen x, eax, len, 0FFFFFFh
    add eax, len
	Patrat_Desen x, eax, len, 000000h
    add eax, len
	Patrat_Desen x, eax, len, 0FFFFFFh
    add eax, len
	pop ecx
	pop eax
endm

Patrat_Desen macro x, y, len, color
	local bucla_Patrat
	push eax
	push ecx
    mov ecx, len
    mov eax, y
bucla_Patrat:
	line_horizontal x, eax, 0, 0, len, color
	inc eax
loop bucla_Patrat
	pop ecx
	pop eax
endm

Linie_Patrate_Desen_AlbNegru macro x, y, len
local bucla_Linie_Patrat
	push eax
	push ecx
    mov eax, y
	Patrat_Desen x, eax, len, 0FFFFFFh
    add eax, len
    Patrat_Desen x, eax, len, 0h
    add eax, len
	Patrat_Desen x, eax, len, 0FFFFFFh
    add eax, len
    Patrat_Desen x, eax, len, 0h
    add eax, len
	Patrat_Desen x, eax, len, 0FFFFFFh
    add eax, len
    Patrat_Desen x, eax, len, 0h
    add eax, len
	Patrat_Desen x, eax, len, 0FFFFFFh
	add eax, len
	Patrat_Desen x, eax, len, 0h
	pop ecx
	pop eax
endm
; bucla_Linie_Patrat:
	; Patrat_Desen x, eax, len, 0FFFFFFh
    ; add eax, len
    ; Patrat_Desen x, eax, len, 000000h
    ; add eax, len
; loop bucla_Linie_Patrat

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RECTANGLE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Rectangle_XxY macro x, y, lung, lat, color ;; Lungime/latime
local bucla_white_fill 
push eax
push ecx
	line_horizontal x, y, 0, 0, lung, 0FFFFFFh - color
	line_horizontal x, y, 0, lat, lung, 0FFFFFFh - color
	line_vertical x, y, 0, 0, lat, 0FFFFFFh - color
	line_vertical x, y, lung, 0, lat, 0FFFFFFh - color
mov eax, 1
mov edx, 0
mov ecx, lat
sub ecx, 1
 bucla_white_fill:
	  mov edx, 0
	  mov INTERMEDIAR, eax 
	  line_horizontal x, y, 1, INTERMEDIAR, lung - 1, color ;;; NU MAI TRIMITE REGISTRE CA PARAMETRI
	  inc eax
  loop bucla_white_fill	
pop ecx
pop eax
endm

;;; INCERCAM SA IDENTIFICAM O Piesa_x
Afisare_Piesa macro x ;;; 
local jos
local final
	push eax
	push edx
	mov eax, offset x
	push eax
    push offset format_string
    call printf
    add esp, 8
	final:
	pop eax
	pop edx
endm
Schimbare_Runda macro 
local final
pusha 
;;; Daca am apasat pe piesa schimbam culoarea
	 mov eax, ROUND
	 cmp eax, 1
	 jz jos
	 mov ROUND, 1
	 jmp final
	  jos:
	 mov ROUND, 0
	 final:
popa
endm
Recogniser macro x, y
	 ;; coordonatele x si y
	 mov eax, x
	 mov ebx, y
	 
	 imul ebx, 8
	 add ebx, eax
	 mov eax, [matrix + ebx * 4] ;;; avem type dword

	 mov ebx, ROUND
	 
	 cmp ebx, 1
	 jz Black_To_Move 
	;; White_to_move:
	 
	 cmp eax, 10
	 jz White_Pawn
	  cmp eax, 31
	 jz White_Knight
	  cmp eax, 41
	 jz White_Bishop
	  cmp eax, 51
	 jz White_Left_Rook
	  cmp eax, 52
	 jz White_Right_Rook
	  cmp eax, 90
	 jz White_Queen
	  cmp eax, 99
	 jz White_King
	 
	 jmp Finish_Picking
	 
	 Black_To_Move:
	  
	  cmp eax, 111
	 jz Black_Pawn
	  cmp eax, 131
	 jz Black_Knight
	  cmp eax, 141
	 jz Black_Bishop
	  cmp eax, 151
	 jz Black_Left_Rook
	  cmp eax, 152
	 jz Black_Right_Rook
	  cmp eax, 190
	 jz Black_Queen
	  cmp eax, 199
	 jz Black_King
	 
	 jmp Finish_Picking
	 
	 ;;; TOATE STARILE POSIBILE
	 Black_King:
	 	Afisare_Piesa Rege_Negru
		Setare_Mutari_Rege_Negru x, y, 1
		jmp Finish_Picking
	 Black_Queen:
	 	Afisare_Piesa Regina_Negru
		Setare_Mutari_Tura x, y, 1 
		Setare_Mutari_Nebun x, y, 1 
		jmp Finish_Picking
	 Black_Left_Rook:
		Afisare_Piesa Tura_Negru
		Setare_Mutari_Tura x, y, 1 
		jmp Finish_Picking
	 Black_Right_Rook:
	    Afisare_Piesa Tura_Negru
		Setare_Mutari_Tura x, y, 1 
		jmp Finish_Picking
	 Black_Bishop:
		Afisare_Piesa Nebun_Negru
		Setare_Mutari_Nebun x, y, 1 
		jmp Finish_Picking
	 Black_Knight:
		Afisare_Piesa Cal_Negru
		Setare_Mutari_Cal x, y, 1 
		jmp Finish_Picking
	 Black_Pawn:
		Afisare_Piesa Pion_Negru
		Setare_Mutari_Pion_Negru x, y, 1
		jmp Finish_Picking
	 White_King:
	 	Afisare_Piesa Rege_Alb
		Setare_Mutari_Rege_Alb x, y, 1
		jmp Finish_Picking
	 White_Queen:
	 	Afisare_Piesa Regina_Alb
		Setare_Mutari_Tura x, y, 1
		Setare_Mutari_Nebun x, y, 1
		jmp Finish_Picking
	 White_Left_Rook:
	  	Afisare_Piesa Tura_Alb
		Setare_Mutari_Tura x, y, 1
		jmp Finish_Picking
	 White_Right_Rook:
	    Afisare_Piesa Tura_Alb
		Setare_Mutari_Tura x, y, 1
		jmp Finish_Picking
	 White_Bishop:
	 	Afisare_Piesa Nebun_Alb
		Setare_Mutari_Nebun x, y, 1 
		jmp Finish_Picking
	 White_Knight:
		Afisare_Piesa Cal_Alb
		Setare_Mutari_Cal x, y, 1 
		jmp Finish_Picking
	 White_Pawn:
		Afisare_Piesa Pion_Alb
		Setare_Mutari_Pion_Alb x, y, 1
	 Finish_Picking:
endm

Identifier macro x, y
	 push eax
	 push ebx
	 push edx
	 mov edx, 0 ;;; ???? NU INTELEG NIMIC DA MERE DECI E OK E NEAPARAT
	 mov eax, x
	 mov ebx, 125
	 div ebx ; patratele au 125 de pixeli
	 mov Piesa_x, eax ; coordonata X
	 mov eax, y
	 mov edx, 0
	 div ebx
	 mov Piesa_y, eax ; coordonata Y 
	 ;; Acum verificam ce piesa avem
	 pop edx
	 pop ebx
	 pop eax
endm
;;; AICI INCPEM SA DESENAM PIESELE
Desen_Tura macro x, y, color
	push eax
	push ecx
	push edx
	push ebx
	;;; Baza de jos incepe de la x + 85, y + 25
	mov edx, 0
	mov eax, x
	mov ebx, 125
	mul ebx
	add eax, 25
	mov Piesa_Generata_x, eax
	mov edx, 0
	mov eax, y
	mul ebx
	add eax, 85
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 75, 25, color
	;;; Trunchiul incepe de la x + 40, y + 45
	mov eax, Piesa_Generata_x
	add eax, 20
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	sub eax, 45
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 35, 45, color
	;;; Partea de sus incepe de la x + 27
	mov eax, Piesa_Generata_x
	sub eax, 8
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	sub eax, 20
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 51, 20, color
	;;; Varful la coroana
	;;; Partea_1
	mov eax, Piesa_Generata_y
	sub eax, 10
	mov Piesa_Generata_y, eax

	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 10, 10, color
	mov eax, Piesa_Generata_x
	add eax, 20
	mov Piesa_Generata_x, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 10, 10, color
	mov eax, Piesa_Generata_x
	add eax, 20
	mov Piesa_Generata_x, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 10, 10, color
	pop ebx
	pop edx
	pop ecx
	pop eax
endm

Desen_Pion macro x, y, color
	push eax
	push ecx
	push edx
	push ebx
	;;; BAZA (36, 75) cu lung de 50 si lat de 40
	mov edx, 0
	mov eax, x
	mov ebx, 125
	mul ebx
	add eax, 36
	mov Piesa_Generata_x, eax
	mov edx, 0
	mov eax, y
	mul ebx
	add eax, 75
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 50, 40, color
	;;; MIJLOCUL (43,40) cu lung 50 si latimea de 40
	mov eax, Piesa_Generata_x
	add eax, 7
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	sub eax, 35
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 36, 35, color
	;;; VARFUL (56, 30) cu lung si lat de 13
	mov eax, Piesa_Generata_x
	add eax, 10
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	sub eax, 16
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 16, 16, color
	pop ebx
	pop edx
	pop ecx
	pop eax
endm

Desen_Cal macro x, y, color
	push eax
	push ecx
	push edx
	push ebx
	;;; BAZA(85, 23) de lung 80 si lat 30
	mov edx, 0
	mov eax, x
	mov ebx, 125
	mul ebx
	add eax, 23
	mov Piesa_Generata_x, eax
	mov edx, 0
	mov eax, y
	mul ebx
	add eax, 85
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 80, 30, color
	;;; BUC_1(52,23) de lung 30 si lat 45
	mov eax, Piesa_Generata_y
	sub eax, 45
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 30, 45, color
	;;; BUC_2(40,38) de lung 30 si lat 20
	mov eax, Piesa_Generata_x
	add eax, 15
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	sub eax, 20
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 30, 20, color
	;;; CAPUL(25,68) de lung si lat 35
	mov eax, Piesa_Generata_x
	add eax, 30
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	add eax, 5
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 35, 35, color
	;;; Ochiul(30,88) de lung 8 si lat 4
	mov eax, Piesa_Generata_x
	add eax, 20
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	add eax, 5
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 8, 4, 0FFFFFFh - color
	pop ebx
	pop edx
	pop ecx
	pop eax
endm

Desen_Nebun macro x, y, color
	push eax
	push ecx
	push edx
	push ebx
	;;; BAZA(25,95) de lungime 75 si latime 20
	mov edx, 0
	mov eax, x
	mov ebx, 125
	mul ebx
	add eax, 25
	mov Piesa_Generata_x, eax
	mov edx, 0
	mov eax, y
	mul ebx
	add eax, 95
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 75, 20, color
	;;; BUC_1(35,85) De lungime 35 si latime 10
	mov eax, Piesa_Generata_x
	add eax, 10
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	sub eax, 10
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 55, 10, color
	;;; BUC_2(45,35) De lungime 35 si latime 50
	mov eax, Piesa_Generata_x
	add eax, 15
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	sub eax, 50
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 25, 50, color
	;;; BUC_3(35,25) De lungime 55 si latime 10
	mov eax, Piesa_Generata_x
	sub eax, 10
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	sub eax, 10
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 45, 10, color
	;;; BUC_4(50,15) De lungime 35 si latime 10
	mov eax, Piesa_Generata_x
	add eax, 10
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	sub eax, 10
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 25, 10, color
	;;; BUC_5(60,5) De lungime 15 si latime 15
	mov eax, Piesa_Generata_x
	ADD eax, 10
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	sub eax, 5
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 5, 5, color
	pop ebx
	pop edx
	pop ecx
	pop eax
endm

Desen_Rege macro x, y, color
	pusha
;;; VERTICALALA
	mov edx, 0
	mov eax, x
	mov ebx, 125
	mul ebx
	add eax, 50
	mov Piesa_Generata_x, eax
	mov edx, 0
	mov eax, y
	mul ebx
	add eax, 10
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 25, 105, color
;;; ORIZONTALA
	mov eax, Piesa_Generata_x
	sub eax, 40
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	add eax, 50
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 105, 25, color
;;; MIJLOCUL
	mov eax, Piesa_Generata_x
	add eax, 40
	mov Piesa_Generata_x, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 25, 25, 0FFFFFFh - color
	popa
endm

Desen_Regina macro x, y, color
	push eax
	push ecx
	push edx
	push ebx
;;; VERTICALALA
	mov edx, 0
	mov eax, x
	mov ebx, 125
	mul ebx
	add eax, 50
	mov Piesa_Generata_x, eax
	mov edx, 0
	mov eax, y
	mul ebx
	add eax, 10
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 25, 105, color
	pop ebx
	pop edx
	pop ecx
	pop eax
endm

Desen_Mutare macro x, y, color
	push eax
	push ecx
	push edx
	push ebx
	
	mov edx, 0
	mov eax, x
	mov ebx, 125
	mul ebx
	add eax, 2
	mov Piesa_Generata_x, eax
	mov edx, 0
	mov eax, y
	mul ebx
	add eax, 2
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 121, 5, color
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 5, 121, color
	;;; Baza de jos
	mov eax, Piesa_Generata_y
	add eax, 116
	mov Piesa_Generata_y, eax
	Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 121, 5, color
	mov eax, Piesa_Generata_x
	add eax, 116
	mov Piesa_Generata_x, eax
	mov eax, Piesa_Generata_y
	sub eax, 116
	mov Piesa_Generata_y, eax
	 Rectangle_XxY Piesa_Generata_x, Piesa_Generata_y, 5, 121, color
	mov Piesa_Generata_y, eax
	pop ebx
	pop edx
	pop ecx
	pop eax
endm

Afisare_Mutari_Disponibile macro y
local bucla
local next1
local next2
local next3
local next4
local next5
local next6
local next7
local next8
	pusha
	mov ecx, 0 ; 0
	mov Pozitionare_x, ecx
	mov eax, ecx
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [Mutari + ebx * 4] ;;; avem type dword
	cmp eax, 1
	jnz next1
	Desen_Mutare Pozitionare_x, y, 0D3D3D3h
	next1:
	add ecx, 1 ; 1
	mov Pozitionare_x, ecx
	mov eax, ecx
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [Mutari + ebx * 4] ;;; avem type dword
	cmp eax, 1
	jnz next2
	Desen_Mutare Pozitionare_x, y, 0D3D3D3h
	next2:
	add ecx, 1 ; 2
	mov Pozitionare_x, ecx
	mov eax, ecx
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [Mutari + ebx * 4] ;;; avem type dword
	cmp eax, 1
	jnz next3
	Desen_Mutare Pozitionare_x, y, 0D3D3D3h
	next3:
	add ecx, 1 ; 3
	mov Pozitionare_x, ecx
	mov eax, ecx
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [Mutari + ebx * 4] ;;; avem type dword
	cmp eax, 1
	jnz next4
	Desen_Mutare Pozitionare_x, y, 0D3D3D3h
	next4:
	add ecx, 1 ; 4
	mov Pozitionare_x, ecx
	mov eax, ecx
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [Mutari + ebx * 4] ;;; avem type dword
	cmp eax, 1
	jnz next5
	Desen_Mutare Pozitionare_x, y, 0D3D3D3h
	next5:
	add ecx, 1 ; 5
	mov Pozitionare_x, ecx
	mov eax, ecx
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [Mutari + ebx * 4] ;;; avem type dword
	cmp eax, 1
	jnz next6
	Desen_Mutare Pozitionare_x, y, 0D3D3D3h
	next6:
	add ecx, 1 ; 6
	mov Pozitionare_x, ecx
	mov eax, ecx
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [Mutari + ebx * 4] ;;; avem type dword
	cmp eax, 1
	jnz next7
	Desen_Mutare Pozitionare_x, y, 0D3D3D3h
	next7:
	add ecx, 1 ; 7
	mov Pozitionare_x, ecx
	mov eax, ecx
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [Mutari + ebx * 4] ;;; avem type dword
	cmp eax, 1
	jnz next8
	Desen_Mutare Pozitionare_x, y, 0D3D3D3h
	next8:
	popa
endm
;;; Schimbare matrice piese
Cleanup_Mutari macro
local loop_x
local loop_y
	pusha
	mov INTERMEDIAR_1, 0 ; y
	mov ecx, 8
loop_y:
	push ecx
	mov ecx, 8
	mov INTERMEDIAR, 0 ; x
	loop_x:
		mov eax, INTERMEDIAR
		mov ebx, INTERMEDIAR_1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], 0
		inc eax
		mov INTERMEDIAR, eax
		;afisare INTERMEDIAR
	loop loop_x
	pop ecx
	mov eax, INTERMEDIAR_1
	inc eax
	mov INTERMEDIAR_1, eax
	;Afisare_Enter
loop loop_y
	popa
endm
;;; VERIFICARI
Verificare_Mutare_Posibila macro x, y
local Non_Posibil
local Posibil
local final
	pusha
	mov eax, x
	mov ebx, y 
	imul ebx, 8
	add ebx, eax
	mov eax, [Mutari + ebx * 4]
	mov ecx, [Matrix + ebx * 4]
	cmp eax, 1
	jne Non_Posibil ;; Daca poti ca piesa muta acolo 
	cmp ecx, 0
	je Posibil
	mov eax, ecx
	mov edx, 0
	mov ebx, 100
	div ebx
	cmp eax, ROUND
	je Non_Posibil ;; Daca nu se afla o piesa deja acolo
Posibil:
	mov Mutare_Posibila, 1
	jmp final
Non_Posibil:
	mov Mutare_Posibila, 0
final:
	popa
endm
Verificare_Atingere_Piesa macro x, y
local Ne_atins
	pusha
		mov eax, x
		mov ebx, y 
		imul ebx, 8
		add ebx, eax
		mov ecx, [Matrix + ebx * 4]
		cmp ecx, 0
		je  Ne_atins
		mov eax, ecx
		mov ebx, 100
		mov edx, 0 
		div ebx
		cmp eax, ROUND
		jne Ne_atins
		mov STARE_CLICK, 2
		Ne_atins:
	popa
endm
Verificare_Rocada_Dreapta macro y 
local NU
	pusha
		mov ebx, y
		mov eax, 5
		imul ebx, 8
		add ebx, eax
		mov ecx, [MATRIX + ebx * 4]
		cmp ecx, 0
		jne NU
		mov ebx, y
		mov eax, 6
		imul ebx, 8
		add ebx, eax
		mov ecx, [MATRIX + ebx * 4]
		cmp ecx, 0
		jne NU
		mov ebx, y
		mov eax, 6
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], 1
NU:
	popa
endm
Verificare_Rocada_Stanga macro y
local NU
	pusha
		mov ebx, y
		mov eax, 3
		imul ebx, 8
		add ebx, eax
		mov ecx, [MATRIX + ebx * 4]
		cmp ecx, 0
		jne NU
		mov ebx, y
		mov eax, 2
		imul ebx, 8
		add ebx, eax
		mov ecx, [MATRIX + ebx * 4]
		cmp ecx, 0
		jne NU
		mov ebx, y
		mov eax, 1
		imul ebx, 8
		add ebx, eax
		mov ecx, [MATRIX + ebx * 4]
		cmp ecx, 0
		jne NU
		mov ebx, y
		mov eax, 2
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], 1
NU:
	popa
endm
Verificare_Advance_Alb macro x, y
local jump1
	pusha
		mov eax, x
		mov ebx, y 
		cmp ebx, 0
		jne jump1
		imul ebx, 8
		add ebx, eax
		mov [MATRIX + 4 * ebx], 90
jump1:
	popa
endm

Verificare_Advance_Negru macro x, y
local jump1
	pusha
		mov eax, x
		mov ebx, y 
		cmp ebx, 0
		jne jump1
		imul ebx, 8
		add ebx, eax
		mov [MATRIX + 4 * ebx], 190
	popa
jump1:
endm
;;; Setare mutari piese
Setare_Mutari_Tura macro x, y, set
	local loop1
	local loop2
	local loop3
	local loop4
	local next1
	local next2
	local next3
	local next4
	pusha
	mov eax, x
	mov ecx, x
	cmp ecx, 0
jz next1
loop1:
	mov ebx, y
	imul ebx, 8	
	dec eax
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov INTERMEDIAR, ecx
	mov ecx, [MATRIX + ebx * 4]
	cmp ecx, 0
	jne next1
	mov ecx, INTERMEDIAR
loop loop1
next1:
	mov eax, x
	mov ecx, 7
	sub ecx, x
	cmp ecx, 0
jz next2
loop2:
	mov ebx, y
	imul ebx, 8
	inc eax
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov INTERMEDIAR, ecx
	mov ecx, [MATRIX + ebx * 4]
	cmp ecx, 0
	jne next2
	mov ecx, INTERMEDIAR
loop loop2
next2:
	mov eax, x
	mov ebx, y
	mov ecx, y
	cmp ecx, 0
jz next3
loop3: ;;; jos
	dec ebx
	mov INTERMEDIAR, ebx
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov Pozitionare, ecx
	mov ecx, [MATRIX + ebx * 4]
	afisare ecx
	cmp ecx, 0
	jne next3
	mov ecx, Pozitionare
	mov ebx, INTERMEDIAR
loop loop3
next3:
	mov eax, x
	mov ebx, y
	mov ecx, 7
	sub ecx, y
	cmp ecx, 0
jz next4
loop4: ;;; sus
	inc ebx
	mov INTERMEDIAR, ebx
	imul ebx, 8
	add ebx, eax
	mov Pozitionare, ecx
	mov [Mutari + ebx * 4], set
	mov ecx, [MATRIX + ebx * 4]
	afisare ecx
	cmp ecx, 0
	jne next4
	mov ecx, Pozitionare
	mov ebx, INTERMEDIAR
loop loop4
next4:
	popa
 endm
Setare_Mutari_Nebun macro x, y, set
	local loop1
	local loop2
	local loop3
	local loop4
	local next1
	local next2
	local next3
	local next4
	pusha
	
	mov eax, x
	mov ebx, y
	add eax, 1
	add ebx, 1
	cmp eax, 8
	je next1
	cmp ebx, 8
	je next1
loop1: ;; +1 +1
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov Pozitionare, ecx
	mov ecx, [MATRIX + ebx * 4]
	cmp ecx, 0
	jne next1
	mov ecx, Pozitionare
	mov ebx, INTERMEDIAR
	add eax, 1
	add ebx, 1
	cmp eax, 8
	je next1
	cmp ebx, 8
	je next1
jmp loop1
next1:	

	mov eax, x
	mov ebx, y
	cmp eax, 0
	je next2
	cmp ebx, 0
	je next2
loop2: ; -1 -1
	sub eax, 1
	sub ebx, 1
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov Pozitionare, ecx
	mov ecx, [MATRIX + ebx * 4]
	cmp ecx, 0
	jne next2
	mov ecx, Pozitionare
	mov ebx, INTERMEDIAR
	cmp eax, 0
	je next2
	cmp ebx, 0
	je next2
jmp loop2
next2:

	mov eax, x
	mov ebx, y
	add ebx, 1
	cmp eax, 0
	je next3
	cmp ebx, 8
	je next3
loop3: ; -1 +1
	sub eax, 1
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov Pozitionare, ecx
	mov ecx, [MATRIX + ebx * 4]
	cmp ecx, 0
	jne next3
	mov ecx, Pozitionare
	mov ebx, INTERMEDIAR
	add ebx, 1
	cmp eax, 0
	je next3
	cmp ebx, 8
	je next3
jmp loop3
 next3:

	mov eax, x
	mov ebx, y
	add eax, 1
	cmp eax, 8
	je next4
	cmp ebx, 0
	je next4
loop4: ; +1 -1
	sub ebx, 1
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov Pozitionare, ecx
	mov ecx, [MATRIX + ebx * 4]
	cmp ecx, 0
	jne next4
	mov ecx, Pozitionare
	mov ebx, INTERMEDIAR
	add eax, 1
	cmp eax, 8
	je next4
	cmp ebx, 0
	je next4
jmp loop4
next4:
	popa
endm

Setare_Mutari_Cal macro x, y, set
	local next1
	local next1_main
	local next2
	local next2_main
	local next3
	local next3_main
	local next4
	local next4_main
	pusha
	
	mov eax, x
	mov ebx, y
	;;; jos jos dreapta/stanga
	add ebx, 2 
	cmp ebx, 7
	ja next1
	cmp eax, 0 ;; daca eax e mai mare ca 1
	je next1
	sub eax, 1
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov ebx, INTERMEDIAR
	add eax, 1
next1:
	add eax, 1
	cmp eax, 8
	je next1_main
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov ebx, INTERMEDIAR
next1_main:
	
	mov eax, x
	mov ebx, y
	;; stanga stanga sus/jos
	cmp eax, 1
	je next2_main
	cmp eax, 0
	je next2_main
	sub eax, 2
	cmp ebx, 0
	je next2
	sub ebx, 1
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov ebx, INTERMEDIAR
	add ebx, 1
next2:
	add ebx, 1
	cmp ebx, 8
	je next2_main
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov ebx, INTERMEDIAR
next2_main:

	mov eax, x
	mov ebx, y
	; sus sus dreapta/stanga
	cmp ebx, 1
	je next3_main
	cmp ebx, 0
	je next3_main
	sub ebx, 2
	cmp eax, 0
	je next3
	sub eax, 1
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov ebx, INTERMEDIAR
	add eax, 1
next3:
	add eax, 1
	cmp eax, 8
	je next3_main
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov ebx, INTERMEDIAR
next3_main:
	mov eax, x
	mov ebx, y
	; dreapta dreapta sus/jos
	add eax, 2
	cmp eax, 7
	ja next4_main
	cmp ebx, 0
	je next4
	sub ebx, 1
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov ebx, INTERMEDIAR
	add ebx, 1
next4:
	add ebx, 1
	cmp ebx, 8
	je next4_main
	mov INTERMEDIAR, ebx
	mov edx, 0
	imul ebx, 8
	add ebx, eax
	mov [Mutari + ebx * 4], set
	mov ebx, INTERMEDIAR
next4_main:
	popa
endm

Setare_Mutari_Pion_Negru macro x, y , set
local next2
local next3
local next4
local next_en_passant
local en_passant
	pusha
		mov eax, x
		mov ebx, y
		; Ca sa mutam o casuta
		add ebx, 1
		imul ebx, 8
		add ebx, eax
		mov eax, [Matrix + ebx * 4]
		cmp eax, 0
		jne next2
		mov [Mutari + ebx * 4], set	
		mov eax, x
		mov ebx, y
		;;;Ca sa mutam 2 casute
		cmp ebx, 1
		jne next2
		add ebx, 2
		imul ebx, 8
		add ebx, eax
		mov eax, [Matrix + ebx * 4]
		cmp eax, 0
		jne next2
		mov [Mutari + ebx * 4], set
		 next2:
		mov eax, x
		mov ebx, y
		; Ca sa mutam +1 +1 // ca sa atacam
		add ebx, 1
		cmp ebx, 8
		je next3
		add eax, 1
		cmp eax, 8
		je next3
		imul ebx, 8
		add ebx, eax
		mov INTERMEDIAR, ebx
		mov eax, [Matrix + ebx * 4]
		cmp eax, 0
		je next3
		mov edx, 0
		mov ebx, 100
		div ebx
		cmp eax, ROUND
		je next3
		mov ebx, INTERMEDIAR
		mov [Mutari + ebx * 4], set
	 next3:
		mov eax, x
		mov ebx, y
		; Ca sa mutma -1 +1 // ca sa atacam
		cmp eax, 0
		je next4
		sub eax, 1
		add ebx, 1
		cmp ebx, 8 
		je next4
		imul ebx, 8
		add ebx, eax
		mov INTERMEDIAR, ebx
		mov eax, [Matrix + ebx * 4]
		cmp eax, 0
		je next4
		mov edx, 0
		mov ebx, 100
		div ebx
		cmp eax, ROUND
		je next4
		mov ebx, INTERMEDIAR
		mov [Mutari + ebx * 4], set
	 next4:
		
		mov eax, x
		mov ebx, y
		cmp ebx, 4
		jne next_en_passant
		mov ecx, En_passant_legit
		cmp ecx, 1
		jne next_en_passant
		;;; EN PASSANT / dreapta
		add eax, 1
		cmp eax, Precedent_x
		jne en_passant
		cmp ebx, Precedent_y
		jne en_passant
		add ebx, 1
		imul ebx, 8
		add ebx, eax
		mov INTERMEDIAR, ebx
		mov [Mutari + ebx * 4], set
		mov eax, 1
		mov EN_PASSANT_OK, eax
		mov En_passant_legit, 0
		jmp next_en_passant
	 en_passant:
		
		mov eax, x
		mov ebx, y
		; EN PASSANT / stanga
		cmp eax, 0
		je next_en_passant
		sub eax, 1
		cmp eax, Precedent_x
		jne next_en_passant
		cmp ebx, Precedent_y
		jne next_en_passant
		add ebx, 1
		imul ebx, 8
		add ebx, eax
		mov INTERMEDIAR, ebx
		mov [Mutari + ebx * 4], set
		mov eax, 1
		mov EN_PASSANT_OK, eax
		mov En_passant_legit, 0
	next_en_passant:
	popa
endm

Setare_Mutari_Pion_Alb macro x, y, set
local next2
local next3
local next4
local next_en_passant
local en_passant
	pusha
		mov eax, x
		mov ebx, y
		; Ca sa mutam o casuta
		sub ebx, 1
		imul ebx, 8
		add ebx, eax
		mov eax, [Matrix + ebx * 4]
		cmp eax, 0
		jne next2
		mov [Mutari + ebx * 4], set
		
		mov eax, x
		mov ebx, y
		;;;Ca sa mutam 2 casute
		cmp ebx, 6
		jne next2
		sub ebx, 2
		imul ebx, 8
		add ebx, eax
		mov eax, [Matrix + ebx * 4]
		cmp eax, 0
		jne next2
		mov [Mutari + ebx * 4], set
	next2:
		; Ca sa mutam -1 -1 // ca sa atacam
		mov eax, x
		mov ebx, y
		cmp x, 0
		je next3
		sub ebx, 1
		sub eax, 1
		imul ebx, 8
		add ebx, eax
		mov INTERMEDIAR, ebx
		mov eax, [Matrix + ebx * 4]
		cmp eax, 0
		je next3
		mov edx, 0
		mov ebx, 100
		div ebx
		cmp eax, ROUND
		je next3
		mov ebx, INTERMEDIAR
		mov [Mutari + ebx * 4], set
	next3:
		mov eax, x
		mov ebx, y
		; Ca sa mutam +1 -1 // ca sa atacam
		add eax, 1
		sub ebx, 1
		imul ebx, 8
		add ebx, eax
		mov INTERMEDIAR, ebx
		mov eax, [Matrix + ebx * 4]
		cmp eax, 0
		je next4
		mov edx, 0
		mov ebx, 100
		div ebx
		cmp eax, ROUND
		je next4
		mov ebx, INTERMEDIAR
		mov [Mutari + ebx * 4], set
	 next4:
	 
		mov eax, x
		mov ebx, y
		cmp ebx, 3
		jne next_en_passant
		mov ecx, En_passant_legit
		cmp ecx, 1
		jne next_en_passant
		;;; EN PASSANT / dreapta
		add eax, 1
		cmp eax, Precedent_x
		jne en_passant
		cmp ebx, Precedent_y
		jne en_passant
		sub ebx, 1
		imul ebx, 8
		add ebx, eax
		mov INTERMEDIAR, ebx
		mov [Mutari + ebx * 4], set
		mov eax, 1
		mov EN_PASSANT_OK, eax
		mov En_passant_legit, 0
		jmp next_en_passant
	 en_passant:
		
		mov eax, x
		mov ebx, y
		; EN PASSANT / stanga
		cmp eax, 0
		je next_en_passant
		sub eax, 1
		cmp eax, Precedent_x
		jne next_en_passant
		cmp ebx, Precedent_y
		jne next_en_passant
		sub ebx, 1
		imul ebx, 8
		add ebx, eax
		mov INTERMEDIAR, ebx
		mov [Mutari + ebx * 4], set
		mov eax, 1
		mov EN_PASSANT_OK, eax
		mov En_passant_legit, 0
	next_en_passant:
	popa
endm

Setare_Mutari_Rege_Alb macro x, y, set
local next_1
local next_2
local next_3
local next_4
local next_5
local next_6
local next_7
local next_8
local Rocada
local Dreapta
	pusha
		;; sus
		mov eax, x
		mov ebx, y
		cmp ebx, 0
		je next_1
		dec ebx
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_1:
		;; stanga-sus
		mov eax, x
		mov ebx, y
		cmp ebx, 0
		je next_2
		cmp eax, 0
		je next_2
		sub eax, 1
		sub ebx, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_2:
		;; stanga
		mov eax, x
		mov ebx, y
		cmp eax, 0
		je next_3
		sub eax, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_3:
		;; stanga-jos
		mov eax, x
		mov ebx, y
		cmp eax, 0
		je next_4
		cmp ebx, 7
		je next_4
		sub eax, 1
		add ebx, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_4:
		;; jos
		mov eax, x
		mov ebx, y
		cmp ebx, 7
		je next_5
		add ebx, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_5:
		;; dreapta-jos
		mov eax, x
		mov ebx, y
		cmp eax, 7
		je next_6
		cmp ebx, 7
		je next_6
		add eax, 1
		add ebx, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_6:
		;; dreapta
		mov eax, x
		mov ebx, y
		cmp eax, 7
		je next_7
		add eax, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_7:
		;; dreapta-sus
		mov eax, x
		mov ebx, y
		cmp eax, 7
		je next_8
		cmp ebx, 0
		je next_8
		add eax, 1
		sub ebx, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_8:
		;; ROCADA
		afisare Rocada_Rege_alb
		mov eax, Rocada_Rege_alb
		cmp eax, 1
		je Rocada
		mov eax, Tura_Alba_stanga_mutata
		cmp eax, 1
		je Dreapta
			Verificare_Rocada_Stanga 7
	Dreapta:
		mov eax, Tura_Alba_dreapta_mutata
		cmp eax, 1
		je Rocada
			Verificare_Rocada_Dreapta 7
	Rocada:
	popa
endm

Setare_Mutari_Rege_Negru macro x, y, set, poz
local next_1
local next_2
local next_3
local next_4
local next_5
local next_6
local next_7
local next_8
local Rocada
local Dreapta
	pusha
		;; sus
		mov eax, x
		mov ebx, y
		cmp ebx, 0
		je next_1
		dec ebx
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_1:
		;; stanga-sus
		mov eax, x
		mov ebx, y
		cmp ebx, 0
		je next_2
		cmp eax, 0
		je next_2
		sub eax, 1
		sub ebx, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_2:
		;; stanga
		mov eax, x
		mov ebx, y
		cmp eax, 0
		je next_3
		sub eax, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_3:
		;; stanga-jos
		mov eax, x
		mov ebx, y
		cmp eax, 0
		je next_4
		cmp ebx, 7
		je next_4
		sub eax, 1
		add ebx, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_4:
		;; jos
		mov eax, x
		mov ebx, y
		cmp ebx, 7
		je next_5
		add ebx, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_5:
		;; dreapta-jos
		mov eax, x
		mov ebx, y
		cmp eax, 7
		je next_6
		cmp ebx, 7
		je next_6
		add eax, 1
		add ebx, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_6:
		;; dreapta
		mov eax, x
		mov ebx, y
		cmp eax, 7
		je next_7
		add eax, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_7:
		;; dreapta-sus
		mov eax, x
		mov ebx, y
		cmp eax, 7
		je next_8
		cmp ebx, 0
		je next_8
		add eax, 1
		sub ebx, 1
		imul ebx, 8
		add ebx, eax
		mov [Mutari + ebx * 4], set
	next_8:
		;; ROCADA
		mov eax, Rocada_Rege_negru
		cmp eax, 1
		je Rocada
		mov eax, Tura_Neagra_stanga_mutata
		cmp eax, 1
		je Dreapta
			Verificare_Rocada_Stanga 0
	Dreapta:
		mov eax, Tura_Neagra_dreapta_mutata
		cmp eax, 1
		je Rocada
			Verificare_Rocada_Dreapta 0
	Rocada:
	popa
endm

Mutare_Rocada_Dreapta macro y
	pusha
		;;; MUTAM REGELE IN NOUA POZITIE
		mov eax, 4
		mov ebx, y
		imul ebx, 8
		add ebx, eax
		mov ecx, [MATRIX + ebx * 4]
		mov [MATRIX + ebx * 4], 0
		mov eax, 6
		mov ebx, y
		imul ebx, 8
		add ebx, eax
		mov [MATRIX + ebx * 4], ecx
		;;; MUTAM TURA IN NOUA POZITIE
		mov eax, 7
		mov ebx, y
		imul ebx, 8
		add ebx, eax
		mov ecx, [MATRIX + ebx * 4]
		mov [MATRIX + ebx * 4], 0
		mov eax, 5
		mov ebx, y
		imul ebx, 8
		add ebx, eax
		mov [MATRIX + ebx * 4], ecx
	popa
endm

Mutare_Rocada_Stanga macro y
	pusha
		;;; MUTAM REGELE IN NOUA POZITIE
		mov eax, 4
		mov ebx, y
		imul ebx, 8
		add ebx, eax
		mov ecx, [MATRIX + ebx * 4]
		mov [MATRIX + ebx * 4], 0
		mov eax, 2
		mov ebx, y
		imul ebx, 8
		add ebx, eax
		mov [MATRIX + ebx * 4], ecx
		;;; MUTAM TURA IN NOUA POZITIE
		mov eax, 0
		mov ebx, y
		imul ebx, 8
		add ebx, eax
		mov ecx, [MATRIX + ebx * 4]
		mov [MATRIX + ebx * 4], 0
		mov eax, 3
		mov ebx, y
		imul ebx, 8
		add ebx, eax
		mov [MATRIX + ebx * 4], ecx
	popa
endm
;;; POZITIONARE PIESE
Poz_Verificare_Piesa macro x, y, Piesa
local Rege_A
local Regina_A
local Turn_A
local Nebun_A
local Cal_A
local Pion_A
local Rege_N
local Regina_N
local Turn_N
local Nebun_N
local Cal_N
local Pion_N
local final
	pusha
	mov eax, Piesa
;;; ALB
	cmp eax, 111
	jz Pion_N
	cmp eax, 131
	jz Cal_N
	cmp eax, 141
	jz Nebun_N
	cmp eax, 151
	jz Turn_N
	cmp eax, 152
	jz Turn_N
	cmp eax, 190
	jz Regina_N
	cmp eax, 199
	jz Rege_N
;;; NEGRU
	cmp eax, 10
	jz Pion_A
	cmp eax, 31
	jz Cal_A
	cmp eax, 41
	jz Nebun_A
	cmp eax, 51
	jz Turn_A
	cmp eax, 52
	jz Turn_A
	cmp eax, 90
	jz Regina_A
	cmp eax, 99
	jz Rege_A
	jmp final
	
Rege_N:
	Desen_Rege x, y, 0
	jmp final
Regina_N:
	Desen_Regina x, y, 0
	jmp final
Turn_N:
	Desen_Tura x, y, 0
	jmp final
Nebun_N:
	Desen_Nebun x, y, 0
	jmp final
Cal_N:
	Desen_Cal x, y, 0
	jmp final
Pion_N:
	Desen_Pion x, y, 0
	jmp final

Rege_A:
	Desen_Rege x, y, 0FFFFFFh
	jmp final
Regina_A:
	Desen_Regina x, y, 0FFFFFFh
	jmp final
Turn_A:
	Desen_Tura x, y, 0FFFFFFh
	jmp final
Nebun_A:
	Desen_Nebun x, y, 0FFFFFFh
	jmp final
Cal_A:
	Desen_Cal x, y, 0FFFFFFh
	jmp final
Pion_A:
	Desen_Pion x, y, 0FFFFFFh
	
final:  
	popa
endm

Pozitionare_Piese macro y ;;; Aici ne pregatim sa afisam fiecare piesa si unde este pozitionata pe tabla
local bucla_Pozitionare
local Verif_Alb
local Verif_Negru
	pusha
;;;		7
	mov ecx, 8

	mov eax, ecx
	dec eax
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [matrix + ebx * 4] ;;; avem type dword
	mov Pozitionare, eax
	mov ebx, ecx
	dec ebx
	mov Pozitionare_x, ebx
	mov ebx, y
	mov Pozitionare_y, ebx 
	mov eax, Pozitionare
	Poz_Verificare_Piesa Pozitionare_x, Pozitionare_y, Pozitionare
;;		6
	dec ecx
	mov eax, ecx
	dec eax
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [matrix + ebx * 4] ;;; avem type dword
	mov Pozitionare, eax
	mov ebx, ecx
	dec ebx
	mov Pozitionare_x, ebx
	mov ebx, y
	mov Pozitionare_y, ebx 
	mov eax, Pozitionare
	Poz_Verificare_Piesa Pozitionare_x, Pozitionare_y, Pozitionare
;; 	5
	dec ecx
	mov eax, ecx
	dec eax
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [matrix + ebx * 4] ;;; avem type dword
	mov Pozitionare, eax
	mov ebx, ecx
	dec ebx
	mov Pozitionare_x, ebx
	mov ebx, y
	mov Pozitionare_y, ebx 
	mov eax, Pozitionare
	Poz_Verificare_Piesa Pozitionare_x, Pozitionare_y, Pozitionare
; 	4
	dec ecx
	mov eax, ecx
	dec eax
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [matrix + ebx * 4] ;;; avem type dword
	mov Pozitionare, eax
	mov ebx, ecx
	dec ebx
	mov Pozitionare_x, ebx
	mov ebx, y
	mov Pozitionare_y, ebx 
	mov eax, Pozitionare
	Poz_Verificare_Piesa Pozitionare_x, Pozitionare_y, Pozitionare	
; 	3
	dec ecx
	mov eax, ecx
	dec eax
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [matrix + ebx * 4] ;;; avem type dword
	mov Pozitionare, eax
	mov ebx, ecx
	dec ebx
	mov Pozitionare_x, ebx
	mov ebx, y
	mov Pozitionare_y, ebx 
	mov eax, Pozitionare
	Poz_Verificare_Piesa Pozitionare_x, Pozitionare_y, Pozitionare
; 	2
	dec ecx
	mov eax, ecx
	dec eax
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [matrix + ebx * 4] ;;; avem type dword
	mov Pozitionare, eax
	mov ebx, ecx
	dec ebx
	mov Pozitionare_x, ebx
	mov ebx, y
	mov Pozitionare_y, ebx 
	mov eax, Pozitionare
	Poz_Verificare_Piesa Pozitionare_x, Pozitionare_y, Pozitionare
; 	1
	dec ecx
	mov eax, ecx
	dec eax
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [matrix + ebx * 4] ;;; avem type dword
	mov Pozitionare, eax
	mov ebx, ecx
	dec ebx
	mov Pozitionare_x, ebx
	mov ebx, y
	mov Pozitionare_y, ebx 
	mov eax, Pozitionare
	Poz_Verificare_Piesa Pozitionare_x, Pozitionare_y, Pozitionare
; 	0
	dec ecx
	mov eax, ecx
	dec eax
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [matrix + ebx * 4] ;;; avem type dword
	mov Pozitionare, eax
	mov ebx, ecx
	dec ebx
	mov Pozitionare_x, ebx
	mov ebx, y
	mov Pozitionare_y, ebx 
	mov eax, Pozitionare
	Poz_Verificare_Piesa Pozitionare_x, Pozitionare_y, Pozitionare
;;;;; GATA AFISARE
	popa
endm

Optional macro x, y
local next
local final
pusha
mov eax, STARE_CLICK
	 cmp eax, 2
	 jne next
	 Setare_Mutari_Tura x, y, 1
	 mov STARE_CLICK, 1
	 jmp final
	 next:
		Cleanup_Mutari
		mov STARE_CLICK, 2
	 final:
popa
	
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MUTARE PIESA
Mutare_Piesa macro old_x, old_y, new_x, new_y ;;; PLUS EN PASSANT
local Nu_e_en_passant
local Alb
local final
local Inceput
local after
local Diferenta_1
local Nu_e_Pion
local Final_Tura
local Tura_Alba_Dreapta
local Tura_Negru_Stanga
local Tura_Negru_Dreapta
local Rege_Negru
local Nu_e_Rege
local Diferenta_Rege_Alb
local Diferenta_Rege_Negru
local Pion_N_Regina
local Pion_A_Regina
local Not_Won
	pusha
	
	mov eax, old_x
	mov ebx, old_y
	imul ebx, 8
	add ebx, eax
	mov ecx, [Matrix + ebx * 4] ;;; Pastram valoarea veche in ecx
		;;; Verificam daca e mutata vreuna dintre ture 	
	cmp ecx, 51
	jne Tura_Alba_Dreapta
	mov Tura_Alba_stanga_mutata, 1
Tura_Alba_Dreapta:
	cmp ecx, 52
	jne Tura_Negru_Stanga
	mov Tura_Alba_dreapta_mutata, 1
Tura_Negru_Stanga:
	cmp ecx, 151
	jne Tura_Negru_Dreapta
	mov Tura_Neagra_stanga_mutata, 1
Tura_Negru_Dreapta:
	cmp ecx, 152
	jne Final_tura
	mov Tura_Neagra_dreapta_mutata, 1
Final_tura:
	;;; Gata cu turele
	
	;;; Pentru posibila rocada
		cmp ecx, 99 ;; Regele alb
		jne Rege_Negru
		mov Rocada_Rege_alb, 1
		mov eax, old_x
		mov ebx, new_x
		cmp eax, ebx
		ja Diferenta_Rege_Alb
			; eax mai mic ca ebx
		sub ebx, eax
		mov eax, ebx
		cmp eax, 2
		jne Nu_e_Rege
		Mutare_Rocada_Dreapta 7
		jmp after
Diferenta_Rege_Alb:
		sub eax, ebx
		cmp eax, 2
		jne Nu_e_Rege
		Mutare_Rocada_Stanga 7
		jmp after
Rege_Negru:
		cmp ecx, 199;; Regele negru
		jne Nu_e_Rege
		mov Rocada_Rege_negru, 1
		mov eax, old_x
		mov ebx, new_x
		cmp eax, ebx
		ja Diferenta_Rege_Negru
			; eax mai mic ca ebx
		sub ebx, eax
		mov eax, ebx
		cmp eax, 2
		jne Nu_e_Rege
		Mutare_Rocada_Dreapta 0
		jmp after
Diferenta_Rege_Negru:
		sub eax, ebx
		cmp eax, 2
		jne Nu_e_Rege
		Mutare_Rocada_Stanga 0
		jmp after
Nu_e_Rege:
		
	
	;;;Doar acum stergem
	mov eax, old_x
	mov ebx, old_y
	imul ebx, 8
	add ebx, eax
	mov [Matrix + ebx * 4], 0


	mov eax, EN_PASSANT_OK
	cmp eax, 1
	jne final
	mov eax, ROUND ;;; Verificam daca e randul lui negru/albi
	cmp eax, 0
	je Alb
	;;; En passant pentru negru
	mov eax, new_x
	mov ebx, new_y
	sub ebx, 1
	imul ebx, 8
	add ebx, eax
	mov [matrix + ebx * 4], 0
	mov EN_PASSANT_OK, 0
	jmp final
Alb:
	;;; En passant pentru albi
	mov eax, new_x
	mov ebx, new_y
	add ebx, 1
	imul ebx, 8
	add ebx, eax
	mov [matrix + ebx * 4], 0
	mov EN_PASSANT_OK, 0
final:
	
	mov eax, new_x
	mov ebx, new_y
	imul ebx, 8
	add ebx, eax
	push ecx
		mov ecx, [Matrix + ebx * 4]
		mov INTERMEDIAR, ecx
	pop ecx
	;;;;VERIFICAM DACA ESTE MAT
	mov [Matrix + ebx * 4], ecx ;;; Plasam valoarea veche pe pozitia noua
	push ecx
	mov ecx, INTERMEDIAR
	cmp ecx, 199
	jne Not_Won
	cmp ecx, 99
	jne Not_Won
	mov WIN, 1
Not_Won:
	pop ecx
	;;;;;
	cmp ecx, 111 ;;; Daca pionul negru este mutat
	je Inceput
	cmp ecx, 10
	jne Nu_e_Pion
Inceput:
		mov eax, old_y
		mov ebx, new_y
		cmp eax, ebx
		ja Diferenta_1
			; eax mai mic ca ebx
		sub ebx, eax
		mov eax, ebx
		cmp eax, 2
		jne Nu_e_Pion
		mov En_passant_legit, 1
		jmp after
Diferenta_1: ; eax mai  mare ca ebx
		sub eax, ebx
		cmp eax, 2
		jne Nu_e_Pion
		mov En_passant_legit, 1
		jmp after
Nu_e_Pion:
;;; Verificam daca se transforma in regina
	mov eax, new_x
	mov ebx, new_y
	imul ebx, 8
	add ebx, eax
	mov [Matrix + ebx * 4], ecx ;;; Plasam valoarea veche pe pozitia noua
	cmp ecx, 111 ;;; Daca pionul negru este mutat
	jne Pion_A_Regina
	Verificare_Advance_Negru new_x, new_y
	jmp after
Pion_A_Regina:
	cmp ecx, 10
	jne after
	Verificare_Advance_Alb new_x, new_y
after:
	
	mov Piesa_x_prec, 10;;; 10 inseamna ca piesa nu a fost apasata inca
	mov Piesa_y_prec, 10;;; 10 inseamna ca piesa nu a fost apasata inca
	popa
endm

Poz_Piesa_Prec macro x, y
pusha 
	mov eax, x
	mov Precedent_x, eax 
	mov eax, y
	mov Precedent_y, eax ;
	mov eax, x
	mov ebx, y
	imul ebx, 8
	add ebx, eax
	mov eax, [Matrix + ebx * 4]
	mov Precedent_Piesa, eax
popa
	;push INTERMEDIAR
endm
;;Black_Rectangle_XxY macro x, y
	
; endm
; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click, 3 - s-a apasat o tasta)
; arg2 - x (in cazul apasarii unei taste, x contine codul ascii al tastei care a fost apasata)
; arg3 - y
draw proc
	push ebp ;; Salvam ce vrem sa salvam in ebp
	mov ebp, esp ;; salvam pozitia de pe esp la inceput de toate
	pusha ;;; pusam tot
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz afisare_tabla ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	jmp afisare_tabla
	
evt_click:
	;; incepem sa mutam pisele si sa observam
	pusha
	;line_horizontal
	mov  ecx, WIN
	cmp ecx, 1
	je END_MATCH
	Identifier [ebp+arg2], [ebp+arg3] ;;; Vedem unde ne aflam pe tabla cu clickul si da translate in Piesa_x si Piesa_y
	mov eax, STARE_CLICK
	 cmp eax, 1
	 jne next
	 Recogniser Piesa_x, Piesa_y ;;; Odata gasita piesa, trebuie sa vedem unde sa mutam/ suntem in starea 1
	 mov eax, Piesa_x
	 mov Piesa_x_prec, eax ;; pentru a muta in viitor piesele
	 mov eax, Piesa_y
	 mov Piesa_y_prec, eax
	 Verificare_Atingere_Piesa Piesa_x, Piesa_y
	 jmp final
	 next:
		mov eax, Piesa_x_prec
		cmp eax, 10 ;;; 10 inseamna ca piesa nu a fost apasata inca
		je imposibil
		Verificare_Mutare_Posibila Piesa_x, Piesa_y
		mov eax, Mutare_Posibila
		cmp eax, 1
		jne imposibil
		Mutare_Piesa Piesa_x_prec, Piesa_y_prec, Piesa_x, Piesa_y 
		Poz_Piesa_Prec Piesa_x, Piesa_y ;;;; Salvam pozitia anterioara in stiva (x, y, piesa)
		Schimbare_Runda
			; afisare Precedent_x
			; afisare Precedent_y
			; afisare Precedent_Piesa
	 imposibil:
		Cleanup_Mutari
		mov STARE_CLICK, 1
	 final:
	;Optional Piesa_x, Piesa_y
	;;; NU UITA SA TE FOLOSESTI DE PIESA_X SI PIESA_Y, NU DE [ebp+arg2], [ebp+arg3]
END_MATCH:
	popa
    jmp afisare_tabla ; Jump to afisare_litere directly
	
bucla_linii:
	mov eax, [ebp+arg2]
	and eax, 0FFh
	; provide a new (random) color
	mul eax
	mul eax
	add eax, ecx
	push ecx
	mov ecx, area_width
bucla_coloane:
	mov [edi], eax
	add edi, 4
	add eax, ebx
	loop bucla_coloane
	pop ecx
	loop bucla_linii
	jmp afisare_tabla
afisare_tabla:
	;;;;;;;;;;;;;;;;;;;;;;;;; INCEPE PROIECTUL
	;;; Desenare tabla
	Linie_Patrate_Desen_AlbNegru 0, 0, 125
	Linie_Patrate_Desen_NegruAlb 125, 0, 125
	Linie_Patrate_Desen_AlbNegru 250, 0, 125
	Linie_Patrate_Desen_NegruAlb 375, 0, 125
	Linie_Patrate_Desen_AlbNegru 500, 0, 125
	Linie_Patrate_Desen_NegruAlb 625, 0, 125
    Linie_Patrate_Desen_AlbNegru 750, 0, 125
	Linie_Patrate_Desen_NegruAlb 875, 0, 125
	
	;;; Desenare coordonate in stanga jos
	make_text_macro 'I', area, 63, 980
	make_text_macro 'B', area, 188, 980
	make_text_macro 'K', area, 313, 980
	make_text_macro 'D', area, 438, 980
	make_text_macro 'M', area, 563, 980
	make_text_macro 'F', area, 688, 980
	make_text_macro 'O', area, 813, 980
	make_text_macro 'H', area, 938, 980
	
	make_text_macro '1', area, 1, 52
	make_text_macro 'Q', area, 1, 177
	make_text_macro '3', area, 1, 302
	make_text_macro 'R', area, 1, 427
	make_text_macro '5', area, 1, 552
	make_text_macro 'S', area, 1, 677
	make_text_macro '7', area, 1, 802
	make_text_macro 'T', area, 1, 927
	
	; POZITIE PIESE
	Pozitionare_Piese 0
	Pozitionare_Piese 1
	Pozitionare_Piese 2
	Pozitionare_Piese 3
	Pozitionare_Piese 4
	Pozitionare_Piese 5
	Pozitionare_Piese 6
	Pozitionare_Piese 7
	;;; mov eax, STARE_CLICK
	;;; cmp eax, 2
	;;; jnz Nu_afisam_Mutari_Disponibile
	Afisare_Mutari_Disponibile 0
	Afisare_Mutari_Disponibile 1
	Afisare_Mutari_Disponibile 2
	Afisare_Mutari_Disponibile 3
	Afisare_Mutari_Disponibile 4
	Afisare_Mutari_Disponibile 5
	Afisare_Mutari_Disponibile 6
	Afisare_Mutari_Disponibile 7
	
	Nu_afisam_Mutari_Disponibile:
	;White_Rectangle_XxY 
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2 ;; fiecare pixel va ocupa un double word de aceea trebuie shift
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
