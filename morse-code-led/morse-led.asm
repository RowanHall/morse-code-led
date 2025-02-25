; a2_morse.asm
; CSC 230: Fall 2024
;
; Student name:
; Student ID:
; Date of completed work:
;
; *******************************
; Code provided for Assignment #2
;
; Author: Mike Zastre (2024-Oct-09)
; 
; This skeleton of an assembly-language program is provided to help you
; begin with the programming tasks for A#2. As with A#1, there are 
; "DO NOT TOUCH" sections. You are *not* to modify the lines
; within these sections. The only exceptions are for specific
; changes announced on conneX or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****
;
; I have added for this assignment an additional kind of section
; called "TOUCH CAREFULLY". The intention here is that one or two
; constants can be changed in such a section -- this will be needed
; as you try to test your code on different messages.
;


; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================

.include "m2560def.inc"

.cseg
.equ S_DDRB=0x24
.equ S_PORTB=0x25
.equ S_DDRL=0x10A
.equ S_PORTL=0x10B

	
.org 0
	; Copy test encoding (of SOS) into SRAM
	;
	ldi ZH, high(TESTBUFFER)
	ldi ZL, low(TESTBUFFER)
	ldi r16, 0x30
	st Z+, r16
	ldi r16, 0x37
	st Z+, r16
	ldi r16, 0x30
	st Z+, r16
	clr r16
	st Z, r16

	; initialize run-time stack
	ldi r17, high(0x21ff)
	ldi r16, low(0x21ff)
	out SPH, r17
	out SPL, r16

	; initialize LED ports to output
	ldi r17, 0xff
	sts S_DDRB, r17
	sts S_DDRL, r17

; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================

; ***************************************************
; **** BEGINNING OF FIRST "STUDENT CODE" SECTION **** 
; ***************************************************

	; If you're not yet ready to execute the
	; encoding and flashing, then leave the
	; rjmp in below. Otherwise delete it or
	; comment it out.

	;LDI R16, 6
	;call leds_on
	;call delay_long
	;call leds_off
	;rjmp stop

    ; The following seven lines are only for testing of your
    ; code in part B. When you are confident that your part B
    ; is working, you can then delete these seven lines.

	;ldi r17, high(TESTBUFFER) ;before
	;ldi r16, low(TESTBUFFER);before
	;push r17;before
	;push r16;before

	;pop r30
	;pop r31
	;ldi r16, 0b01001110
	;call morse_flash
	;rjmp stop


	;rcall flash_message;before
    ;pop r16;before
    ;pop r17;before


	;call bitstore

	;ldi r16, 0b00101100 ; MORSE FLASH WORKS
	;call morse_flash  ; MORSE FLASH WORKS
	;					LETTER TO CODE
	;call ifdot ; WORKS
	;call ifdash ; WORKS

	;LETTER TO CODE TESTING
	;ldi r18, 0x45
	;push r18
	;call letter_to_code
	;mov r18, r0
	;cpi r18, 0b00010000
	;brne relstp
	;call ifdash
	;relstp:

	; ENCODE MESSAGE TESTING
	;ldi r17, high(MESSAGE02 << 1)
	;ldi r16, low(MESSAGE02 << 1)
	;push r17
	;push r16
	;ldi r17, high(BUFFER01)
	;ldi r16, low(BUFFER01)
	;push r17
	;push r16
	;rcall encode_message
	;ldi r17, high(BUFFER01)
	;ldi r16, low(BUFFER01)	
	;push r17
	;push r16
	;rcall flash_message

	;rjmp stop
   
; ***************************************************
; **** END OF FIRST "STUDENT CODE" SECTION ********** 
; ***************************************************


; ################################################
; #### BEGINNING OF "TOUCH CAREFULLY" SECTION ####
; ################################################

