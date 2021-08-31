DATA Segment; ���ݶ� 
;------------------------------���˵�-----------------------------------------------------------
    Menu00 db           "*****************************************************$"
    Menu01 db 0ah, 0dh, "*      Welcome to contact management system!!!      *$"
    Menu02 db 0ah, 0dh, "*****************************************************$"
    Menu03 db 0ah, 0dh, "*                                                   *$"
    Menu04 db 0ah, 0dh, "* Please enter the action by number:                *$"
    Menu05 db 0ah, 0dh, "*     1.Add a new contact                           *$"
    Menu06 db 0ah, 0dh, "*     2.Delete contact                              *$"
    Menu07 db 0ah, 0dh, "*     3.Modify contact                              *$"
    Menu08 db 0ah, 0dh, "*     4.Search contact                              *$"
    Menu09 db 0ah, 0dh, "*     5.Show Mumory distribution                    *$"
    Menu10 db 0ah, 0dh, "*     6.Show Information                            *$"
    Menu11 db 0ah, 0dh, "*     7.Count Infomation                            *$"
    Menu12 db 0ah, 0dh, "*     8.Exit                                        *$"
    Menu13 db 0ah, 0dh, "*                                                   *$"
    Menu14 db 0ah, 0dh, "*****************************************************$"
;-----------------------------------------------------------------------------------------------
	INPUT_BUFFER     db 20	;��������Ļ�����
		         db ?    
			 db 20 DUP(0)  
				 
	S_LEN     dw 0       ;��¼������Ϣ�ĳ���
		  dw ?
 		  dw 1 DUP(0)	
	
	N_ID    db 0
	ST_LEN  dd 0
	
	TEMP_CX dw 0
	TEMP_SI dw 0
	TEMP_DI dw 0
	ST_TEMP db 20
		db ?
		db 20 DUP(0)
		
	DIVISORS        DW 10000, 1000, 100, 10, 1
	RESULTS          DB 0,0,0,0,0,"$"        ;�����λ��ASCII��
	
	s_point db".",'$'	
	s_spcae db"  ",'$'
	
	INPUT_ERROR  db "Input Error,Please Input again !",'$'  ;������ʾ
	error_message    db    " ", '$'    ;����ʱ����ʾ
	file_success  db "file read Success !",'$'  ;������ʾ
		  
	handle  dw  0000                ;�����ļ���	
	path db '1.bin',0
;-----------------------����------------------------
	MENU_SEP db"---------------------------------------------------",'$'
	ADD_INF_NAME db "please input ADD NAME:",'$'
	ADD_INF_PHONE_NUM  db "please input ADD phone number:",'$'
	ADD_INF_SUCCESS  db "ADD Success !!! ",'$'
;-----------------------ɾ��------------------------	
	DEL_INF_SEL db "Please select Delete mode (INPUT by 1 or 2 or 3or 4)",'$'
	DEL_INF_ID  db "1.Input the ID delete the corresponding contact",'$'
	DEL_INF_INPUT db "Please Input the contact ID If you want to delete ",'$'
	DEL_INF_SUCCESS  db "Del ID sucess !",'$'
	DEL_INF_DEFAULT  db "Del ID defaulit ! Contact does not exist",'$'
	DEL_INF_ALL db "2.Delete All Information",'$'
	DEL_INF_ALL_SUCCESS db "Dangerous ! please increase the permission to use",'$'
	DEL_INF_RET db "3.RETURN MENU",'$' 
	DEL_INF_QUIT db "4.EXIT Process",'$' 
	NO_SEL_DEL db "Sorry ,No Information If you input",'$'
;-----------------------�޸�------------------------	
	MOD_INF_INPUT db "Please Input ID if you Modify",'$'
	MOD_INF_SEL db "Do you want to change your name or number�� select by 1 OR 2 ):",'$'
	MOD_INF_NAME db "Please input the name to be mod ",'$'
	MOD_INF_PHONENUM db "Please input the PhoneNumber to be mod ",'$'
	MOD_SUCESS db "Modify Success !",'$' 
	MOD_INF_QUIT db "4.EXIT Process",'$'  

