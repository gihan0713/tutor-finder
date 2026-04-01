<?php
// Database connection configuration
$host = 'localhost';
$db_name = 'tutor_finder';
$username = 'your_username'; // Replace with your database username
$password = 'your_password'; // Replace with your database password

try {
    $dsn = "mysql:host=$host;dbname=$db_name";
    $options = [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ];
    $pdo = new PDO($dsn, $username, $password, $options);
} catch (PDOException $e) {
    echo 'Connection failed: ' . $e->getMessage();
}