DATA Segment; 数据段 
;------------------------------主菜单-----------------------------------------------------------
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
	INPUT_BUFFER     db 20	;接收输入的缓冲区
		         db ?    
			 db 20 DUP(0)  
				 
	S_LEN     dw 0       ;记录保存信息的长度
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
	RESULTS          DB 0,0,0,0,0,"$"        ;存放五位数ASCII码
	
	s_point db".",'$'	
	s_spcae db"  ",'$'
	
	INPUT_ERROR  db "Input Error,Please Input again !",'$'  ;错误提示
	error_message    db    " ", '$'    ;出错时的提示
	file_success  db "file read Success !",'$'  ;错误提示
		  
	handle  dw  0000                ;保存文件号	
	path db '1.bin',0
;-----------------------增加------------------------
	MENU_SEP db"---------------------------------------------------",'$'
	ADD_INF_NAME db "please input ADD NAME:",'$'
	ADD_INF_PHONE_NUM  db "please input ADD phone number:",'$'
	ADD_INF_SUCCESS  db "ADD Success !!! ",'$'
;-----------------------删除------------------------	
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
;-----------------------修改------------------------	
	MOD_INF_INPUT db "Please Input ID if you Modify",'$'
	MOD_INF_SEL db "Do you want to change your name or number（ select by 1 OR 2 ):",'$'
	MOD_INF_NAME db "Please input the name to be mod ",'$'
	MOD_INF_PHONENUM db "Please input the PhoneNumber to be mod ",'$'
	MOD_SUCESS db "Modify Success !",'$' 
	MOD_INF_QUIT db "4.EXIT Process",'$'  

;-----------------------查询------------------------	
	SEARCH_INF_SEL db "Please select query mode:",'$'
	SEARCH_INf_NUM db "2.Query the mobile information according to the input name",'$'
	SEARCH_INF_NAME db "1.Query the mobile information according to the input num",'$'
	SEARCH_INF_RET db "3.RETURN MENU",'$' 
	SEARCH_INF_QUIT db "4.EXIT Process",'$' 
	Show_Msg db "This is all current contact information:",'$'
;----------------------------------------------------------   

;-------------------------查看内存-----
	show_mum db "This current mum:",'$'
	show_mum_1 db "U",'$'
	show_mum_0 db "F",'$'

;---------------------------统计-----------
	Count_Sum db "total information:",'$'
	Count_CC db "At present, the number and proportion of each contact :",'$'
	Count_Number db "Occur Number:",'$'
	Count_Proportion db "proportion:",'$'
	
	nCountIndex dw 2431h
	nXiegang db "/",'$'
	nCountSum dw 2400 ;总次数

;----------------------选择退出菜单----------------------
	SELECT_MSG db "Please proceed to the next step by inptut num:",'$'
	SELECT_QUIT1 db "1.RETURN MENU",'$' 
	SELECT_QUIT2 db "2.EXIT Process",'$' 
;------------------------------------------------------  
       
CRLF DB 0AH,0DH,'$' ;按回车输出

;------------------------------------------
DATA Ends    

;----------额外数据段用来保存所有信息-----------
EXTRA SEGMENT 
	g_szbuffer DB 1024 DUP(0)	
EXTRA ends
;------------------
STACK SEGMENT STACK ;堆栈段
    dw 200 DUP(0)    ;堆栈开辟20字节空间
STACK ENDS

CODE SEGMENT ;代码段
    ASSUME CS:CODE,DS:DATA,SS:STACK,ES:EXTRA   ;伪指令、告诉编译器如何找

START:
    MOV AX,DATA
    MOV DS,AX     
    MOV AX,EXTRA
	MOV ES,AX
    call Main_start ;调用第一个函数    
EXIT:   
    MOV Ax,4C00H     ;退出、返回DOS系统
    INT 21H
   
Main_start proc near
    mov ax, data
    mov ds, ax
	
    call clear_vga      ;清屏
	call read_file
    call Main_Menu    ;显示主菜单
	call scanf_s; 接受用户输入
	
	; if (nNum == 1)	
	cmp INPUT_BUFFER+2,31h
	jnz nNum2
	; {
		; Information_increment();
		;call clear_vga      ;清屏
		call Inf_Add		;增加
		jmp  sel_exit
	; }
	jmp Ex
	; else if (nNum == 2)