;-----------------------��ѯ------------------------	
	SEARCH_INF_SEL db "Please select query mode:",'$'
	SEARCH_INf_NUM db "2.Query the mobile information according to the input name",'$'
	SEARCH_INF_NAME db "1.Query the mobile information according to the input num",'$'
	SEARCH_INF_RET db "3.RETURN MENU",'$' 
	SEARCH_INF_QUIT db "4.EXIT Process",'$' 
	Show_Msg db "This is all current contact information:",'$'
;----------------------------------------------------------   

;-------------------------�鿴�ڴ�-----
	show_mum db "This current mum:",'$'
	show_mum_1 db "U",'$'
	show_mum_0 db "F",'$'

;---------------------------ͳ��-----------
	Count_Sum db "total information:",'$'
	Count_CC db "At present, the number and proportion of each contact :",'$'
	Count_Number db "Occur Number:",'$'
	Count_Proportion db "proportion:",'$'
	
	nCountIndex dw 2431h
	nXiegang db "/",'$'
	nCountSum dw 2400 ;�ܴ���

;----------------------ѡ���˳��˵�----------------------
	SELECT_MSG db "Please proceed to the next step by inptut num:",'$'
	SELECT_QUIT1 db "1.RETURN MENU",'$' 
	SELECT_QUIT2 db "2.EXIT Process",'$' 
;------------------------------------------------------  
       
CRLF DB 0AH,0DH,'$' ;���س����

;------------------------------------------
DATA Ends    

;----------�������ݶ���������������Ϣ-----------
EXTRA SEGMENT 
	g_szbuffer DB 1024 DUP(0)	
EXTRA ends
;------------------
STACK SEGMENT STACK ;��ջ��
    dw 200 DUP(0)    ;��ջ����20�ֽڿռ�
STACK ENDS

CODE SEGMENT ;�����
    ASSUME CS:CODE,DS:DATA,SS:STACK,ES:EXTRA   ;αָ����߱����������

START:
    MOV AX,DATA
    MOV DS,AX     
    MOV AX,EXTRA
	MOV ES,AX
    call Main_start ;���õ�һ������    
EXIT:   
    MOV Ax,4C00H     ;�˳�������DOSϵͳ
    INT 21H
   
Main_start proc near
    mov ax, data
    mov ds, ax
	
    call clear_vga      ;����
	call read_file
    call Main_Menu    ;��ʾ���˵�
	call scanf_s; �����û�����
	
	; if (nNum == 1)	
	cmp INPUT_BUFFER+2,31h
	jnz nNum2
	; {
		; Information_increment();
		;call clear_vga      ;����
		call Inf_Add		;����
		jmp  sel_exit
	; }
	jmp Ex
	; else if (nNum == 2)
nNum2:
	cmp INPUT_BUFFER+2,32h
	jnz nNum3
	; {
		; Information_delete();
		call Inf_Del  ;ɾ��
		jmp  sel_exit
	; }
	jmp Ex
nNum3:
	cmp INPUT_BUFFER+2,33h
	jnz nNum4
		call Inf_Mod	;�޸�
nNum4:
	cmp INPUT_BUFFER+2,34h
	jnz nNum5
		call  INF_Search  ;��ѯ
		jmp  sel_exit
nNum5:
	cmp INPUT_BUFFER+2,35h
	jnz nNum6
		call Inf_Mum   ;��ʾ�ڴ�
		jmp  sel_exit
nNum6:
	cmp INPUT_BUFFER+2,36h
	jnz nNum7
		call Inf_Show   ;��ʾ����
		jmp  sel_exit
nNum7:
	cmp INPUT_BUFFER+2,37h
	jnz nNum8
		call Inf_Count   
		jmp  sel_exit
nNum8:
	;else if (nNum == 8)
	cmp INPUT_BUFFER+2,38h
	jnz PUT_ERROR
	; {
		; exit(0);
		jmp Exit
	; }
	; else
	; {

PUT_ERROR:
		; printf("�����������������\n");	
		;call clear_vga      ;����
		call printf_error
		; Sleep(1000);
		call delay
		; Main_start();		
		jmp Main_start		
	; }
	
Ex:	
	MOV Ax,4C00H     ;�˳�������DOSϵͳ
	INT 21H

