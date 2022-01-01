include		windows.inc 
include		kernel32.inc 
include		user32.inc 
include     gdi32.inc  
include 	shell32.inc
include		winmm.inc
include		masm32.inc
include		msvcrt.inc
include		comctl32.inc
include		oleaut32.inc
include		ole32.inc
include		advapi32.inc
include		comdlg32.inc
include     /masm32/macros/macros.asm

includelib	kernel32.lib
includelib	user32.lib 
includelib 	gdi32.lib
includelib 	shell32.lib
includelib	winmm.lib
includelib 	masm32.lib
includelib	msvcrt.lib
includelib	comctl32.lib
includelib  oleaut32.lib
includelib  ole32.lib
includelib	advapi32.lib
includelib	comdlg32.lib

include	btnt.inc

include bassmod.inc
includelib bassmod.lib

KeygenProc		PROTO	:DWORD,:DWORD,:DWORD,:DWORD
FadeOut			PROTO	:DWORD
MakeDialogTransparent	PROTO	:DWORD,:DWORD

.const
PRFICON		equ	200
IDD_MAIN	equ	1000
IDD_ABOUTBOX	equ	2000
IDB_EXIT	equ	1001
IDC_BACKGROUND	equ	1002
IDC_SERIAL	equ	1003
IDB_GENERATE	equ	1004
IDB_ABOUT	equ	1005

.data
include hostlov.inc
WindowTitle		db	"kEYGENNED bY GRUiA",0
TxtFont		LOGFONT <18,8,0,0,FW_DONTCARE,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY, 0,"system">
r3kt			RECT		<>

DELAY_VALUE			equ		6
Transparency		dd		?
TRANSPARENT_VALUE	equ 254

.data?
hFont		dd	?
hFont2		dd	?
hIMG		dd	?
hBrush		dd	?
hSerial		dd	?
aWnd		dd	?
WndRect		RECT	<>
SerialRect	RECT	<>