nNum2:
	cmp INPUT_BUFFER+2,32h
	jnz nNum3
	; {
		; Information_delete();
		call Inf_Del  ;删除
		jmp  sel_exit
	; }
	jmp Ex
nNum3:
	cmp INPUT_BUFFER+2,33h
	jnz nNum4
		call Inf_Mod	;修改
nNum4:
	cmp INPUT_BUFFER+2,34h
	jnz nNum5
		call  INF_Search  ;查询
		jmp  sel_exit
nNum5:
	cmp INPUT_BUFFER+2,35h
	jnz nNum6
		call Inf_Mum   ;显示内存
		jmp  sel_exit
nNum6:
	cmp INPUT_BUFFER+2,36h
	jnz nNum7
		call Inf_Show   ;显示所有
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
		; printf("输出错误，请重新输入\n");	
		;call clear_vga      ;清屏
		call printf_error
		; Sleep(1000);
		call delay
		; Main_start();		
		jmp Main_start		
	; }
	
Ex:	
	MOV Ax,4C00H     ;退出、返回DOS系统
	INT 21H

Main_start endp 
;----------------INF_Add--------------------
INF_Add  proc near
	mov ax,EXTRA
	mov es,ax
	
	LEA DX,ADD_INF_NAME    ;输入信息放入DX
	MOV AH,09H       ;接受键盘输入dx的缓冲器    
	INT 21H	
	
	call wraps_around
	call scanf_s	
	
	call INF_Add_Name
;---------------------------------

	call wraps_around	
	LEA DX,ADD_INF_PHONE_NUM   ;输入信息放入DX
	MOV AH,09H       ;接受键盘输入dx的缓冲器   
	INT 21H
	
	call wraps_around
	call scanf_s	
	
;----保存输入手机号到g_szbuff----
	
	call INF_ADD_NUM
	
	call wraps_around
	mov DX,0
	mov AX,0
	LEA DX,ADD_INF_SUCCESS    ;输入信息放入DX
	MOV AH,09H       ;接受键盘输入dx的缓冲器   
	INT 21H
	
	call wraps_around	
	ret	
INF_Add endp  

;-------------增加姓名--------------------
INF_ADD_NAME proc near
	mov ax,EXTRA
	mov es,ax
;----保存输入姓名到g_szbuff----
	lea bx,INPUT_BUFFER+1
	lea Di,g_szbuffer
	
	mov cx,0
	mov cl,INPUT_BUFFER+1
	INC cx
	mov BP,S_LEN
	mov ES:[DI+BP],-1 ;标记-1为有效姓名
cpname:
	mov Al,DS:[bx]
	mov ES:[Di+BP+1],Al
	INC DI
	INC BX
	Loop cpname
	
	;保存偏移到S_LEN
	mov ax,0
	mov al,INPUT_BUFFER+1
	ADD AX,3
	lea bx,S_LEN
	mov cx,S_LEN
	ADD AX,CX
	mov ds:[bx],AX	
	
	call write_file ;保存文件
	ret	
INF_ADD_NAME endp

;-------------输入手机号------------
INF_ADD_NUM proc near
	push ax
	push dx
	
	lea bx,INPUT_BUFFER+1
	lea Di,g_szbuffer
	
	mov cx,0
	mov cl,INPUT_BUFFER+1
	INC cx
	mov BP,S_LEN
	mov ES:[DI+BP],-2 ;标记-2为有效电话号
strnum:
	mov Al,DS:[bx]
	mov ES:[Di+BP+1],Al
	INC DI
	INC BX
	Loop strnum
	
	;保存偏移到S_LEN
	mov ax,0
	mov al,INPUT_BUFFER+1
	ADD AX,3
	lea bx,S_LEN
	mov cx,S_LEN
	ADD AX,CX
	mov ds:[bx],AX
	
	call write_file ;保存文件
	
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
		; printf("请输入您要删除的联系人编号：\n");
		call wraps_around	
		LEA DX,DEL_INF_INPUT  ;输入信息放入DX
		MOV AH,09H       ;接受键盘输入dx的缓冲器    
		INT 21H		
		;scanf_s("%d", &nNum);
		call wraps_around	
		call scanf_s

		call Del_SelName ;删除姓名
		Call Del_SelNum

		call wraps_around	
		;printf("恭喜，删除成功！\n");
		LEA DX,DEL_INF_SUCCESS  ;输入信息放入DX
		MOV AH,09H       ;接受键盘输入dx的缓冲器    
		INT 21H		
		call wraps_around	
		call INF_Show
		call wraps_around	
		call sel_exit

	pop ds
	pop ax
	ret