Main_start endp 
;----------------INF_Add--------------------
INF_Add  proc near
	mov ax,EXTRA
	mov es,ax
	
	LEA DX,ADD_INF_NAME    ;������Ϣ����DX
	MOV AH,09H       ;���ܼ�������dx�Ļ�����    
	INT 21H	
	
	call wraps_around
	call scanf_s	
	
	call INF_Add_Name
;---------------------------------

	call wraps_around	
	LEA DX,ADD_INF_PHONE_NUM   ;������Ϣ����DX
	MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H
	
	call wraps_around
	call scanf_s	
	
;----���������ֻ��ŵ�g_szbuff----
	
	call INF_ADD_NUM
	
	call wraps_around
	mov DX,0
	mov AX,0
	LEA DX,ADD_INF_SUCCESS    ;������Ϣ����DX
	MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H
	
	call wraps_around	
	ret	
INF_Add endp  

;-------------��������--------------------
INF_ADD_NAME proc near
	mov ax,EXTRA
	mov es,ax
;----��������������g_szbuff----
	lea bx,INPUT_BUFFER+1
	lea Di,g_szbuffer
	
	mov cx,0
	mov cl,INPUT_BUFFER+1
	INC cx
	mov BP,S_LEN
	mov ES:[DI+BP],-1 ;���-1Ϊ��Ч����
cpname:
	mov Al,DS:[bx]
	mov ES:[Di+BP+1],Al
	INC DI
	INC BX
	Loop cpname
	
	;����ƫ�Ƶ�S_LEN
	mov ax,0
	mov al,INPUT_BUFFER+1
	ADD AX,3
	lea bx,S_LEN
	mov cx,S_LEN
	ADD AX,CX
	mov ds:[bx],AX	
	
	call write_file ;�����ļ�
	ret	
INF_ADD_NAME endp

;-------------�����ֻ���------------
INF_ADD_NUM proc near
	push ax
	push dx
	
	lea bx,INPUT_BUFFER+1
	lea Di,g_szbuffer
	
	mov cx,0
	mov cl,INPUT_BUFFER+1
	INC cx
	mov BP,S_LEN
	mov ES:[DI+BP],-2 ;���-2Ϊ��Ч�绰��
strnum:
	mov Al,DS:[bx]
	mov ES:[Di+BP+1],Al
	INC DI
	INC BX
	Loop strnum
	
	;����ƫ�Ƶ�S_LEN
	mov ax,0
	mov al,INPUT_BUFFER+1
	ADD AX,3
	lea bx,S_LEN
	mov cx,S_LEN
	ADD AX,CX
	mov ds:[bx],AX
	
	call write_file ;�����ļ�
	
	pop ax
	pop dx
	
	ret
INF_ADD_NUM endp

;---------------INF_DEL--------------------
INF_DEL proc near
	push dx
	push ax
		call wraps_around	
		call INF_Show
		call wraps_around	
		; printf("��������Ҫɾ������ϵ�˱�ţ�\n");
		call wraps_around	
		LEA DX,DEL_INF_INPUT  ;������Ϣ����DX
		MOV AH,09H       ;���ܼ�������dx�Ļ�����    
		INT 21H		
		;scanf_s("%d", &nNum);
		call wraps_around	
		call scanf_s

		call Del_SelName ;ɾ������
		Call Del_SelNum

		call wraps_around	
		;printf("��ϲ��ɾ���ɹ���\n");
		LEA DX,DEL_INF_SUCCESS  ;������Ϣ����DX
		MOV AH,09H       ;���ܼ�������dx�Ļ�����    
		INT 21H		
		call wraps_around	
		call INF_Show
		call wraps_around	
		call sel_exit

	pop ds
	pop ax
	ret
