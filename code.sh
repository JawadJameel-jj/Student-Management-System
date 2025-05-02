# This script implements a simple student management system that allows a teacher to add,
# update, view, and delete student records, as well as assign marks and calculate grades
# and CGPA.Students can log in to view their marks, grades, and CGPA.

#!/bin/bash

STUDENT_FILE = "students.txt"
PASSWORD_FILE = "passwords.txt"
TEACHER_USERNAME = "Hassan"
TEACHER_PASSWORD = "oslab"

# Function to check if file exists, else create it.
touch "$STUDENT_FILE"
touch "$PASSWORD_FILE"

# Authentication Function to verify login credentials.
authenticate() {
    clear
        local role = $1  # Role = "teacher" or "student", passed as a parameter.
        echo - n "Enter Username: "
        read username
        echo - n "Enter Password: "
        read - s password
        echo ""

        if [[ "$role" == "teacher" && "$username" == "$TEACHER_USERNAME" && "$password" == "$TEACHER_PASSWORD" ]]; then
            return 0
            elif [[ "$role" == "student" ]]; then
            if grep - q "^${username},${password}$" "$PASSWORD_FILE"; then
                roll_no = "$username"  # Assign roll_no for later use.
                return 0
                fi
                fi
                return 1  # Failed to login.
}

# Function to add student.
add_student() {
    if [[ $(wc - l < "$STUDENT_FILE") - ge 20 ]]; then
        echo "20 Students Limit Reached!"
        read - p "Press Enter to continue..."
        return
        fi
        echo - n "Enter Roll No: "
        read roll_no
        if grep - q "^${roll_no}," "$STUDENT_FILE"; then
            echo "A Student with this Roll No already exists!"
            read - p "Press Enter to continue..."
            return
            fi
            echo - n "Enter Name: "
            read name
            echo - n "Set Password: "
            read - s password
            echo ""

            echo "${roll_no}, ${name}, N/A, N/A, N/A" >> "$STUDENT_FILE"
            echo "${roll_no},${password}" >> "$PASSWORD_FILE"	# Add roll number and password to the password file.
            echo "Student added successfully!"
            read - p "Press Enter to continue..."
}

# Function to view student details.
view_student() {
    echo - n "Enter Roll No: "
        read roll_no
        grep "^${roll_no}," "$STUDENT_FILE" || echo "Student not found!"	# Search for a student record that starts with the entered roll number followed by a comma.
        read - p "Press Enter to continue..."
}

# Function to update marks.
update_marks() {
    echo - n "Enter Roll No: "
        read roll_no
        echo - n "Enter Marks: "
        read marks
        found = false
        grade = $(calculate_grade "$marks")
        cgpa = $(calculate_cgpa "$marks")

        # Read each line from the file and update the relevant record
        while IFS = ',' read - r r_no name cur_marks cur_grade cur_cgpa; do
            if [[ "$r_no" == "$roll_no" ]]; then
                echo "${r_no},${name}, ${marks}, ${grade}, ${cgpa}" >> temp  # Update the record
                found = true
            else
                echo "${r_no},${name}, ${cur_marks}, ${cur_grade}, ${cur_cgpa}" >> temp  # Keep other records intact
                fi
                done < "$STUDENT_FILE"

                # Replace the file with the updated content.
                if [[ "$found" == true ]]; then
                    mv temp "$STUDENT_FILE"
                    echo "Marks updated successfully!"
                else
                    rm temp
                    echo "Student not found!"
                    fi
                    read - p "Press Enter to continue..."
}

# Function to delete a student.
delete_student() {
    echo - n "Enter Roll No: "
        read roll_no
        if !grep - q "^${roll_no}," "$STUDENT_FILE"; then
            echo "No Student found with Roll No: $roll_no!"
            read - p "Press Enter to continue..."
            return
            fi

            grep - v "^${roll_no}," "$STUDENT_FILE" > temp
            if[-s temp]; then   # If temp is NOT empty, replace the original file.
                mv temp "$STUDENT_FILE"
            else                   # If temp is empty, truncate the original file.
    > "$STUDENT_FILE"
                rm temp
                fi

                grep - v "^${roll_no}," "$PASSWORD_FILE" > temp
                if[-s temp]; then
                    mv temp "$PASSWORD_FILE"
                else
        > "$PASSWORD_FILE"
                    rm temp
                    fi

                    echo "Student deleted successfully!"
                    read - p "Press Enter to continue..."
}

# Function to calculate grade based on marks.
calculate_grade() {
    local marks = $1
        if ((marks >= 90)); then echo "A+";
    elif((marks >= 85)); then echo "A";
    elif((marks >= 80)); then echo "A-";
    elif((marks >= 75)); then echo "B+";
    elif((marks >= 70)); then echo "B";
    elif((marks >= 65)); then echo "B-";
    elif((marks >= 60)); then echo "C+";
    elif((marks >= 55)); then echo "C";
    elif((marks >= 50)); then echo "D";
        else echo "F";
    fi
}