; The only things you can change in this section is
; the message (i.e., MESSAGE01 or MESSAGE02 or MESSAGE03,
; etc., up to MESSAGE09).
;

	; encode a message
	;
	ldi r17, high(MESSAGE03 << 1)
	ldi r16, low(MESSAGE03 << 1)
	push r17
	push r16
	ldi r17, high(BUFFER01)
	ldi r16, low(BUFFER01)
	push r17
	push r16
	rcall encode_message
	pop r16
	pop r16
	pop r16
	pop r16

; ##########################################
; #### END OF "TOUCH CAREFULLY" SECTION ####
; ##########################################


; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================
	; display the message three times
	;
	ldi r18, 3
main_loop:
	ldi r17, high(BUFFER01)
	ldi r16, low(BUFFER01)
	push r17
	push r16
	rcall flash_message
	dec r18
	tst r18
	brne main_loop


stop:
	rjmp stop
; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================


; ****************************************************
; **** BEGINNING OF SECOND "STUDENT CODE" SECTION **** 
; ****************************************************


flash_message:

	; first need to pop off the retern 17 bits from call, will push it back on after
	pop r1; first 0
	pop r2; second 0
	pop r3; return addr

	pop r30 ; low
	pop r31 ; high

	;protecting these values
	push r16
	push r19
	push r20
	push r21
	push r22
	push r23


	fl_loop:
	ld r19, Z+
	cpi r19, 0xff
	breq space

	cpi r19, 0
	breq end

	mov r16, r19
	call morse_flash
	
	rjmp fl_loop
	end:

	;protected values now back on
	pop r23
	pop r22
	pop r21
	pop r20
	pop r19
	pop r16

	push r3
	push r2
	push r1
	ret
space:
	call delay_long
	call delay_long
	call delay_long
	rjmp fl_loop


morse_flash:
	;gets value in r16
	;protecting these values
	push r16
	push r19
	push r20
	push r21
	push r22
	push r23


	mov r21, r16
	.def lenSeq=r21
	swap lenSeq
	ldi r22, 0b00001111
	and lenSeq, r22 
	; r21/lenSeq now has just num times/original highnibble in low
	;effectively our count now

	;set val of high nibble to r21 for num times
	mov r22, r16 

	cpi lenSeq, 4
	brne len3
	ldi r23, 0b00001000
	rjmp len_end
	len3:
	cpi lenSeq, 3
	brne len2
	ldi r23, 0b00000100
	rjmp len_end
	len2:
	cpi lenSeq, 2
	brne len1
	ldi r23, 0b00000010
	rjmp len_end
	len1:
	cpi lenSeq, 1
	brne len_end
	ldi r23, 0b00000001
	len_end:

	

	loop_through_len:
		dec lenSeq
		push r22
		and r22, r23
		cp r22, r23 ; if they are the same that means that bit was true then should be dash, if not then its false and should be dot
		pop r22
		breq dash
		rjmp after
		dash:
			call ifdash
			rjmp loopend
		after:
			call ifdot
		loopend:
		lsr r23
		cpi lenSeq, 0
		brne loop_through_len
		;protected values now back on
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r16

		ret

ifdot:
	ldi r16, 4
	call leds_on
	call delay_short
	call leds_off
	call delay_long
	ret
ifdash:
	ldi r16, 6
	call leds_on
	call delay_long
	call leds_off
	call delay_long
	ret



