<?php
session_start();

// Check if the user is already logged in
if(isset($_SESSION['user_type'])) {
    header('Location: dashboard.php');
    exit;
}

// User authentication logic
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Sample user data for demonstration
    $users = [
        'admin' => ['password' => 'admin123', 'type' => 'admin'],
        'tutor' => ['password' => 'tutor123', 'type' => 'tutor'],
        'student' => ['password' => 'student123', 'type' => 'student'],
    ];

    $username = $_POST['username'];
    $password = $_POST['password'];

    if (isset($users[$username]) && $users[$username]['password'] === $password) {
        $_SESSION['user_type'] = $users[$username]['type'];
        header('Location: dashboard.php');
        exit;
    } else {
        $error = 'Invalid credentials';
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>
    <?php if (!empty($error)) echo '<p style="color: red;">' . $error . '</p>'; ?>
    <form action="" method="POST">
        <label for="username">Username:</label><br>
        <input type="text" id="username" name="username" required><br><br>
        <label for="password">Password:</label><br>
        <input type="password" id="password" name="password" required><br><br>
        <input type="submit" value="Login">
    </form>
</body>
</html>