INF_DEL endp
;---------------�޸�-------------------------
INF_MOD proc near
	push dx
	push ax
	
	call wraps_around
	call INF_Show
	call wraps_around
	
	LEA DX,MOD_INF_INPUT    ;������Ϣ����DX
	MOV AH,09H       ;���ܼ�������dx�Ļ�����    
	INT 21H	
	call wraps_around
	call scanf_s
	call wraps_around
	
	call Del_SelName ;ɾ������
	call Del_SelNum
	
	;printf name
	LEA DX,MOD_INF_NAME  ;������Ϣ����DX
	MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H	
	
	call load_len
	
	call wraps_around
	call scanf_s
	call wraps_around
	call INF_ADD_NAME  
	
	;printf num
	LEA DX,MOD_INF_PHONENUM   ;������Ϣ����DX
	MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H	
	
	call wraps_around
	call scanf_s
	call wraps_around
	call INF_ADD_NUM
	
	LEA DX,MOD_SUCESS	;������Ϣ����DX
	MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H	
	
	call wraps_around
	call INF_Show
	call wraps_around
	call sel_exit
	
	pop dx
	pop ax
	ret
INF_MOD endp 

;----------------------del-name------------
Del_SelName proc near
	
	mov si,0
	mov cx,2431h
	;if(buf[i]=0 && buf[i+1]==FF)
start_del_name:
	cmp g_szbuffer[si],0
	jz next_del_name ;if(buf[i]==0)
		inc si
		jmp start_del_name
next_del_name:        
	cmp g_szbuffer[si+1],-1 ;if(buf[i]=='FF')
		jz del_name

	cmp g_szbuffer[si+1],0 ;if(buf[i]==0)	
		jz exit_search
		
		inc si					;û�� �ҵ�������
		jmp start_del_name
	
del_name:	
	cmp cl,INPUT_BUFFER+2
		jz is_del_name
	
		inc cl   				;cl++
		inc si					;û�� �ҵ�������
		jmp start_del_name	
is_del_name:
	mov g_szbuffer[si+1],-3 ;�ҵ�ɾ��������־��Ϊ-3, �˳�
	call write_file ;�����ļ�
	jmp exit_del_name
	
exit_del_name:
	ret	
	
Del_SelName endp

;----------------------del-num------------
Del_SelNum	proc near
	mov si,0
	mov cx,2431h
	;if(buf[i]=0 && buf[i+1]==FF)
start_del_num:
	cmp g_szbuffer[si],0
	jz next_del_num ;if(buf[i]==0)
		inc si
		jmp start_del_num
next_del_num:        
	cmp g_szbuffer[si+1],-2 ;if(buf[i]=='FF')
		jz del_num

	cmp g_szbuffer[si+1],0 ;if(buf[i]==0)	
		jz exit_search
		inc si					;û�� �ҵ�������
		jmp start_del_num
	
del_num:
	cmp cl,INPUT_BUFFER+2
		jz is_del_num
	
		inc cl   				;cl++
		inc si					;û�� �ҵ�������
		jmp start_del_num	
is_del_num:
	mov g_szbuffer[si+1],-4 ;�ҵ�ɾ��������־��Ϊ-3
	call write_file ;�����ļ�
	ret	
	
exit_del_num:
	LEA DX,NO_SEL_DEL   ;������Ϣ����DX
    MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H	
	
	jmp sel_exit
	ret
Del_SelNum endp
;---------------��ѯ-------------------------
INF_Search proc near
	
	LEA DX,SEARCH_INF_NAME   ;������Ϣ����DX
    MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H	
	call wraps_around
	LEA DX,SEARCH_INf_NUM  ;������Ϣ����DX
    MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H	
	call wraps_around
	
	LEA DX,SEARCH_INF_RET   ;������Ϣ����DX
    MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H	
	call wraps_around

	LEA DX,SEARCH_INF_QUIT   
    MOV AH,09H       
	INT 21H	
	call wraps_around
		
	call scanf_s
	call wraps_around
	
	ret
INF_Search endp 

;----------------ͳ��----------------
Inf_Count proc near
	; printf("��ǰ������ϵ���ܸ�����:%.0f\n",nCount);
	call wraps_around	
	LEA DX,Count_Sum   ;������Ϣ����DX
	MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H	
	call printf_space
	;-------------ͳ��----------------
	mov si,0
	mov ax,0
	;if(buf[i]=0 && buf[i+1]==FF)
start_count:
	cmp g_szbuffer[si],0
	jz next_count ;if(buf[i]==0)
		inc si
		jmp start_count
next_count:        
	cmp g_szbuffer[si+1],-1 ;if(buf[i]=='FF')
	jz count_find	

	cmp g_szbuffer[si+1],0 ;if(buf[i]==0)	
	jz exit_count
		inc si					;û���ҵ�������
		jmp start_count

