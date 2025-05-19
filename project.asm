.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
WriteString proto
ReadString proto
WriteInt proto
Crlf proto
StrLength proto
WriteHex proto
WriteDec proto

include Irvine32.inc

.data
    prompt          db  "Enter your password: ", 0
    valid_msg       db  "Password is valid.", 0
    invalid_msg     db  "Password is invalid. Reasons:", 0
    too_short       db  " - Must be at least 8 characters long", 0
    no_upper        db  " - Must contain at least one uppercase letter", 0
    no_lower        db  " - Must contain at least one lowercase letter", 0
    no_number       db  " - Must contain at least one number", 0
    no_special      db  " - Must contain at least one special character", 0

    password        db  256 dup(?)     ; Buffer for password input
    password_len    dd  ?

.code
main proc
password_input:
    ; Print prompt
    mov edx, offset prompt
    call WriteString

    ; Read password
    mov edx, offset password
    mov ecx, sizeof password
    call ReadString
    mov password_len, eax    ; Save length of password

    ; Initialize flags
    xor ebx, ebx                ; ebx will hold validation flags
                                ; bit 0 = length valid
                                ; bit 1 = has uppercase
                                ; bit 2 = has lowercase
                                ; bit 3 = has number
                                ; bit 4 = has special char

    ; Check password length (at least 8 characters)
    cmp eax, 8
    jl length_invalid
    or ebx, 1                   ; set length valid flag
    jmp check_chars

length_invalid:
    and ebx, 0FFFFFFFEh         ; clear length valid flag

check_chars:
    mov esi, offset password    ; point to password string
    mov ecx, password_len       ; counter

char_loop:
    mov al, [esi]               ; get current character

    ; Check for uppercase (A-Z)
    cmp al, 'A'
    jb check_lower_case
    cmp al, 'Z'
    ja check_lower_case
    or ebx, 2                   ; set uppercase flag
    jmp next_char

check_lower_case:
    ; Check for lowercase (a-z)
    cmp al, 'a'
    jb check_digit
    cmp al, 'z'
    ja check_digit
    or ebx, 4                   ; set lowercase flag
    jmp next_char

check_digit:
    ; Check for number (0-9)
    cmp al, '0'
    jb check_special_char
    cmp al, '9'
    ja check_special_char
    or ebx, 8                   ; set number flag
    jmp next_char

check_special_char:
    ; Check for special character (anything not alphanumeric)
    ; We consider it special if it's not uppercase, lowercase, or digit
    or ebx, 16                  ; set special char flag

next_char:
    inc esi
    loop char_loop

    ; Check if all requirements are met
    mov eax, ebx
    and eax, 1Fh                ; check all 5 flags (1+2+4+8+16 = 31 = 1Fh)
    cmp eax, 1Fh
    je password_valid

    ; Password is invalid - print reasons
    mov edx, offset invalid_msg
    call WriteString
    call Crlf

    ; Check and print which requirements failed
    test ebx, 1
    jnz check_upper_req
    mov edx, offset too_short
    call WriteString
    call Crlf

check_upper_req:
    test ebx, 2
    jnz check_lower_req
    mov edx, offset no_upper
    call WriteString
    call Crlf

check_lower_req:
    test ebx, 4
    jnz check_number_req
    mov edx, offset no_lower
    call WriteString
    call Crlf

check_number_req:
    test ebx, 8
    jnz check_special_req
    mov edx, offset no_number
    call WriteString
    call Crlf

check_special_req:
    test ebx, 16
    jnz ask_again
    mov edx, offset no_special
    call WriteString
    call Crlf

ask_again:
    call Crlf
    jmp password_input          ; Loop back to ask for password again

password_valid:
    ; Print valid message
    mov edx, offset valid_msg
    call WriteString
    call Crlf

exit_program:
    call Crlf
    invoke ExitProcess, 0
main endp
end main