GenKey 	PROTO	:DWORD
GenRandomNumbers	PROTO	:DWORD,:DWORD
Randomize		PROTO

.data
Rndm	dd	0
Charz	db	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",0

.data?
Serialbuffer    db  100 dup(?)
Rndpart      	db  100 dup(?)
Rndpart2      	db  100 dup(?)
Rndpart3      	db  100 dup(?)
Rndpart4      	db  100 dup(?)
NameLen         dd  ?

.code
Genkey proc xWnd:DWORD
	
	
	invoke lstrcat,addr Serialbuffer,chr$('3')
	invoke GenRandomNumbers,addr Rndpart,1
	invoke lstrcat,addr Serialbuffer,addr Rndpart
    invoke lstrcat,addr Serialbuffer,chr$('219')
    invoke GenRandomNumbers,addr Rndpart2,2
    invoke lstrcat,addr Serialbuffer,addr Rndpart2
    invoke lstrcat,addr Serialbuffer,chr$('05')
    invoke GenRandomNumbers,addr Rndpart3,1
    invoke lstrcat,addr Serialbuffer,addr Rndpart3
    invoke lstrcat,addr Serialbuffer,chr$('3')
    invoke GenRandomNumbers,addr Rndpart4,3
    invoke lstrcat,addr Serialbuffer,addr Rndpart4
    invoke SetDlgItemText,xWnd,IDC_SERIAL,addr Serialbuffer
    invoke RtlZeroMemory,addr Serialbuffer,sizeof Serialbuffer
	Ret
Genkey endp
GenRandomNumbers	Proc uses ebx	pIn:DWORD,pLen:DWORD
	mov edi,pIn
	mov ebx,pLen
	.repeat
		call Randomize
		mov ecx,36			; Change this number to a new Alphabet size if your gonna modify it
		xor edx,edx
		idiv ecx
		movzx eax,byte ptr [edx+Charz]
		stosb
		dec ebx
	.until zero?
	Ret
GenRandomNumbers endp

Randomize	Proc uses ecx
	invoke	GetTickCount
	add Rndm,eax
	add Rndm,eax
	add Rndm,'abcd'
	Rol Rndm,4
	mov eax,Rndm
;	imul eax,'seed'
	Ret
Randomize endp