leds_on:
	; set prt B prt L as output	
	;protecting these values
	push r16
	push r20
	

	; checking the val of r16, putting the coresponding ammt of leds on

	ldi r20, 0
	cp r16, r20
	breq if0

	ldi r20, 1
	cp r16, r20
	breq if1

	ldi r20, 2
	cp r16, r20
	breq if2

	ldi r20, 3
	cp r16, r20
	breq if3

	ldi r20, 4
	cp r16, r20
	breq if4

	ldi r20, 5
	cp r16, r20
	breq if5

	ldi r20, 6
	cp r16, r20
	breq if6
	ret

	if0:
		ldi r20, 0
		sts	S_PORTL, R20
		ldi r20, 0
		sts S_PORTB, R20
		rjmp relend
	if1:
		ldi r20, 0b00000010
		sts	S_PORTL, R20
		ldi r20, 0b00000000
		sts S_PORTB, R20
		rjmp relend
	if2:
		ldi r20, 0b00001010
		sts	S_PORTL, R20
		ldi r20, 0b00000000
		sts S_PORTB, R20
		rjmp relend
	if3:
		ldi r20, 0b00101010
		sts	S_PORTL, R20
		ldi r20, 0b00000000
		sts S_PORTB, R20
		rjmp relend
	if4:
		ldi r20, 0b10101010
		sts	S_PORTL, R20
		ldi r20, 0b00000000
		sts S_PORTB, R20
		rjmp relend
	if5:
		ldi r20, 0b10101010
		sts	S_PORTL, R20
		ldi r20, 0b00000010
		sts S_PORTB, R20
		rjmp relend
	if6:
		ldi r20, 0b10101010
		sts	S_PORTL, R20
		ldi r20, 0b00001010
		sts S_PORTB, R20
		rjmp relend
	relend:

		;protected values now back on
		pop r20
		pop r16
		ret



leds_off:
	;protecting
	push r20

	ldi r20, 0
	sts S_PORTB, r20
	sts S_PORTL, r20

	;protected
	pop r20
	ret



encode_message:
	;return address
	pop r7
	pop r8
	pop r9 
	
	pop yl ; low buffer
	pop yh ; high buffer

	pop r30 ; low message
	pop r31 ; high message

	;protecting these values
	push r17
	push r19

	
	;for now we use this test val, should get the addy from stack tho
	;lpm YH, high(MESSAGE02)
	;lpm YL, low(MESSAGE02)
	message_loop:
		lpm r17, z+
		cpi r17, 0
		breq mess_end
		push r30
		push r31
		push r17
		call letter_to_code
		pop r31
		pop r30
		st y+, r0
		rjmp message_loop
	mess_end:

		;protected values now back on
		pop r19
		pop r17
		
		;pushing back on because popped off after function 
		push r31
		push r30
		push yh
		push yl

		;return value
		push r9
		push r8
		push r7

		ret


letter_to_code:
	; will be called so will have to push and pop return val

	pop r4 ; 0
	pop r5 ; 0
	pop r6 ; return address

	; get letter as byte location

	pop r25 ; letter to find

	push r19
	push r20
	push r24
	push r25

	; get db address to Y
	ldi ZH, high(ITU_MORSE*2)
	ldi ZL, low(ITU_MORSE*2)


	; gonna loop through db till we find letter
	find_letter:
		
		lpm r24, Z

		cpi r24, 0
		breq no_letter

		cp r24, r25
		breq yes_letter
		
		adiw ZL, 8

		rjmp find_letter

	;initialize 2 nums [one for dash or dot], [one for num blinks]
	yes_letter:
		;NUM BLINKS
		;no need for r25 anymore, lets use it for num blinks
		ldi r25, 0

		; DASH DOT
		ldi r19, 0

	; convert the letter we found to a byte w count and dash dot sequence
	letter_to_byte:
		;check if ==0 then end

		lpm r24, Z+
		cpi r24, 0
		breq finish
		;check if dash
		cpi r24, 45
		breq add_dash
		;check if dot
		cpi r24, 46
		breq add_dot
		rjmp letter_to_byte




	; put it all in the right place
	finish:

		; need to lsr r19 depending on length of r25
		cpi r25, 4
		breq finend


		cpi r25, 3
		brne finlen2
		; gets past if len3
		lsr r19
		rjmp finend


		finlen2:
		cpi r25, 2
		brne finlen1
		;gets past if len 2
		lsr r19
		lsr r19

		rjmp finend

		finlen1:
		cpi r25, 1
		lsr r19

		finend:
		swap r25
		or r25, r19
		mov r0, r25
		
		;values have been protected
		pop r25
		pop r24
		pop r20
		pop r19

		;pushing back on return address
		push r6
		push r5
		push r4
		ret

	no_letter:
		; if no letter add space
		ldi r25, 0xff
		mov r0, r25

		;values have been protected
		pop r25
		pop r24
		pop r20
		pop r19

		;pushing return address back on
		push r6
		push r5
		push r4
		ret

	add_dash:
		inc r25

		cpi r25, 4
		brne length3
		ori r19, 0b00000001
		jmp letter_to_byte

		length3:
		cpi r25, 3
		brne length2
		ori r19, 0b00000010
		jmp letter_to_byte

		length2:
		cpi r25, 2
		brne length1
		ori r19, 0b00000100
		jmp letter_to_byte

		length1:
		cpi r25, 1
		brne letter_to_byte
		ori r19, 0b00001000
		jmp letter_to_byte


	add_dot:
		;dot zero so just add count to blink count
		inc r25
		jmp letter_to_byte
