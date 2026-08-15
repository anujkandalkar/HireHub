-- =========================================================
-- HireHub - Job Portal & Recruitment Management System
-- Complete Database Schema & Seed Data Script
-- MySQL 8.x Compatible
-- =========================================================

CREATE DATABASE IF NOT EXISTS hirehub_db;
USE hirehub_db;

-- ---------------------------------------------------------
-- Drop tables if exists (reverse dependency order)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS admin_logs;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS interviews;
DROP TABLE IF EXISTS task_submissions;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS resumes;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS educations;
DROP TABLE IF EXISTS experiences;
DROP TABLE IF EXISTS student_skills;
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS users;

-- ---------------------------------------------------------
-- 1. USERS TABLE
-- ---------------------------------------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    salt VARCHAR(100) NOT NULL,
    role ENUM('ADMIN', 'STUDENT', 'COMPANY') NOT NULL,
    status ENUM('PENDING', 'ACTIVE', 'BLOCKED', 'REJECTED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_email (email),
    INDEX idx_user_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 2. STUDENTS TABLE
-- ---------------------------------------------------------
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    gender VARCHAR(20),
    dob DATE,
    city VARCHAR(100),
    state VARCHAR(100),
    education_level VARCHAR(100),
    college_name VARCHAR(150),
    graduation_year INT,
    cgpa DECIMAL(3,2),
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_student_name (full_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 3. COMPANIES TABLE
-- ---------------------------------------------------------
CREATE TABLE companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    company_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20),
    website VARCHAR(150),
    industry VARCHAR(100),
    company_size VARCHAR(50),
    location VARCHAR(100),
    description TEXT,
    logo_url VARCHAR(255),
    approval_status ENUM('PENDING', 'APPROVED', 'REJECTED', 'BLOCKED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_company_status (approval_status),
    INDEX idx_company_name (company_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 4. JOBS TABLE
-- ---------------------------------------------------------
CREATE TABLE jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    responsibilities TEXT,
    requirements TEXT,
    required_skills TEXT NOT NULL, -- Comma separated skills e.g., Java, SQL, HTML
    location VARCHAR(100) NOT NULL,
    salary_min DECIMAL(10,2) DEFAULT 0.00,
    salary_max DECIMAL(10,2) DEFAULT 0.00,
    experience_years VARCHAR(50) DEFAULT '0-1 Years',
    job_type ENUM('FULL_TIME', 'PART_TIME', 'INTERNSHIP', 'CONTRACT') NOT NULL DEFAULT 'FULL_TIME',
    vacancies INT DEFAULT 1,
    deadline DATE,
    status ENUM('ACTIVE', 'INACTIVE', 'CLOSED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    INDEX idx_job_title (title),
    INDEX idx_job_status (status),
    INDEX idx_job_location (location)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 5. APPLICATIONS TABLE
-- ---------------------------------------------------------
CREATE TABLE applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    job_id INT NOT NULL,
    company_id INT NOT NULL,
    applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('APPLIED', 'UNDER_REVIEW', 'SHORTLISTED', 'TASK_ASSIGNED', 'INTERVIEW', 'SELECTED', 'REJECTED', 'WITHDRAWN') NOT NULL DEFAULT 'APPLIED',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    UNIQUE KEY unique_student_job (student_id, job_id),
    INDEX idx_app_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 6. STUDENT SKILLS TABLE
-- ---------------------------------------------------------
CREATE TABLE student_skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    skill_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    UNIQUE KEY unique_student_skill (student_id, skill_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 7. EXPERIENCES TABLE
-- ---------------------------------------------------------
CREATE TABLE experiences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    company_name VARCHAR(150) NOT NULL,
    role_title VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    description TEXT,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 8. EDUCATIONS TABLE
-- ---------------------------------------------------------
CREATE TABLE educations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    degree VARCHAR(100) NOT NULL,
    institution VARCHAR(150) NOT NULL,
    field_of_study VARCHAR(100),
    start_year INT,
    end_year INT,
    score VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 9. PROJECTS TABLE
-- ---------------------------------------------------------
CREATE TABLE projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    technologies VARCHAR(255),
    github_url VARCHAR(255),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 10. RESUMES TABLE
-- ---------------------------------------------------------
CREATE TABLE resumes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL UNIQUE,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    file_type VARCHAR(50),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 11. MESSAGES TABLE
-- ---------------------------------------------------------
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    application_id INT,
    subject VARCHAR(200) NOT NULL,
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 12. TASKS TABLE
-- ---------------------------------------------------------
CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    company_id INT NOT NULL,
    student_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    instructions TEXT,
    deadline DATE,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 13. TASK SUBMISSIONS TABLE
-- ---------------------------------------------------------
CREATE TABLE task_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL UNIQUE,
    submission_text TEXT,
    file_path VARCHAR(255),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('SUBMITTED', 'REVIEWED', 'PASSED', 'FAILED') DEFAULT 'SUBMITTED',
    feedback TEXT,
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 14. INTERVIEWS TABLE
-- ---------------------------------------------------------
CREATE TABLE interviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    company_id INT NOT NULL,
    student_id INT NOT NULL,
    interview_date DATE NOT NULL,
    interview_time TIME NOT NULL,
    interview_type ENUM('ONLINE', 'OFFLINE', 'PHONE') NOT NULL DEFAULT 'ONLINE',
    meeting_link VARCHAR(255),
    interviewer_name VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 15. NOTIFICATIONS TABLE
-- ---------------------------------------------------------
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'INFO',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- 16. ADMIN LOGS TABLE
-- ---------------------------------------------------------
CREATE TABLE admin_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admin_user_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- SEED DATA INSERTS
-- =========================================================

-- 1. SEED PREDEFINED ADMIN
-- Email: admin@gmail.com
-- Password: Admin@4249
-- Salt: hirehub_admin_salt_4249
-- Hash: 7849f0dc2cd86a50a2d7cac5f6a4ffc8e3464097e681eb417b2030a89828b8f3
INSERT INTO users (id, email, password_hash, salt, role, status)
VALUES (1, 'admin@gmail.com', '7849f0dc2cd86a50a2d7cac5f6a4ffc8e3464097e681eb417b2030a89828b8f3', 'hirehub_admin_salt_4249', 'ADMIN', 'ACTIVE');

-- 2. SEED SAMPLE COMPANIES
-- Password for all sample companies: Company@123
-- Salt: hirehub_company_salt_123
-- Hash for Company@123 + hirehub_company_salt_123: calculated dynamically by app or standard hash
-- For seeding, we use valid hash for Company@123 with salt hirehub_company_salt_123
-- SHA-256("hirehub_company_salt_123" + "Company@123") -> 679bf90d1f70693a1adbbcf0a3a4c49ad5f2f551b9e5967b57954fa0f0580979
INSERT INTO users (id, email, password_hash, salt, role, status) VALUES
(2, 'contact@technova.com', '679bf90d1f70693a1adbbcf0a3a4c49ad5f2f551b9e5967b57954fa0f0580979', 'hirehub_company_salt_123', 'COMPANY', 'ACTIVE'),
(3, 'careers@infosys.com', '679bf90d1f70693a1adbbcf0a3a4c49ad5f2f551b9e5967b57954fa0f0580979', 'hirehub_company_salt_123', 'COMPANY', 'ACTIVE'),
(4, 'recruitment@tcs.com', '679bf90d1f70693a1adbbcf0a3a4c49ad5f2f551b9e5967b57954fa0f0580979', 'hirehub_company_salt_123', 'COMPANY', 'ACTIVE'),
(5, 'hr@codecraft.com', '679bf90d1f70693a1adbbcf0a3a4c49ad5f2f551b9e5967b57954fa0f0580979', 'hirehub_company_salt_123', 'COMPANY', 'ACTIVE'),
(6, 'jobs@innovatesoft.com', '679bf90d1f70693a1adbbcf0a3a4c49ad5f2f551b9e5967b57954fa0f0580979', 'hirehub_company_salt_123', 'COMPANY', 'ACTIVE');

INSERT INTO companies (id, user_id, company_name, phone, website, industry, company_size, location, description, approval_status) VALUES
(1, 2, 'TechNova Solutions', '+1 555-0192', 'https://technova.com', 'Information Technology', '500-1000', 'San Francisco, CA', 'Leading enterprise software development firm specializing in cloud and full-stack solutions.', 'APPROVED'),
(2, 3, 'Infosys Technologies', '+91 80-28520261', 'https://infosys.com', 'IT Services & Consulting', '10000+', 'Bangalore, India', 'Global leader in next-generation digital services and consulting solutions.', 'APPROVED'),
(3, 4, 'Tata Consultancy Services', '+91 22-67789999', 'https://tcs.com', 'Software Services', '10000+', 'Mumbai, India', 'Transforming businesses through technology, innovation and strategic partnerships worldwide.', 'APPROVED'),
(4, 5, 'CodeCraft Technologies', '+1 415-8890', 'https://codecraft.io', 'Software Product Development', '50-200', 'Austin, TX', 'High-growth tech startup crafting high-throughput backend services and web platforms.', 'APPROVED'),
(5, 6, 'InnovateSoft Labs', '+1 206-4431', 'https://innovatesoft.org', 'Cloud & AI Engineering', '200-500', 'Seattle, WA', 'Pioneering cloud computing tools, web architecture and enterprise AI applications.', 'APPROVED');

-- 3. SEED SAMPLE STUDENTS
-- Password for all sample students: Student@123
-- Salt: hirehub_student_salt_123
-- SHA-256("hirehub_student_salt_123" + "Student@123") -> 1e813a8b41caeaebc1d3fbcd4762c64dbf556488a0e8825c04df90432c695db2
INSERT INTO users (id, email, password_hash, salt, role, status) VALUES
(7, 'alex.smith@gmail.com', '1e813a8b41caeaebc1d3fbcd4762c64dbf556488a0e8825c04df90432c695db2', 'hirehub_student_salt_123', 'STUDENT', 'ACTIVE'),
(8, 'priya.sharma@gmail.com', '1e813a8b41caeaebc1d3fbcd4762c64dbf556488a0e8825c04df90432c695db2', 'hirehub_student_salt_123', 'STUDENT', 'ACTIVE'),
(9, 'david.miller@gmail.com', '1e813a8b41caeaebc1d3fbcd4762c64dbf556488a0e8825c04df90432c695db2', 'hirehub_student_salt_123', 'STUDENT', 'ACTIVE');

INSERT INTO students (id, user_id, full_name, phone, gender, dob, city, state, education_level, college_name, graduation_year, cgpa, bio) VALUES
(1, 7, 'Alex Smith', '+1 555-0144', 'Male', '2001-05-14', 'San Jose', 'CA', 'Bachelor of Science in Computer Science', 'Stanford University', 2024, 3.85, 'Passionate Java and Full Stack Developer with strong foundation in Servlet, JDBC, MySQL, HTML, CSS, JavaScript.'),
(2, 8, 'Priya Sharma', '+91 9876543210', 'Female', '2002-08-20', 'Bangalore', 'Karnataka', 'B.Tech in Information Technology', 'IIT Bangalore', 2024, 3.90, 'Enthusiastic Backend & Database Developer skilled in Java, MySQL, Servlets, HTML, CSS and Data Structures.'),
(3, 9, 'David Miller', '+1 555-0188', 'Male', '2000-11-10', 'Austin', 'TX', 'Master of Science in Software Engineering', 'UT Austin', 2023, 3.75, 'Software Engineer experienced in Web development, RESTful architecture, Python, SQL and JavaScript.');

-- Seed Student Skills
INSERT INTO student_skills (student_id, skill_name) VALUES
(1, 'Java'), (1, 'JDBC'), (1, 'Servlets'), (1, 'MySQL'), (1, 'HTML'), (1, 'CSS'), (1, 'JavaScript'),
(2, 'Java'), (2, 'MySQL'), (2, 'HTML'), (2, 'CSS'), (2, 'SQL'), (2, 'Backend Development'),
(3, 'Python'), (3, 'SQL'), (3, 'HTML'), (3, 'CSS'), (3, 'JavaScript'), (3, 'Django');

-- Seed Student Educations
INSERT INTO educations (student_id, degree, institution, field_of_study, start_year, end_year, score) VALUES
(1, 'B.S. Computer Science', 'Stanford University', 'Software Engineering', 2020, 2024, '3.85 CGPA'),
(2, 'B.Tech Information Technology', 'IIT Bangalore', 'Computer Science', 2020, 2024, '3.90 CGPA'),
(3, 'M.S. Software Engineering', 'UT Austin', 'Computer Systems', 2021, 2023, '3.75 CGPA');

-- Seed Student Projects
INSERT INTO projects (student_id, title, description, technologies, github_url) VALUES
(1, 'E-Commerce System', 'Web-based store with cart, payment integration, and inventory management.', 'Java, Servlets, JDBC, MySQL, Bootstrap', 'https://github.com/alexsmith/ecommerce'),
(2, 'Library Management Portal', 'Automated library records management system with role-based access.', 'Java, MySQL, HTML, CSS, JavaScript', 'https://github.com/priyasharma/library-portal');

-- 4. SEED SAMPLE JOBS
INSERT INTO jobs (id, company_id, title, description, responsibilities, requirements, required_skills, location, salary_min, salary_max, experience_years, job_type, vacancies, deadline, status) VALUES
(1, 1, 'Java Full Stack Developer', 'We are looking for a skilled Java Full Stack Developer to build high-performance Web applications.', 'Design and implement core Java servlets, database schemas, responsive UI pages, and REST interfaces.', 'Strong understanding of Java, JDBC, Servlets, MySQL, HTML, CSS, JavaScript.', 'Java, JDBC, Servlets, MySQL, HTML, CSS, JavaScript', 'San Francisco, CA', 85000.00, 115000.00, '0-2 Years', 'FULL_TIME', 4, '2026-12-31', 'ACTIVE'),
(2, 2, 'Java Backend Developer', 'Join our core engineering team developing robust server-side applications and JDBC data services.', 'Write scalable backend logic, optimize database queries, build authentication filters.', 'Degree in Computer Science or IT. Proficiency in Java, SQL, MySQL, Servlets.', 'Java, SQL, MySQL, Servlets, JDBC', 'Bangalore, India', 75000.00, 95000.00, '1-3 Years', 'FULL_TIME', 6, '2026-12-31', 'ACTIVE'),
(3, 3, 'Software Engineer - Web', 'Looking for motivated developers to build enterprise web portals and cloud services.', 'Collaborate with UI designers and backend engineers to implement clean features.', 'Hands-on experience in HTML, CSS, JavaScript, Java, SQL.', 'HTML, CSS, JavaScript, Java, SQL', 'Mumbai, India', 70000.00, 90000.00, '0-1 Years', 'FULL_TIME', 10, '2026-12-31', 'ACTIVE'),
(4, 4, 'Backend Software Engineer', 'Create high-efficiency microservices and API modules using Java and database tools.', 'Implement data pipelines, manage connection pools, enforce security standards.', 'Proficiency in Java, MySQL, Data Structures, System Design.', 'Java, MySQL, Data Structures, SQL', 'Austin, TX', 90000.00, 120000.00, '1-3 Years', 'FULL_TIME', 3, '2026-12-31', 'ACTIVE'),
(5, 5, 'Frontend Web Developer', 'Craft compelling user experiences using modern HTML5, CSS3, JavaScript and Bootstrap 5.', 'Develop pixel-perfect responsive layouts and seamless UI interactions.', 'Strong expertise in HTML5, CSS3, JavaScript, Bootstrap 5, AJAX.', 'HTML, CSS, JavaScript, Bootstrap', 'Seattle, WA', 80000.00, 105000.00, '0-2 Years', 'FULL_TIME', 2, '2026-12-31', 'ACTIVE'),
(6, 1, 'Python & Web Intern', 'Seeking entry-level developer intern to work on data services and web projects.', 'Assist team in building web endpoints, documentation and testing.', 'Knowledge of Python, SQL, HTML, CSS.', 'Python, SQL, HTML, CSS', 'Remote / San Francisco, CA', 45000.00, 60000.00, '0-1 Years', 'INTERNSHIP', 5, '2026-12-31', 'ACTIVE');

-- 5. SEED SAMPLE APPLICATIONS
INSERT INTO applications (id, student_id, job_id, company_id, status) VALUES
(1, 1, 1, 1, 'SHORTLISTED'),
(2, 1, 2, 2, 'APPLIED'),
(3, 2, 1, 1, 'TASK_ASSIGNED'),
(4, 2, 2, 2, 'SHORTLISTED'),
(5, 3, 6, 1, 'UNDER_REVIEW');

-- 6. SEED SAMPLE TASKS
INSERT INTO tasks (id, application_id, company_id, student_id, title, description, instructions, deadline) VALUES
(1, 3, 1, 2, 'Build Sample Registration Servlet', 'Create a Java Servlet that accepts student registration parameters and validates input.', 'Use PreparedStatement and return JSON/HTML response with proper HTTP status codes.', '2026-12-15');

-- 7. SEED SAMPLE INTERVIEWS
INSERT INTO interviews (id, application_id, company_id, student_id, interview_date, interview_time, interview_type, meeting_link, interviewer_name, notes) VALUES
(1, 1, 1, 1, '2026-12-20', '10:30:00', 'ONLINE', 'https://meet.google.com/abc-hirehub-xyz', 'Technical Lead - TechNova', 'Prepare to discuss Java Servlets lifecycle, JDBC optimization and project architecture.');

-- 8. SEED SAMPLE MESSAGES
INSERT INTO messages (id, sender_id, receiver_id, application_id, subject, message_text) VALUES
(1, 2, 7, 1, 'Application Shortlisted - Java Full Stack Developer', 'Congratulations Alex! Your application for Java Full Stack Developer at TechNova Solutions has been shortlisted. We have scheduled an online interview.');

-- 9. SEED SAMPLE NOTIFICATIONS
INSERT INTO notifications (id, user_id, title, message, type) VALUES
(1, 7, 'Application Shortlisted', 'Your application for Java Full Stack Developer at TechNova Solutions has been shortlisted!', 'SUCCESS'),
(2, 8, 'Task Assigned', 'TechNova Solutions assigned you a technical task: Build Sample Registration Servlet.', 'INFO');