count_find:
	inc ax
	inc si
	jmp start_count
	
exit_count:

	;prinf(%d,sax)
	lea bx,nCountSum
	ADD AX,2430h
	mov ds:[bx],ax
	;mov ax,nCountSum
	sub AX,2430h
	call Printf_AX_ID
	;-----------------------	
	; printf("��ǰÿ����ϵ�˳��ִ���������Ϊ:\n");
	call wraps_around
	LEA DX,Count_CC   ;������Ϣ����DX
	MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H	
	call wraps_around
	;------------------------
	
	; for (i = 0; i < 1000; i++)
	; {
		; nIndex = 1;
		; if ((g_szInf[i] == -1 && i == 0) || (g_szInf[i] == -1 && g_szInf[i - 1] == '\0'))					//�������飬��ӡ����λ������'\0'���ͷΪ-3�����ݣ�����������������
		; {
			; for (j = i+strlen(&g_szInf[i+1]); j < 1000; j++)							//����Ѱ���Ƿ���ڶ�γ��ֵ���ϵ��
			; {
				; if ((strcmp(&g_szInf[i + 1], &g_szInf[j])) == 0)						//ƥ��֮����ֵ������Ƿ����һ�γ��ֵ�һ��
				; {
					; g_szInf[j-1] = -3;																	//��ƥ�䵽���ֳ������ε��������޸ĵ�һ�γ��ֺ�������±꣬ʹ��ֻ��ӡһ��
					; nIndex++;
				; }
			; }
			; printf("����: %s ", &g_szInf[i + 1]);
			; printf("���ִ�����%.0f ", nIndex);
			; float ratio = ((nIndex / nCount) * 100);										//����ת����float������ٷֱ�
			; printf("���ֱ��� :%7.2f%%\n", ratio);
		; }
	; }
	;---------------------------------------------------------
	mov ax,0
	mov bx,0
	mov si,0
	mov cx,2430h
	;if(buf[i]=0 && buf[i]==FF)
start_search1:
	cmp g_szbuffer[si],0
	jz next_search1 ;if(buf[i]==0)
		inc si
		jmp start_search1
next_search1:      
	cmp g_szbuffer[si+1],-1 ;if(buf[i]=='FF')
	jz show_name1

	cmp g_szbuffer[si+1],0 ;if(buf[i]==0)	
	jz show_count_exit
	
	inc si
	jmp start_search1
show_name1:

	INC si
	;printf("name ")
	
	; LEA BX,TEMP_CX ;ȡ��ַ
	mov ds:[bx],CX
	
	mov cx,0
	mov cl,g_szbuffer[si+1]
;-----------��ӡ����,�����浽temp------------
	call printf_space	
	call strcpyname
	call printf_Inf	
;---------------------------
	call printf_space
	LEA DX,Count_Number
	MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H	

	LEA DX,nCountIndex
	MOV AH,09H       ;���ܼ�������dx�Ļ�����   
	INT 21H	
	
	call printf_space
	LEA DX,Count_Proportion
	MOV AH,09H       ;printf  :
	INT 21H	
	
	LEA DX,nCountIndex
	MOV AH,09H       ;printf index
	INT 21H	
	
	LEA DX,nXiegang
	MOV AH,09H       ;printf /
	INT 21H	
	
	;------showsum---
	LEA DX,nCountSum
	MOV AH,09H       ;prinf sum
	INT 21H	
	
	call wraps_around
;--------------------------------------

	jmp start_search1
	
show_count_exit:
	call wraps_around	
	ret
Inf_Count endp

;-----memcmp--------------

memcmp proc near

dest  = word ptr +6
src   = word ptr +8
count = word ptr +10

	push bp
	mov bp,sp
	push si
	push di
	
	mov si,[bp+src]
	mov di,[bp+dest]
	mov cx,[bp+count]
	cld
	repz cmpsb 
	cmp cx,0
	jne END_DIFF
	mov ax,0
	pop di
	pop si
	mov sp,bp
	pop bp
	retf

END_DIFF:
	
	mov ax,-1
	pop di
	pop si
	mov sp,bp
	pop bp
	retf
