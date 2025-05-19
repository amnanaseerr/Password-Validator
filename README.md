🔐 Assembly Language Password Validator

📌 Description
This project is an Assembly Language Password Validator written using the Irvine32 library. It prompts the user to input a password and performs a series of validation checks to ensure it meets specific security criteria. If the password fails any of the checks, detailed reasons are displayed and the user is prompted to try again until a valid password is entered.

✅ Validation Criteria
The password must meet all the following requirements:

Minimum Length: At least 8 characters.

Uppercase Letter: At least one uppercase letter (A-Z).

Lowercase Letter: At least one lowercase letter (a-z).

Number: At least one numeric digit (0-9).

Special Character: At least one non-alphanumeric character (e.g., @, #, !, etc.).

🧠 How It Works
Prompts the user to enter a password.

Scans the input character by character to check:

Length

Character categories

Sets validation flags using bitwise operations.

If any requirement is not met:

Displays an invalid message with specific missing criteria.

Loops back to ask for the password again.

If all requirements are met:

Displays "Password is valid."

Ends the program.

🛠 Technologies Used
x86 Assembly Language

Irvine32 Library

Runs on Windows (32-bit) with MASM (Microsoft Macro Assembler)

🗂 Project Structure
PasswordValidator.asm   ; Main Assembly source file
README.md               ; Project documentation

▶️ How to Run
Ensure you have:

MASM installed (e.g., via Microsoft Visual Studio or MASM32 SDK)

Irvine32.inc, Irvine32.lib, and related support files in your project directory

📸 Sample Output

Enter your password: test
Password is invalid. Reasons:
 - Must be at least 8 characters long
 - Must contain at least one uppercase letter
 - Must contain at least one number
 - Must contain at least one special character

Enter your password: Valid123!
Password is valid.