INF_DEL endp
;---------------修改-------------------------
INF_MOD proc near
	push dx
	push ax
	
	call wraps_around
	call INF_Show
	call wraps_around
	
	LEA DX,MOD_INF_INPUT    ;输入信息放入DX
	MOV AH,09H       ;接受键盘输入dx的缓冲器    
	INT 21H	
	call wraps_around
	call scanf_s
	call wraps_around
	
	call Del_SelName ;删除姓名
	call Del_SelNum
	
	;printf name
	LEA DX,MOD_INF_NAME  ;输入信息放入DX
	MOV AH,09H       ;接受键盘输入dx的缓冲器   
	INT 21H	
	
	call load_len
	
	call wraps_around
	call scanf_s
	call wraps_around
	call INF_ADD_NAME  
	
	;printf num
	LEA DX,MOD_INF_PHONENUM   ;输入信息放入DX
	MOV AH,09H       ;接受键盘输入dx的缓冲器   
	INT 21H	
	
	call wraps_around
	call scanf_s
	call wraps_around
	call INF_ADD_NUM
	
	LEA DX,MOD_SUCESS	;输入信息放入DX
	MOV AH,09H       ;接受键盘输入dx的缓冲器   
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
		
		inc si					;没有 找到继续找
		jmp start_del_name
	
del_name:	
	cmp cl,INPUT_BUFFER+2
		jz is_del_name
	
		inc cl   				;cl++
		inc si					;没有 找到继续找
		jmp start_del_name	
is_del_name:
	mov g_szbuffer[si+1],-3 ;找到删除串，标志设为-3, 退出
	call write_file ;保存文件
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
		inc si					;没有 找到继续找
		jmp start_del_num
	
del_num:
	cmp cl,INPUT_BUFFER+2
		jz is_del_num
	
		inc cl   				;cl++
		inc si					;没有 找到继续找
		jmp start_del_num	
is_del_num:
	mov g_szbuffer[si+1],-4 ;找到删除串，标志设为-3
	call write_file ;保存文件
	ret	
	
exit_del_num:
	LEA DX,NO_SEL_DEL   ;输入信息放入DX
    MOV AH,09H       ;接受键盘输入dx的缓冲器   
	INT 21H	
	
	jmp sel_exit
	ret
Del_SelNum endp
;---------------查询-------------------------
INF_Search proc near
	
	LEA DX,SEARCH_INF_NAME   ;输入信息放入DX
    MOV AH,09H       ;接受键盘输入dx的缓冲器   
	INT 21H	
	call wraps_around
	LEA DX,SEARCH_INf_NUM  ;输入信息放入DX
    MOV AH,09H       ;接受键盘输入dx的缓冲器   
	INT 21H	
	call wraps_around
	
	LEA DX,SEARCH_INF_RET   ;输入信息放入DX
    MOV AH,09H       ;接受键盘输入dx的缓冲器   
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