memcmp endp

;-------------- ��ʾȫ����ϵ����Ϣ-------------------------
INF_Show proc near
	LEA DX,Show_Msg
	MOV AH,09H         
	INT 21H	
	call wraps_around

	mov ax,0
	mov bx,0
	mov si,0
	mov di,1
	mov cx,2430h
	;if(buf[i]=0 && buf[i]==FF)
start_search:
	cmp g_szbuffer[si],0
	jz next_search ;if(buf[i]==0)
		inc si
		jmp start_search
next_search:        
	cmp g_szbuffer[si+1],-1 ;if(buf[i]=='FF')
	jz show_name
	cmp g_szbuffer[si+1],-2 ;if(buf[i]=='FF')	
	jz show_number
	cmp g_szbuffer[si+1],0 ;if(buf[i]==0)	
	jz exit_search
	
	inc si
	jmp start_search
show_name:
	;printf("1.name ")
	
	iNC CL
	LEA BX,s_len
	MOV ds:[bx],CX
	
	LEA DX,s_Len
	MOV AH,09H         
	INT 21H	

	LEA DX,s_point
	MOV AH,09H         
	INT 21H	
	INC Si	
	;printf("name ")
	
	;������ʱcl
	LEA BX,TEMP_CX ;ȡ��ַ
	mov ds:[bx],CX
	mov cx,0
	mov cl,g_szbuffer[si+1]
;-----------------------
	call strcpyname
	call printf_Inf	
;---------------------------
	mov CX,TEMP_CX ;�ָ�ѭ��
	
	jmp start_search
	
show_number:
	call printf_space

;--------������ʱcl
	LEA BX,TEMP_CX ;
	mov ds:[bx],CX
;--------------

	;�����ַ�buf[si]+1]����temp��+��$ ��ӡtemp
	mov cx,0
	mov cl,g_szbuffer[si+2]
;-------�����ַ��� cl+1��--
	call strcpynum
	call printf_Inf	
	mov CX,TEMP_CX ;�ָ�ѭ��
		
	call wraps_around
	INC Si
	jmp start_search
exit_search:
	ret
	
INF_Show endp 

;-------�����ַ�����temp--
strcpyname proc near
	push cx
	
	inc cl	
	lea bx,g_szbuffer[si+1] 
	lea Di,ST_TEMP
	
strcpna:
	mov Al,ES:[bx]
	mov DS:[Di],Al
	INC DI
	INC BX
	loop strcpna
	
	pop cx
	ret
strcpyname endp

;-------�������뵽temp--
strcpynum proc near
	push cx

	inc cl	
	lea bx,g_szbuffer[si+2] 
	lea Di,ST_TEMP
	
strcpnu:
	mov Al,ES:[bx]
	mov DS:[Di],Al
	INC DI
	INC BX
	loop strcpnu
	
	pop cx
	ret
strcpynum endp
;-------------------------	

;��������
clear_vga proc near
	push ds
	push ax
	push es
    
	mov ax, 0b800h
	mov es, ax
	mov bx, 0
	mov cx, 2000
blank:
	mov byte ptr es:[bx], ' '
	mov byte ptr es:[bx+1], 07h
	add bx, 2
	loop blank
	pop es
	pop ax
	pop ds

	ret
clear_vga endp

;-------��ӡ�ո�--------------
printf_space proc near
	LEA DX,s_spcae   	
	MOV AH,09H       
	INT 21H
	
	ret
printf_space endp
;-------------------------------------
;�����û������ַ�����INPUT_BUFFER
scanf_s proc near
	LEA DX,INPUT_BUFFER
	;������Ϣ����DX
	
	MOV AH,0AH       ;���ܼ�������dx�Ļ�����    
	INT 21H
	
	ret
scanf_s  endp  
;---------------------------

;----------------��ʾ�ڴ�ֲ�------------------
Inf_Mum proc near
	LEA DX,show_mum
	MOV AH,09H       
	INT 21H
	
	call wraps_around
	mov si,0
	mov cx,512
	
Lshow_mum:
	cmp  g_szbuffer[si],0
		jz Show_0
		jmp Show_1
Show_1:	
	LEA DX,show_mum_1
	MOV AH,09H    
	INT 21H	
	inc si
	jmp show_mum_exit
	