# Function to calculate CGPA based on marks.
calculate_cgpa() {
    local marks = $1
        if ((marks >= 90)); then echo "4.00";
    elif((marks >= 85)); then echo "4.00";
    elif((marks >= 80)); then echo "3.67";
    elif((marks >= 75)); then echo "3.33";
    elif((marks >= 70)); then echo "3.00";
    elif((marks >= 65)); then echo "2.67";
    elif((marks >= 60)); then echo "2.33";
    elif((marks >= 55)); then echo "2.00";
    elif((marks >= 50)); then echo "1.67";
    elif((marks >= 45)); then echo "1.33";
    elif((marks >= 40)); then echo "1.00";
        else echo "0.00";
    fi
}
# Function to list all students.
display_students() {
    echo "Displaying All Students:"
        column - s ',' - t < "$STUDENT_FILE"	# Formats and displays the student data in a tabular format.
        read - p "Press Enter to continue..."
}

# Function to list students sorted by CGPA in ascending order.
list_students_asc() {
    echo "Students Sorted by CGPA (Ascending):"
        sort - t ',' - k5 - n "$STUDENT_FILE" | column - s ',' - t	# Sorts by CGPA(column 5) in ascending order(-n).
        read - p "Press Enter to continue..."
}

# Function to list students sorted by CGPA in descending order.
list_students_desc() {
    echo "Students Sorted by CGPA (Descending):"
        sort - t ',' - k5 - nr "$STUDENT_FILE" | column - s ',' - t	# Sorts by CGPA(column 5) in descending order(-nr).
        read - p "Press Enter to continue..."
}

# Function to list students who passed(CGPA >= 1.00).
list_passed_students() {
    echo "List of Passed Students (CGPA 1.00 and Above):"
        while IFS = ',' read - r roll_no name marks grade cgpa; do
            if (($(echo "$cgpa >= 1.00" | bc - l))); then	# Use bc - l for floating - point comparison(returns 1 if true, 0 if false).
                echo "$roll_no  $name  $marks  $grade  $cgpa"
                fi
                done < "$STUDENT_FILE"
                read - p "Press Enter to continue..."
}

# Function to list students who failed(CGPA < 1.00).
    list_failed_students() {
    echo "List of Failed Students (CGPA Below 1.00):"
        while IFS = ',' read - r roll_no name marks grade cgpa; do
            if (($(echo "$cgpa < 1.00" | bc - l))); then	# Use bc - l for floating - point comparison(returns 1 if true, 0 if false).
                echo "$roll_no  $name  $marks  $grade  $cgpa"
                fi
                done < "$STUDENT_FILE"
                read - p "Press Enter to continue..."
}

# Function to display submenu for listing students.
list_students_menu() {
    echo "Choose Listing Option:"
        echo "1. Display All Students"
        echo "2. Display Students Sorted by CGPA (Ascending)"
        echo "3. Display Students Sorted by CGPA (Descending)"
        echo "4. Display Passed Students"
        echo "5. Display Failed Students"
        echo "6. Back to Main Menu"
        read - p "Choice: " choice

        case $choice in
        1) clear
        display_students;;
    2) clear
    list_students_asc;;
    3) clear
    list_students_desc;;
    4) clear
    list_passed_students;;
    5) clear
    list_failed_students;;
    6) return;;
    *) echo "Invalid choice!"
    read - p "Press Enter to continue...";;
    esac
}

# Teacher Menu.
teacher_menu() {
    while true; do
        clear
        echo "1. Add Student"
        echo "2. View Student Details"
        echo "3. Update Marks"
        echo "4. Delete Student"
        echo "5. List Students"
        echo "6. Logout"
        read - p "Choice: " choice

        case $choice in
        1) clear
        add_student;;
    2) clear
    view_student;;
    3) clear
    update_marks;;
    4) clear
    delete_student;;
    5) clear
    list_students_menu;;  # Redirects to the submenu.
        6) echo "Logging out..."
        break;;
    *) echo "Invalid choice!"
    read - p "Press Enter to continue...";;
    esac
        done
}

# Student Menu.
student_menu() {
    local roll_no = $1
        clear
        while true; do
            clear
            echo "1. View Marks"
            echo "2. View Grades"
            echo "3. View CGPA"
            echo "4. Logout"
            read - p "Choice: " choice
            case $choice in
            1) clear
            grep "^${roll_no}," "$STUDENT_FILE" | cut - d ',' - f3  # Extracts and displays the 3rd field(Marks) from the student's record.
            read - p "Press Enter to continue...";;
    2) clear
    grep "^${roll_no}," "$STUDENT_FILE" | cut - d ',' - f4  # Extracts and displays the 4th field(Grade) from the student's record.
        read - p "Press Enter to continue...";;
    3) clear
    grep "^${roll_no}," "$STUDENT_FILE" | cut - d ',' - f5  # Extracts and displays the 5th field(CGPA) from the student's record.
        read - p "Press Enter to continue...";;
    4) echo "Logging out..."
    break;;
    *) echo "Invalid choice!"
    read - p "Press Enter to continue...";;
    esac
        done
}

# Main Menu.
while true; do
clear
echo "1. Teacher Login"
echo "2. Student Login"
echo "3. Exit"
read - p "Choice: " choice
case $choice in
1) authenticate "teacher" && teacher_menu || echo "Invalid Credentials!"
read - p "Press Enter to continue...";;
2) authenticate "student" && student_menu "$roll_no" || echo "Invalid Credentials!"
read - p "Press Enter to continue...";;
3) echo "Exiting..."
exit;;
*) echo "Invalid choice!"
read - p "Press Enter to continue...";;
esac
done
