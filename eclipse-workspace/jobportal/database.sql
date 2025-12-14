/* ----------------------------
   Job Portal - Full Professional Schema
   MySQL / MariaDB (utf8mb4, InnoDB)
   Save as: job_portal_schema.sql
   ---------------------------- */

SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS job_portal;
CREATE DATABASE job_portal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE job_portal;

-- USERS: job seekers, employers and admins
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,         -- store hashed passwords (bcrypt/argon2)
  role ENUM('seeker','employer','admin') NOT NULL DEFAULT 'seeker',
  status ENUM('pending','approved','active','suspended') NOT NULL DEFAULT 'active',
  phone VARCHAR(30),
  avatar_path VARCHAR(512),               -- optional user photo
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- EMPLOYER PROFILE (one-to-one with users where role='employer')
CREATE TABLE employer_profiles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  company_name VARCHAR(255) NOT NULL,
  website VARCHAR(255),
  bio TEXT,
  address VARCHAR(255),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_employer_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- JOBS posted by employers
CREATE TABLE jobs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employer_id INT NOT NULL,               -- references users.id (employer)
  title VARCHAR(255) NOT NULL,
  description MEDIUMTEXT,
  location VARCHAR(200),
  category VARCHAR(100),
  employment_type ENUM('full-time','part-time','contract','internship','temporary') DEFAULT 'full-time',
  salary VARCHAR(100),
  email_to_apply VARCHAR(255),            -- visible contact email (optional)
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_job_employer FOREIGN KEY (employer_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- APPLICATIONS sent by job seekers for jobs
CREATE TABLE applications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  job_id INT NOT NULL,
  seeker_id INT NOT NULL,                 -- references users.id (seeker)
  message TEXT,
  cv_path VARCHAR(512),                   -- uploaded CV file path (optional)
  status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_application_job FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
  CONSTRAINT fk_application_seeker FOREIGN KEY (seeker_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- SEEKER CV (structured CV builder)
CREATE TABLE seeker_cv (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  headline VARCHAR(255),
  about TEXT,
  education JSON,                         -- JSON for flexible structured fields (list)
  experience JSON,                        -- JSON for flexible structured fields (list)
  skills JSON,                            -- JSON array of skills
  attachments JSON,                       -- JSON array of file paths
  saved_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_seeker_cv_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- CV TEMPLATES managed by Admin
CREATE TABLE cv_templates (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  description VARCHAR(400),
  file_path VARCHAR(512),                 -- template file (docx/html) path
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- JOB ALERTS (optional feature for seekers)
CREATE TABLE job_alerts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  keywords VARCHAR(500),
  location VARCHAR(200),
  frequency ENUM('daily','weekly','monthly') DEFAULT 'daily',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_job_alert_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- INDEXES for faster searching
CREATE INDEX idx_jobs_title ON jobs(title);
CREATE INDEX idx_jobs_location ON jobs(location);
CREATE INDEX idx_jobs_category ON jobs(category);
CREATE INDEX idx_applications_job ON applications(job_id);
CREATE INDEX idx_applications_seeker ON applications(seeker_id);

-- Insert a default admin (change password immediately)
-- NOTE: Replace 'admin@example.com' and plaintext password before production.
INSERT INTO users (name, email, password, role, status)
VALUES ('System Admin', 'admin@example.com', 'admin123', 'admin', 'active');

SET FOREIGN_KEY_CHECKS = 1;
