<?php
// register.php

// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "tutor_finder";

$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Initialize variables
$name = $email = $password = $user_type = "";
$errors = array();

// Form submission
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = trim($_POST['name']);
    $email = trim($_POST['email']);
    $password = trim($_POST['password']);
    $user_type = $_POST['user_type']; // 'student' or 'tutor'

    // Form validation
    if (empty($name)) { $errors[] = "Name is required"; }
    if (empty($email)) { $errors[] = "Email is required"; }
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) { $errors[] = "Invalid email format"; }
    if (empty($password)) { $errors[] = "Password is required"; }

    // If no errors, proceed to registration
    if (count($errors) == 0) {
        // Hash password
        $hashed_password = password_hash($password, PASSWORD_BCRYPT);

        // Prepare SQL statement
        $stmt = $conn->prepare("INSERT INTO users (name, email, password, user_type) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("ssss", $name, $email, $hashed_password, $user_type);

        // Execute and check if successful
        if ($stmt->execute()) {
            echo "Registration successful!";
        } else {
            echo "Error: " . $stmt->error;
        }
        $stmt->close();
    }
}
$conn->close();
?>

<!-- HTML Form -->
<form method="POST" action="register.php">
    <input type="text" name="name" placeholder="Name" required>
    <input type="email" name="email" placeholder="Email" required>
    <input type="password" name="password" placeholder="Password" required>
    <select name="user_type" required>
        <option value="student">Student</option>
        <option value="tutor">Tutor</option>
    </select>
    <button type="submit">Register</button>
</form>