;----------------统计----------------
Inf_Count proc near
	; printf("当前所有联系人总个数是:%.0f\n",nCount);
	call wraps_around	
	LEA DX,Count_Sum   ;输入信息放入DX
	MOV AH,09H       ;接受键盘输入dx的缓冲器   
	INT 21H	
	call printf_space
	;-------------统计----------------
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
		inc si					;没有找到继续找
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
	; printf("当前每个联系人出现次数及比例为:\n");
	call wraps_around
	LEA DX,Count_CC   ;输入信息放入DX
	MOV AH,09H       ;接受键盘输入dx的缓冲器   
	INT 21H	
	call wraps_around
	;------------------------
	
	; for (i = 0; i < 1000; i++)
	; {
		; nIndex = 1;
		; if ((g_szInf[i] == -1 && i == 0) || (g_szInf[i] == -1 && g_szInf[i - 1] == '\0'))					//遍历数组，打印出首位和所有'\0'后标头为-3的数据，即保存姓名的数据
		; {
			; for (j = i+strlen(&g_szInf[i+1]); j < 1000; j++)							//遍历寻找是否存在多次出现的联系人
			; {
				; if ((strcmp(&g_szInf[i + 1], &g_szInf[j])) == 0)						//匹配之后出现的姓名是否与第一次出现的一样
				; {
					; g_szInf[j-1] = -3;																	//若匹配到出现超过两次的姓名就修改第一次出现后的数据下标，使其只打印一次
					; nIndex++;
				; }
			; }
			; printf("姓名: %s ", &g_szInf[i + 1]);
			; printf("出现次数：%.0f ", nIndex);
			; float ratio = ((nIndex / nCount) * 100);										//数据转换成float型输出百分比
			; printf("出现比例 :%7.2f%%\n", ratio);
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
	
	; LEA BX,TEMP_CX ;取地址
	mov ds:[bx],CX
	
	mov cx,0
	mov cl,g_szbuffer[si+1]
;-----------打印名字,并保存到temp------------
	call printf_space	
	call strcpyname
	call printf_Inf	
;---------------------------
	call printf_space
	LEA DX,Count_Number
	MOV AH,09H       ;接受键盘输入dx的缓冲器   
	INT 21H	

	LEA DX,nCountIndex
	MOV AH,09H       ;接受键盘输入dx的缓冲器   
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

;-------------- 显示全部联系人信息-------------------------
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
	
	;保存临时cl
	LEA BX,TEMP_CX ;取地址
	mov ds:[bx],CX
	mov cx,0
	mov cl,g_szbuffer[si+1]
;-----------------------
	call strcpyname
	call printf_Inf	
;---------------------------
	mov CX,TEMP_CX ;恢复循环
	
	jmp start_search
	
show_number:
	call printf_space

;--------保存临时cl
	LEA BX,TEMP_CX ;
	mov ds:[bx],CX
;--------------

	;拷贝字符buf[si]+1]串到temp，+上$ 打印temp
	mov cx,0
	mov cl,g_szbuffer[si+2]
;-------拷贝字符串 cl+1次--
	call strcpynum
	call printf_Inf	
	mov CX,TEMP_CX ;恢复循环
		
	call wraps_around
	INC Si
	jmp start_search
exit_search:
	ret
	
INF_Show endp 

;-------拷贝字符串到temp--
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

;-------拷贝号码到temp--
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

;清屏操作
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

;-------打印空格--------------
printf_space proc near
	LEA DX,s_spcae   	
	MOV AH,09H       
	INT 21H
	
	ret
printf_space endp
;-------------------------------------
;接受用户输入字符串到INPUT_BUFFER
scanf_s proc near
	LEA DX,INPUT_BUFFER
	;输入信息放入DX
	
	MOV AH,0AH       ;接受键盘输入dx的缓冲器    
	INT 21H
	
	ret
scanf_s  endp  
;---------------------------

;----------------显示内存分部------------------
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

;---------------打印temp中字符串---
printf_Inf proc near
	mov AX,0
    
	MOV AL,ST_TEMP  ;取BUFFER长度 
	ADD AL,1         ;AL存了字符串个数，字符串需要从AL+1开始
	MOV AH,0
	MOV DI,AX
    
	MOV	ST_TEMP[DI],'$' ;输入字符串加上$
	
	LEA DX,ST_TEMP+1    ;打印
	MOV AH,09H
	INT 21H
	
;----打印后清空---
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
;打印输入错误
printf_error  proc near

	LEA DX,INPUT_ERROR    ;打印错误
	MOV AH,09H
	INT 21H
	
	ret
printf_error endp
;----------------------------------------------------------
;延时 1s
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
 ;----------换行--------
wraps_around proc near
 	push dx
	push ax
		
	LEA DX,CRLF      ;光标换行
	MOV AH,09H       ;调用DOS
	INT 21H
	
	pop dx
	pop ax
	ret
wraps_around endp
 ;----------------------
 
;----------选择退出界面--------
Sel_Exit proc near

	call wraps_around
	call wraps_around
	
	LEA DX,SELECT_MSG
	MOV AH,09H
	INT 21H	
	
	call wraps_around
	LEA DX,SELECT_QUIT1    ;打印1
	MOV AH,09H
	INT 21H	
	call wraps_around
	
	LEA DX,SELECT_QUIT2      ;2
	MOV AH,09H       ;调用DOS
	INT 21H
	call wraps_around
	; scanf_s("%d", &nNum);
	call scanf_s
	; if (nNum == 1) {												//输入1返回主菜单
	cmp INPUT_BUFFER+2,31h
	jnz SelQUIT_Num2
		; Main_start();
		call Main_start
	; }
SelQUIT_Num2:
	; else if (nNum == 2) {										//输入2退出
	cmp INPUT_BUFFER+2,32h
	jnz SelQUIT_ERROR
		; exit(0);	
		jmp Exit
	; }
	; else
	; {
SelQUIT_ERROR:
	call wraps_around
	; printf("输入错误，请重新输入:\n");				//输入其他数字报错重新输入
	call printf_error
	; Select_exit();
	call wraps_around
	
	jmp Sel_Exit
	; }	

	ret
Sel_Exit endp
 
;----------------------------------------------------------
;显示主菜单
Main_Menu proc near
	push ax
	push cx
	push si
	push es
	push di
	mov ax, data
	mov ds, ax
	call clear_vga
	mov cx, 15 ;界面行数
	mov ax, 0b81fh
	mov es, ax
	mov bx, offset 00
row1:
	push cx

	mov cx, 53  ;列数
	mov si, 0h
color:
	mov al, [bx]
	mov es:[si], al
    cmp al, 2ah ;*号打印红色?
je colorA
	jmp colorB ;字符打印蓝色
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

;--读文件-----------------
read_file proc near

	mov dx , offset path		;dx获取file的偏移地址
	mov al , 0				
	mov ah , 3dh				
	int 21h                  ;打开文件，只读
	jc read_error                  ;若打开出错，转error
	mov handle,ax           ;保存文件句柄
	mov bx,ax				;文件句柄
	mov cx,1024	
	mov ax,extra			;获取g_buf的偏移地址
	mov dx,0
	mov ds,ax
	mov ah,3fh				
	int 21h                  ;从文件中读255字节→buf
	
	jc read_error                  ;若读出错，转error

	call close_file
	
	mov ax,data
	mov ds,ax
	

	jnc read_end            ;若关闭过程无错，转到end1处返回dos
read_error:
	mov dx , offset error_message		;获取error_message的偏移地址
	mov ah , 9						
	int 21h                            ;显示error_message
	
read_end:

	call load_len
	
	mov si,0
	mov di,0
	
	mov ax,extra;恢复ds,es
	mov es,ax
	mov ax,data
	mov ds,ax

	ret
read_file endp

;-----关闭文件----
close_file proc near
	
	mov ax,extra;恢复ds,es
	mov es,ax
	mov ax,data
	mov ds,ax
	
	mov bx,handle			   ;文件句柄
	mov ah,3eh						
	int 21h                            ;关闭文件
	
	ret
close_file endp
;--------------------
   
;------------load_len-------------------
load_len proc near
	mov ax,extra;恢复ds,es
	mov es,ax
	mov ax,data
	mov ds,ax
	;保存长度到s_len if(buff[i]==0 && buff[i+1]==0 )
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

;------输出寄存器AX内容----------------
  
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
	DIV WORD PTR [SI]   ;除法指令的被除数是隐含操作数，此处为DX:AX，商AX,余数DX
	ADD AL,48           ;商加上48即可得到相应数字的ASCII码
	MOV BYTE PTR [DI],AL       
	INC DI                               
	ADD SI,2                          
	MOV AX,DX                       
	LOOP PRINTF_AX  
			
	MOV DI, OFFSET RESULTS 
IF_0: 
	CMP  BYTE PTR [DI],'0'   ;不输出前面的0字符   
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


;---写文件--------------
write_file proc near

	mov dx,offset path
	mov	cx,0
	mov	ah,3cH
	int 21h               ;创建文件，若磁盘上原有此文件，则覆盖
	jc write_error               ;创建出错，转error处
	
	mov handle , ax         ;保存文件号
	mov bx,ax
	mov cx,1024
	mov ax,es
	mov ds,ax
	mov dx,0
	mov ah,40h
	int 21h                      ;向文件中写入cx个字节内容
	jc write_error                          ;写出错，转error处
	jmp end_write
write_error:
    mov dx , offset error_message
    mov ah , 9
    int 21h                              ;显示错误提示`

end_write:
	mov ax,extra;恢复ds,es
	mov es,ax
	mov ax,data
	mov ds,ax
	ret
write_file endp
;---------------------

CODE ENDS
END START