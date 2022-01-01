.686
.model	flat, stdcall
option	casemap :none

include	resID.inc
include	textscr_mod.asm
include meatballs_bY_newborn.asm
include algo.asm
AllowSingleInstance MACRO lpTitle
        invoke FindWindow,NULL,lpTitle
        cmp eax, 0
        je @F
          push eax
          invoke ShowWindow,eax,SW_RESTORE
          pop eax
          invoke SetForegroundWindow,eax
          mov eax, 0
          ret
        @@:
      ENDM
      
.code
start:
	
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	InitCommonControls
	AllowSingleInstance addr WindowTitle
	invoke	DialogBoxParam, hInstance, IDD_MAIN, 0, offset KeygenProc, 0
	invoke	ExitProcess, eax

KeygenProc proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	LOCAL ps:PAINTSTRUCT
	mov	eax,uMsg
	
	.if	eax == WM_INITDIALOG
		push hWnd
		pop aWnd
		invoke	LoadIcon,hInstance,PRFICON
		invoke	SendMessage, aWnd, WM_SETICON, 1, eax
		invoke  SetWindowText, aWnd, addr WindowTitle
		invoke BASSMOD_DllMain, hInstance, DLL_PROCESS_ATTACH,NULL
		invoke BASSMOD_Init, 0, 44100, 0
		invoke BASSMOD_MusicLoad, TRUE, addr xm, 0, 0, BASS_MUSIC_LOOP OR BASS_MUSIC_RAMPS; OR BASS_MUSIC_NONINTER
		invoke BASSMOD_MusicPlay
		invoke LoadBitmap,hInstance,IDC_BACKGROUND
		mov hIMG,eax
		invoke CreatePatternBrush,hIMG
		mov hBrush,eax
		invoke CreateFontIndirect,addr TxtFont
		mov hFont,eax
		invoke GetDlgItem,aWnd,IDC_SERIAL
		mov hSerial,eax
		invoke SendMessage,eax,WM_SETFONT,hFont,1
		invoke ImageButton,aWnd,14,188,500,502,501,IDB_GENERATE
		mov hGen,eax
		invoke ImageButton,aWnd,116,188,600,602,601,IDB_ABOUT
		mov hAbout,eax
		invoke ImageButton,aWnd,216,188,700,702,701,IDB_EXIT
		mov hExit,eax
		invoke ScrollerInit,aWnd
	.elseif eax == WM_CTLCOLORDLG
		return hBrush
	
	.elseif eax == WM_PAINT
		invoke BeginPaint,aWnd,addr ps
		mov edi,eax
		lea ebx,r3kt
		assume ebx:ptr RECT
	
		invoke GetClientRect,aWnd,ebx
		invoke CreateSolidBrush,0
		invoke FrameRect,edi,ebx,eax
		invoke EndPaint,aWnd,addr ps
	.elseif eax == WM_CTLCOLORSTATIC
		invoke SetBkMode,wParam,TRANSPARENT
		invoke SetTextColor,wParam,White
		invoke GetWindowRect,aWnd,addr WndRect
		invoke GetDlgItem,aWnd,IDC_SERIAL
		invoke GetWindowRect,eax,addr SerialRect
		mov edi,WndRect.left
		mov esi,SerialRect.left
		sub edi,esi
		mov ebx,WndRect.top
		mov edx,SerialRect.top
		sub ebx,edx
		invoke SetBrushOrgEx,wParam,edi,ebx,0
		mov eax,hBrush
		ret
	.elseif eax == WM_LBUTTONDOWN							
		invoke SendMessage,aWnd,WM_NCLBUTTONDOWN,HTCAPTION,lParam
	.elseif eax == WM_COMMAND
		mov	eax,wParam
		.if eax == IDB_GENERATE
			invoke Genkey,aWnd
		.elseif eax == IDB_ABOUT
			invoke ShowWindow,aWnd,0
			invoke DialogBoxParam,0,IDD_ABOUTBOX,aWnd,addr AboutProc,0
		.elseif	eax == IDB_EXIT
			invoke	SendMessage, aWnd, WM_CLOSE, 0, 0
		.endif
	.elseif	eax == WM_CLOSE
		invoke BASSMOD_Free
		invoke BASSMOD_DllMain, hInstance, DLL_PROCESS_DETACH, NULL
		invoke	EndDialog, aWnd, 0
	.endif

	xor	eax,eax
	ret
KeygenProc endp

FadeOut proc hWnd:HWND
	mov Transparency,250
@@:
	invoke SetLayeredWindowAttributes,hWnd,0,Transparency,LWA_ALPHA
	invoke Sleep,DELAY_VALUE
	sub Transparency,5
	cmp Transparency,0
	jne @b
	ret
FadeOut endp

MakeDialogTransparent proc _handle:dword,_transvalue:dword
	
	pushad
	invoke GetModuleHandle,chr$("user32.dll")
	invoke GetProcAddress,eax,chr$("SetLayeredWindowAttributes")
	.if eax!=0
		invoke GetWindowLong,_handle,GWL_EXSTYLE	;get EXSTYLE
		
		.if _transvalue==255
			xor eax,WS_EX_LAYERED	;remove WS_EX_LAYERED
		.else
			or eax,WS_EX_LAYERED	;eax = oldstlye + new style(WS_EX_LAYERED)
		.endif
		
		invoke SetWindowLong,_handle,GWL_EXSTYLE,eax
		
		.if _transvalue<255
			invoke SetLayeredWindowAttributes,_handle,0,_transvalue,LWA_ALPHA
		.endif	
	.endif
	popad
	ret
MakeDialogTransparent endp

end start