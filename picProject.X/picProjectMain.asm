opt	equ	01h
pcl	equ	02h
status	equ	03h
portb	equ	06h
trisb	equ	86h
	
c	equ	0h
rp0	equ	5h

btn	equ	1h
rbpu	equ	7h

dat	equ	4h
syn	equ	5h

x	equ	0Ch
ctr1	equ	0Dh
ctr2	equ	0Eh
w1	equ	0Fh
w2	equ	10h
w3	equ	11h
n       equ     12h
xn      equ     13h



	org	0h
	goto	start
	org	4h
	retfie


display
	movlw	d'4'
	movwf	ctr1

	movf	x,0
	movwf	w1


cl1
	movlw	d'10'
	call	div
	call	encode
	call	out
	decfsz	ctr1,1
        goto	cl1
	return

div
	movwf	w2
	movf	w1,0
        movwf	w3
	clrf	w1
	movf	w2,0

cl2
	incf	w1,1
	subwf	w3,1
	btfsc	status,c
	goto	cl2
	decf	w1,1
        addwf	w3,0
	return

	
encode
	addwf	pcl,1                 
	retlw	b'00000011'  
	retlw	b'10011111'  
	retlw	b'00100101'  
	retlw	b'00001101'  
	retlw	b'10011001'  
	retlw	b'01001001'
	retlw	b'01000001'
	retlw	b'00011111'
	retlw	b'00000001'
	retlw	b'00001001'
	
	
dat	equ	4h
syn	equ	5h
	
	
out
	movwf	w2         
	movlw	d'8'       
	movwf	ctr2	   

c13
	bsf	portb,dat        
	btfss	w2,0 
	bcf	portb,dat      
	bcf	portb,syn
	bsf	portb,syn
	rrf	w2,1		
	decfsz	ctr2,1		
        goto    c13      
	return
	
pause
	movlw	d'255'
	movfw	ctr1
ps1
	clrf	ctr2
	call	btnchk
ps2
	decfsz	ctr2,1
	goto	ps2
	decfsz	ctr1,1
	goto	ps1
	return

dreb
	movlw	d'30'
	movfw	ctr1
dr1
	clrf	ctr2
dr2
	decfsz	ctr2,1
	goto	dr2
	decfsz	ctr1,1
	goto	dr1
	return

btnchk
	btfsc	portb,btn
	return
	call	dreb
btn0
	btfss	portb,btn
	goto	btn0
	call	dreb
btn1
	btfsc	portb,btn	
	goto	btn1
	call	dreb
btn2	
	btfss	portb,btn
	goto	btn2
	call	dreb
	return
	
	
start
	bsf	status,rp0   
	movlw	b'11001111'  
	movwf	trisb        
	bcf	opt,7
	bcf	status,rp0 
m00
	clrf	n
	movlw	b'00000001'
	movwf	xn
	bcf	status, 0
	clrf	x
	
m01
	movf	n, 0
	subwf	xn, 0
	btfss	status, 0
	goto 	m00
	movwf	x
	

c10
	call	display
	call	pause
	call	pause
	bcf	status, 0
	rlf	xn, 1
	btfsc	status, 0
	goto	m00
	incf	n, 1
	goto	m01
	
	end	
	