; **********************************************
; **** END OF SECOND "STUDENT CODE" SECTION **** 
; **********************************************


; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================

delay_long:
	rcall delay
	rcall delay
	rcall delay
	ret

delay_short:
	rcall delay
	ret

; When wanting about a 1/5th of second delay, all other
; code must call this function
;
delay:
	rcall delay_busywait
	ret


; This function is ONLY called from "delay", and
; never directly from other code.
;
delay_busywait:
	push r16
	push r17
	push r18

	ldi r16, 0x08
delay_busywait_loop1:
	dec r16
	breq delay_busywait_exit
	
	ldi r17, 0xff
delay_busywait_loop2:
	dec	r17
	breq delay_busywait_loop1

	ldi r18, 0xff
delay_busywait_loop3:
	dec r18
	breq delay_busywait_loop2
	rjmp delay_busywait_loop3

delay_busywait_exit:
	pop r18
	pop r17
	pop r16
	ret


ITU_MORSE: .db "A", ".-", 0, 0, 0, 0, 0
	.db "B", "-...", 0, 0, 0
	.db "C", "-.-.", 0, 0, 0
	.db "D", "-..", 0, 0, 0, 0
	.db "E", ".", 0, 0, 0, 0, 0, 0
	.db "F", "..-.", 0, 0, 0
	.db "G", "--.", 0, 0, 0, 0
	.db "H", "....", 0, 0, 0
	.db "I", "..", 0, 0, 0, 0, 0
	.db "J", ".---", 0, 0, 0
	.db "K", "-.-", 0, 0, 0, 0
	.db "L", ".-..", 0, 0, 0
	.db "M", "--", 0, 0, 0, 0, 0
	.db "N", "-.", 0, 0, 0, 0, 0
	.db "O", "---", 0, 0, 0, 0
	.db "P", ".--.", 0, 0, 0
	.db "Q", "--.-", 0, 0, 0
	.db "R", ".-.", 0, 0, 0, 0
	.db "S", "...", 0, 0, 0, 0
	.db "T", "-", 0, 0, 0, 0, 0, 0
	.db "U", "..-", 0, 0, 0, 0
	.db "V", "...-", 0, 0, 0
	.db "W", ".--", 0, 0, 0, 0
	.db "X", "-..-", 0, 0, 0
	.db "Y", "-.--", 0, 0, 0
	.db "Z", "--..", 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0

MESSAGE01: .db "A A A", 0
MESSAGE02: .db "SOS", 0
MESSAGE03: .db "A BOX", 0
MESSAGE04: .db "DAIRY QUEEN", 0
MESSAGE05: .db "THE SHAPE OF WATER", 0, 0
MESSAGE06: .db "DEADPOOL AND WOLVERINE", 0, 0
MESSAGE07: .db "EVERYTHING EVERYWHERE ALL AT ONCE", 0
MESSAGE08: .db "O CANADA TERRE DE NOS AIEUX", 0
MESSAGE09: .db "HARD TO SWALLOW PILLS", 0

; First message ever sent by Morse code (in 1844)
MESSAGE10: .db "WHAT GOD HATH WROUGHT", 0


.dseg
BUFFER01: .byte 128
BUFFER02: .byte 128
TESTBUFFER: .byte 4

; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================
