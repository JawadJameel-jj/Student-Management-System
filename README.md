# Student Management System README

## Overview

This script implements a simple **Student Management System** where:

* A **teacher** can manage student records by adding, updating, viewing, and deleting student information. They can also assign marks and calculate grades and CGPA.
* A **student** can log in to view their marks, grades, and CGPA.

### Features:

* **Teacher functionality**:

  * Add new students.
  * View student details.
  * Update marks for students.
  * Delete student records.
  * List students by various criteria (All students, sorted by CGPA, passed/failed students).
* **Student functionality**:

  * View their marks.
  * View their grades.
  * View their CGPA.

---

## Setup and Usage

### Prerequisites:

* This script is designed to run on **Linux/Unix**-based systems with **bash** installed.

### Files:

* `students.txt`: Stores student information including Roll No, Name, Marks, Grade, and CGPA.
* `passwords.txt`: Stores student credentials (Roll No, Password).
* `teacher_username`: Default teacher username is `Hassan`.
* `teacher_password`: Default teacher password is `oslab`.

### Running the Script:

1. Ensure that the script file is executable. If not, change permissions using:

   ```bash
   chmod +x student_management.sh
   ```
2. Execute the script by running:

   ```bash
   ./student_management.sh
   ```

### Menu Options:

* **Teacher Login**: Allows the teacher to manage student records.
* **Student Login**: Allows students to check their marks, grades, and CGPA.
* **Exit**: Exit the program.

---

## Functions

### Teacher Functions:

* **Add Student**: Prompts the teacher to input a student's Roll No, Name, and Password, and adds the student to the system.
* **View Student**: Allows the teacher to view details of a specific student using their Roll No.
* **Update Marks**: Allows the teacher to update marks for a student, automatically calculating the corresponding grade and CGPA.
* **Delete Student**: Allows the teacher to delete a student's record from the system.
* **List Students**: Provides options to list students:

  * **All Students**: Displays all students.
  * **Sorted by CGPA (Ascending)**: Displays students sorted by CGPA in ascending order.
  * **Sorted by CGPA (Descending)**: Displays students sorted by CGPA in descending order.
  * **Passed Students**: Displays students who have a CGPA of 1.00 or higher.
  * **Failed Students**: Displays students with a CGPA below 1.00.

### Student Functions:

* **View Marks**: Allows students to view their marks.
* **View Grades**: Allows students to view their grades.
* **View CGPA**: Allows students to view their CGPA.

### Authentication:

* **Teacher Login**: Uses hardcoded credentials (`Hassan` and `oslab`).
* **Student Login**: Verifies student credentials from the `passwords.txt` file.

---

## Code Structure:

* **Student Record Format**:

  * `Roll No, Name, Marks, Grade, CGPA`

* **Password File Format**:

  * `Roll No, Password`

* **Grade Calculation**:

  * The grade is calculated based on the marks provided:

    * 90+ marks: `A+`
    * 85-89 marks: `A`
    * and so on.

* **CGPA Calculation**:

  * The CGPA is calculated based on the marks provided:

    * 90+ marks: `4.00`
    * 85-89 marks: `4.00`
    * and so on.

---

## Example Usage:

1. **Teacher Login**:

   * Enter the username and password when prompted.
   * Choose an action from the Teacher Menu (e.g., Add a Student).
   * Follow the prompts to perform tasks.

2. **Student Login**:

   * Enter your Roll No and Password.
   * View your marks, grade, and CGPA.

---

## Notes:

* The student data is stored in the `students.txt` file, which is updated when adding, updating, or deleting records.
* Passwords are stored securely in the `passwords.txt` file (simple text format for demonstration purposes).
* The script limits the number of students to 20.

---

## Troubleshooting:

* If you encounter errors such as file permissions, ensure that the files `students.txt` and `passwords.txt` have proper read and write permissions.

---

## License:

This script is free to use and modify.