Show_0:
	LEA DX,show_mum_0
	MOV AH,09H    
	INT 21H
	inc si

show_mum_exit:	
	loop Lshow_mum
	
	call wraps_around
	ret
Inf_Mum endp

;---------------------------------------------

;---------------��ӡtemp���ַ���---
printf_Inf proc near
	mov AX,0
    
	MOV AL,ST_TEMP  ;ȡBUFFER���� 
	ADD AL,1         ;AL�����ַ����������ַ�����Ҫ��AL+1��ʼ
	MOV AH,0
	MOV DI,AX
    
	MOV	ST_TEMP[DI],'$' ;�����ַ�������$
	
	LEA DX,ST_TEMP+1    ;��ӡ
	MOV AH,09H
	INT 21H
	
;----��ӡ�����---
	DEC DX
	mov BX,DX
	mov cx,20
	
STT_DEL:
	mov ds:[bx],0
	inc bx
	loop STT_DEL
	
	ret
printf_Inf endp
;---------------------------
;��ӡ�������
printf_error  proc near

	LEA DX,INPUT_ERROR    ;��ӡ����
	MOV AH,09H
	INT 21H
	
	ret
printf_error endp
;----------------------------------------------------------
;��ʱ 1s
delay proc near
	push bx
	push cx
	mov bx,400h
for1:
	mov cx,0ffffh
for2:
	loop for2
	dec bx
	jnz for1
	pop cx
	pop bx
	ret
 delay endp
 ;----------����--------
wraps_around proc near
 	push dx
	push ax
		
	LEA DX,CRLF      ;��껻��
	MOV AH,09H       ;����DOS
	INT 21H
	
	pop dx
	pop ax
	ret
wraps_around endp
 ;----------------------
 
;----------ѡ���˳�����--------
Sel_Exit proc near

	call wraps_around
	call wraps_around
	
	LEA DX,SELECT_MSG
	MOV AH,09H
	INT 21H	
	
	call wraps_around
	LEA DX,SELECT_QUIT1    ;��ӡ1
	MOV AH,09H
	INT 21H	
	call wraps_around
	
	LEA DX,SELECT_QUIT2      ;2
	MOV AH,09H       ;����DOS
	INT 21H
	call wraps_around
	; scanf_s("%d", &nNum);
	call scanf_s
	; if (nNum == 1) {												//����1�������˵�
	cmp INPUT_BUFFER+2,31h
	jnz SelQUIT_Num2
		; Main_start();
		call Main_start
	; }
SelQUIT_Num2:
	; else if (nNum == 2) {										//����2�˳�
	cmp INPUT_BUFFER+2,32h
	jnz SelQUIT_ERROR
		; exit(0);	
		jmp Exit
	; }
	; else
	; {
SelQUIT_ERROR:
	call wraps_around
	; printf("�����������������:\n");				//�����������ֱ�����������
	call printf_error
	; Select_exit();
	call wraps_around
	
	jmp Sel_Exit
	; }	

	ret
Sel_Exit endp
 
;----------------------------------------------------------
;��ʾ���˵�
Main_Menu proc near
	push ax
	push cx
	push si
	push es
	push di
	mov ax, data
	mov ds, ax
	call clear_vga
	mov cx, 15 ;��������
	mov ax, 0b81fh
	mov es, ax
	mov bx, offset 00
row1:
	push cx

	mov cx, 53  ;����
	mov si, 0h
color:
	mov al, [bx]
	mov es:[si], al
    cmp al, 2ah ;*�Ŵ�ӡ��ɫ?
je colorA
	jmp colorB ;�ַ���ӡ��ɫ
colorA:
	mov dl, 00001100b
	jmp _color
colorB:
	mov dl, 00001011b
	jmp _color

_color:
	mov ah, dl
	mov es:[si+1], ah
	inc bx
	add si, 2
	loop color
	pop cx

	mov ax, es
	add ax, 0ah
	mov es, ax
	add bx, 3
	
loop row1
	pop di
	pop es
	pop si
	pop cx
	pop ax
	ret
Main_Menu endp
;-----------------------------------------------------------------

