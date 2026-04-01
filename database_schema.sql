-- Sri Lanka Tutor Finder - MySQL Database Schema --
-- This schema includes all tables for user management, tutoring services, bookings, messaging, reviews, and payments

CREATE DATABASE IF NOT EXISTS tutor_finder;
USE tutor_finder;

-- Users table: stores all user accounts (students, tutors, admins)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    user_type ENUM('student', 'tutor', 'admin') DEFAULT 'student',
    is_approved TINYINT(1) DEFAULT 1,
    is_banned TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_user_type (user_type)
);

-- Tutors table: extended profile information for tutors
CREATE TABLE tutors (
    tutor_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    subjects VARCHAR(255) NOT NULL,
    grades VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    location VARCHAR(100) NOT NULL,
    location_type ENUM('individual', 'group', 'both') DEFAULT 'both',
    online_option TINYINT(1) DEFAULT 1,
    availability TEXT NOT NULL,
    profile_photo VARCHAR(255),
    bank_name VARCHAR(100),
    account_number VARCHAR(50),
    contact_number VARCHAR(15),
    description TEXT,
    rating DECIMAL(3, 2) DEFAULT 0,
    total_reviews INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_location (location),
    INDEX idx_location_type (location_type)
);

-- Tutor Posters table: store marketing posters uploaded by tutors
CREATE TABLE tutor_posters (
    poster_id INT AUTO_INCREMENT PRIMARY KEY,
    tutor_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    is_featured TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id) ON DELETE CASCADE,
    INDEX idx_tutor_id (tutor_id),
    INDEX idx_is_featured (is_featured)
);

-- Bookings table: track tutor booking requests and confirmations
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    tutor_id INT NOT NULL,
    subject VARCHAR(100) NOT NULL,
    grade VARCHAR(50) NOT NULL,
    booking_date DATE NOT NULL,
    time_slot VARCHAR(50),
    location_type ENUM('individual', 'group') NOT NULL,
    status ENUM('pending', 'accepted', 'rejected', 'completed', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id) ON DELETE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_tutor_id (tutor_id),
    INDEX idx_status (status)
);

-- Messages table: store tutor-student communications
CREATE TABLE messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    message TEXT NOT NULL,
    is_read TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_sender_id (sender_id),
    INDEX idx_receiver_id (receiver_id),
    INDEX idx_created_at (created_at)
);

-- Reviews table: store ratings and feedback for tutors
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    tutor_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id) ON DELETE CASCADE,
    INDEX idx_tutor_id (tutor_id),
    INDEX idx_student_id (student_id)
);

-- Payment Slips table: store proof of payment for tutors
CREATE TABLE payment_slips (
    slip_id INT AUTO_INCREMENT PRIMARY KEY,
    tutor_id INT NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id) ON DELETE CASCADE,
    INDEX idx_tutor_id (tutor_id)
);

-- Subjects table: catalog of available subjects
CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_subject_name (subject_name)
);

-- Districts table: catalog of Sri Lankan districts
CREATE TABLE districts (
    district_id INT AUTO_INCREMENT PRIMARY KEY,
    district_name VARCHAR(100) NOT NULL UNIQUE,
    province VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_district_name (district_name)
);

-- Insert default admin user (email: gihanfernandow@gmail.com, password: gihan33)
INSERT INTO users (full_name, email, password, user_type, is_approved) VALUES ('Admin User', 'gihanfernandow@gmail.com', '$2y$10$9K5e7z.7H.J.C3.Q.X.K9e9K5e7z.7H.J.C3.Q.X.K9e9K5e7z.7H.J.C3', 'admin', 1);

-- Insert sample subjects
INSERT INTO subjects (subject_name, category) VALUES 
('Mathematics', 'Core'), 
('Science', 'Core'), 
('English', 'Core'), 
('Sinhala', 'Core'), 
('History', 'Social Studies'), 
('Geography', 'Social Studies'), 
('Physics', 'Science'), 
('Chemistry', 'Science'), 
('Biology', 'Science'), 
('Commerce', 'Specialization'), 
('Accounting', 'Specialization');

-- Insert Sri Lankan districts
INSERT INTO districts (district_name, province) VALUES 
('Colombo', 'Western Province'), 
('Galle', 'Southern Province'), 
('Matara', 'Southern Province'), 
('Hambantota', 'Southern Province'), 
('Kandy', 'Central Province'), 
('Nuwara Eliya', 'Central Province'), 
('Ratnapura', 'Sabaragamuwa Province'), 
('Kegalle', 'Sabaragamuwa Province'), 
('Kurunegala', 'North Western Province'), 
('Puttalam', 'North Western Province'), 
('Anuradhapura', 'North Central Province'), 
('Polonnaruwa', 'North Central Province'), 
('Jaffna', 'Northern Province'), 
('Mullaitivu', 'Northern Province'), 
('Batticaloa', 'Eastern Province'), 
('Ampara', 'Eastern Province'), 
('Trincomalee', 'Eastern Province'), 
('Badulla', 'Uva Province'), 
('Monaragala', 'Uva Province');