;--���ļ�-----------------
read_file proc near

	mov dx , offset path		;dx��ȡfile��ƫ�Ƶ�ַ
	mov al , 0				
	mov ah , 3dh				
	int 21h                  ;���ļ���ֻ��
	jc read_error                  ;���򿪳���תerror
	mov handle,ax           ;�����ļ����
	mov bx,ax				;�ļ����
	mov cx,1024	
	mov ax,extra			;��ȡg_buf��ƫ�Ƶ�ַ
	mov dx,0
	mov ds,ax
	mov ah,3fh				
	int 21h                  ;���ļ��ж�255�ֽڡ�buf
	
	jc read_error                  ;��������תerror

	call close_file
	
	mov ax,data
	mov ds,ax
	

	jnc read_end            ;���رչ����޴�ת��end1������dos
read_error:
	mov dx , offset error_message		;��ȡerror_message��ƫ�Ƶ�ַ
	mov ah , 9						
	int 21h                            ;��ʾerror_message
	
read_end:

	call load_len
	
	mov si,0
	mov di,0
	
	mov ax,extra;�ָ�ds,es
	mov es,ax
	mov ax,data
	mov ds,ax

	ret
read_file endp

;-----�ر��ļ�----
close_file proc near
	
	mov ax,extra;�ָ�ds,es
	mov es,ax
	mov ax,data
	mov ds,ax
	
	mov bx,handle			   ;�ļ����
	mov ah,3eh						
	int 21h                            ;�ر��ļ�
	
	ret
close_file endp
;--------------------
   
;------------load_len-------------------
load_len proc near
	mov ax,extra;�ָ�ds,es
	mov es,ax
	mov ax,data
	mov ds,ax
	;���泤�ȵ�s_len if(buff[i]==0 && buff[i+1]==0 )
	mov si,0
	mov di,0
	
next:
	cmp g_szbuffer[si],0
	jz i_0
	inc si
	jmp next
i_0:;g_szbuffer[i]==0	
	cmp g_szbuffer[si+1],0
	jz i_1
	inc si
	jmp next
i_1:;g_szbuffer[i+1]==0	
	mov ax,data
	mov ds,ax
	lea bx,s_len
	add si,1
	mov ds:[bx],si

	ret
load_len endp

;------����Ĵ���AX����----------------
  
Printf_AX_ID proc near
	PUSH SI
	PUSH DI
	PUSH DX
	PUSH CX
    
	MOV SI, OFFSET DIVISORS
	MOV DI, OFFSET RESULTS                    
	MOV CX,5 
	
PRINTF_AX:
	MOV DX,0           
	DIV WORD PTR [SI]   ;����ָ��ı��������������������˴�ΪDX:AX����AX,����DX
	ADD AL,48           ;�̼���48���ɵõ���Ӧ���ֵ�ASCII��
	MOV BYTE PTR [DI],AL       
	INC DI                               
	ADD SI,2                          
	MOV AX,DX                       
	LOOP PRINTF_AX  
			
	MOV DI, OFFSET RESULTS 
IF_0: 
	CMP  BYTE PTR [DI],'0'   ;�����ǰ���0�ַ�   
	JNE  PRINT
	INC  DI                          
	LOOP IF_0 

PRINT:    
	MOV DX,DI
	MOV AH,09H
	INT 21H
	
	POP SI
	POP DI
	POP DX
	POP CX
Printf_AX_ID endp


;---д�ļ�--------------
write_file proc near

	mov dx,offset path
	mov	cx,0
	mov	ah,3cH
	int 21h               ;�����ļ�����������ԭ�д��ļ����򸲸�
	jc write_error               ;��������תerror��
	
	mov handle , ax         ;�����ļ���
	mov bx,ax
	mov cx,1024
	mov ax,es
	mov ds,ax
	mov dx,0
	mov ah,40h
	int 21h                      ;���ļ���д��cx���ֽ�����
	jc write_error                          ;д����תerror��
	jmp end_write
write_error:
    mov dx , offset error_message
    mov ah , 9
    int 21h                              ;��ʾ������ʾ`

end_write:
	mov ax,extra;�ָ�ds,es
	mov es,ax
	mov ax,data
	mov ds,ax
	ret
write_file endp
;---------------------

CODE ENDS
END START