<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.UserDAOImpl" %>

<%

String contextPath = request.getContextPath();

// ========== SECURITY CHECK ==========
// Verify this is an employer
Integer employerId = (Integer) session.getAttribute("employerId");
if (employerId == null) {
    // Not logged in as employer - redirect to login
    response.sendRedirect(contextPath + "/views/auth/login.jsp");
    return;
}
// ========== END SECURITY CHECK ==========

// Get user from session - use employerUser for employers
User user = (User) session.getAttribute("employerUser");

// If not in session, try generic user attribute
if (user == null) {
    user = (User) session.getAttribute("user"); // Fallback to generic user
}

// Optional: If still null, try to fetch using employerId
if (user == null) {
    try {
        UserDAO userDAO = new UserDAOImpl();
        user = userDAO.findById(employerId);
        // Verify this is an employer
        if (user != null && "employer".equalsIgnoreCase(user.getRole())) {
            session.setAttribute("employerUser", user); // Store as employerUser
            session.setAttribute("user", user); // Also store as generic user
        } else if (user != null) {
            // Wrong role - don't use
            user = null;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}

    
    // Check for error parameter
    String errorParam = request.getParameter("error");
    boolean hasError = errorParam != null && errorParam.equals("1");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post New Job - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    
    <style>
        /* Additional styles for Post Job page */
        .post-job-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-header-section {
            margin-bottom: 40px;
        }
        
        .page-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 15px;
        }
        
        .page-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #8B5CF6, #6366F1);
            border-radius: var(--radius-xl);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
        }
        
        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 5px;
        }
        
        .page-subtitle {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }
        
        .form-card {
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            padding: 40px;
            box-shadow: var(--shadow-xl);
            border: 1px solid var(--border-light);
            max-width: 900px;
            margin: 0 auto;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--border-light);
        }
        
        .form-header h3 {
            font-size: 1.8rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .form-header h3 i {
            color: #8B5CF6;
        }
        
        .form-section {
            margin-bottom: 35px;
        }
        
        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--border-light);
        }
        
        .section-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #8B5CF6, #6366F1);
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        
        .section-title {
            font-size: 1.4rem;
            color: var(--text-primary);
            font-weight: 600;
        }
        
        .section-description {
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin-top: 5px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            color: var(--text-primary);
            font-weight: 600;
            margin-bottom: 12px;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-label i {
            color: #8B5CF6;
            width: 20px;
        }
        
        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 1px solid var(--border-light);
            border-radius: var(--radius-lg);
            background: var(--bg-secondary);
            color: var(--text-primary);
            font-size: 1rem;
            transition: all var(--transition-base);
            font-family: inherit;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #8B5CF6;
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
            background: var(--bg-primary);
        }
        
        textarea.form-control {
            min-height: 150px;
            resize: vertical;
            line-height: 1.6;
        }
        
        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%236b7280' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 20px center;
            background-size: 16px;
            padding-right: 50px;
        }
        
        .form-hint {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
            padding-left: 30px;
        }
        
        .form-hint i {
            color: #8B5CF6;
        }
        
        .input-with-icon {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 1.1rem;
        }
        
        .input-with-icon .form-control {
            padding-left: 50px;
        }
        
        .type-options {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 10px;
        }
        
        .type-option {
            position: relative;
        }
        
        .type-option input {
            position: absolute;
            opacity: 0;
        }
        
        .type-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px 15px;
            background: var(--bg-secondary);
            border: 2px solid var(--border-light);
            border-radius: var(--radius-lg);
            cursor: pointer;
            transition: all var(--transition-base);
            text-align: center;
        }
        
        .type-option input:checked + .type-label {
            background: rgba(139, 92, 246, 0.1);
            border-color: #8B5CF6;
            color: #8B5CF6;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .type-icon {
            width: 40px;
            height: 40px;
            background: var(--bg-tertiary);
            border-radius: var(--radius-full);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            color: var(--text-primary);
            margin-bottom: 10px;
            transition: all var(--transition-base);
        }
        
        .type-option input:checked + .type-label .type-icon {
            background: #8B5CF6;
            color: white;
        }
        
        .type-name {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .character-count {
            text-align: right;
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-top: 5px;
        }
        
        .error-alert {
            background: #fee2e2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 15px 20px;
            border-radius: var(--radius-lg);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .error-alert i {
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 50px;
            padding-top: 30px;
            border-top: 1px solid var(--border-light);
        }
        
        .btn-submit {
            flex: 2;
            background: linear-gradient(135deg, #8B5CF6, #6366F1);
            color: white;
            padding: 18px;
            border: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all var(--transition-base);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }
        
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, #7C3AED, #4F46E5);
        }
        
        .btn-cancel {
            flex: 1;
            background: var(--bg-tertiary);
            color: var(--text-primary);
            padding: 18px;
            border: 1px solid var(--border-light);
            border-radius: var(--radius-lg);
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all var(--transition-base);
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            text-align: center;
        }
        
        .btn-cancel:hover {
            background: var(--border-light);
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }
        
        @media (max-width: 992px) {
            .post-job-container {
                padding: 0 15px;
                margin: 20px auto;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .page-icon {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
            }
            
            .form-card {
                padding: 25px;
            }
            
            .type-options {
                grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn-submit, .btn-cancel {
                flex: 1;
                width: 100%;
            }
        }
        
        @media (max-width: 768px) {
            .form-card {
                padding: 20px;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .section-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .type-options {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 576px) {
            .page-title {
                font-size: 1.8rem;
            }
            
            .form-header h3 {
                font-size: 1.4rem;
            }
            
            .form-control {
                padding: 14px 16px;
            }
            
            .input-with-icon .form-control {
                padding-left: 45px;
            }
            
            .input-icon {
                left: 16px;
            }
            
            .type-options {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Main Container -->
    <div class="dashboard-container">
        <!-- Header -->
        <header class="dashboard-header">
            <a href="<%= contextPath %>/employer/dashboard" class="back-home">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Dashboard</span>
            </a>
            
            <div class="header-controls">
                <div class="current-date">
                    <i class="fas fa-plus-circle"></i>
                    <span>Post New Job</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <div class="post-job-container">
            <!-- Page Header -->
            <div class="page-header-section">
                <div class="page-header">
                    <div class="page-icon">
                        <i class="fas fa-plus-circle"></i>
                    </div>
                    <div>
                        <h1 class="page-title">Post New Job</h1>
                        <p class="page-subtitle">Create a job listing to attract qualified candidates</p>
                    </div>
                </div>
            </div>

            <!-- Form Card -->
            <div class="form-card">
                <!-- EXACT SAME FORM ACTION AND FIELDS AS ORIGINAL -->
                <form action="<%= contextPath %>/employer/postJob" method="post" id="postJobForm">
                    
                    <div class="form-header">
                        <h3>
                            <i class="fas fa-briefcase"></i>
                            Job Details
                        </h3>
                    </div>
                    
                    <% if (hasError) { %>
                        <div class="error-alert">
                            <i class="fas fa-exclamation-circle"></i>
                            <div>
                                <strong>Error creating job</strong>
                                <p>There was an error posting your job. Please try again.</p>
                            </div>
                        </div>
                    <% } %>
                    
                    <!-- Job Basics Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-info-circle"></i>
                            </div>
                            <div>
                                <div class="section-title">Job Basics</div>
                                <div class="section-description">Enter the basic information about your job</div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="title" class="form-label">
                                <i class="fas fa-heading"></i>
                                Job Title *
                            </label>
                            <div class="input-with-icon">
                                <i class="fas fa-briefcase input-icon"></i>
                                <input type="text" 
                                       id="title" 
                                       name="title" 
                                       class="form-control" 
                                       placeholder="e.g., Senior Software Engineer"
                                       required
                                       maxlength="200">
                            </div>
                            <div class="character-count" id="titleCount">
                                0 / 200 characters
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="description" class="form-label">
                                <i class="fas fa-align-left"></i>
                                Description *
                            </label>
                            <textarea id="description" 
                                      name="description" 
                                      class="form-control" 
                                      placeholder="Describe the job responsibilities, requirements, and what makes your company great..."
                                      required
                                      maxlength="2000"></textarea>
                            <div class="character-count" id="descriptionCount">
                                0 / 2000 characters
                            </div>
                        </div>
                    </div>
                    
                    <!-- Location & Category Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div>
                                <div class="section-title">Location & Category</div>
                                <div class="section-description">Where is the job located and what category does it belong to?</div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="location" class="form-label">
                                <i class="fas fa-globe"></i>
                                Location
                            </label>
                            <div class="input-with-icon">
                                <i class="fas fa-map-pin input-icon"></i>
                                <input type="text" 
                                       id="location" 
                                       name="location" 
                                       class="form-control" 
                                       placeholder="e.g., New York, Remote, Hybrid"
                                       maxlength="100">
                            </div>
                            <div class="character-count" id="locationCount">
                                0 / 100 characters
                            </div>
                            <div class="form-hint">
                                <i class="fas fa-lightbulb"></i>
                                <span>Leave empty for "Anywhere" or "Remote"</span>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="category" class="form-label">
                                <i class="fas fa-tag"></i>
                                Category
                            </label>
                            <div class="input-with-icon">
                                <i class="fas fa-layer-group input-icon"></i>
                                <input type="text" 
                                       id="category" 
                                       name="category" 
                                       class="form-control" 
                                       placeholder="e.g., Software Development, Marketing, Sales"
                                       maxlength="100">
                            </div>
                            <div class="character-count" id="categoryCount">
                                0 / 100 characters
                            </div>
                        </div>
                    </div>
                    
                    <!-- Employment Details Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div>
                                <div class="section-title">Employment Details</div>
                                <div class="section-description">Specify the job type and compensation</div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-calendar-alt"></i>
                                Employment Type
                            </label>
                            
                            <!-- Visual Type Options -->
                            <div class="type-options">
                                <div class="type-option">
                                    <input type="radio" id="type-full-time" name="employment_type" value="full-time" checked>
                                    <label for="type-full-time" class="type-label">
                                        <div class="type-icon">
                                            <i class="fas fa-business-time"></i>
                                        </div>
                                        <div class="type-name">Full Time</div>
                                    </label>
                                </div>
                                
                                <div class="type-option">
                                    <input type="radio" id="type-part-time" name="employment_type" value="part-time">
                                    <label for="type-part-time" class="type-label">
                                        <div class="type-icon">
                                            <i class="fas fa-clock"></i>
                                        </div>
                                        <div class="type-name">Part Time</div>
                                    </label>
                                </div>
                                
                                <div class="type-option">
                                    <input type="radio" id="type-contract" name="employment_type" value="contract">
                                    <label for="type-contract" class="type-label">
                                        <div class="type-icon">
                                            <i class="fas fa-file-contract"></i>
                                        </div>
                                        <div class="type-name">Contract</div>
                                    </label>
                                </div>
                                
                                <div class="type-option">
                                    <input type="radio" id="type-internship" name="employment_type" value="internship">
                                    <label for="type-internship" class="type-label">
                                        <div class="type-icon">
                                            <i class="fas fa-user-graduate"></i>
                                        </div>
                                        <div class="type-name">Internship</div>
                                    </label>
                                </div>
                                
                                <div class="type-option">
                                    <input type="radio" id="type-temporary" name="employment_type" value="temporary">
                                    <label for="type-temporary" class="type-label">
                                        <div class="type-icon">
                                            <i class="fas fa-calendar-day"></i>
                                        </div>
                                        <div class="type-name">Temporary</div>
                                    </label>
                                </div>
                            </div>
                            
                            <!-- Original select (hidden, for fallback) -->
                            <select name="employment_type" class="form-control" style="display: none;">
                                <option value="full-time" selected>Full Time</option>
                                <option value="part-time">Part Time</option>
                                <option value="contract">Contract</option>
                                <option value="internship">Internship</option>
                                <option value="temporary">Temporary</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="salary" class="form-label">
                                <i class="fas fa-money-bill-wave"></i>
                                Salary
                            </label>
                            <div class="input-with-icon">
                                <i class="fas fa-dollar-sign input-icon"></i>
                                <input type="text" 
                                       id="salary" 
                                       name="salary" 
                                       class="form-control" 
                                       placeholder="e.g., $80,000 - $100,000 per year"
                                       maxlength="100">
                            </div>
                            <div class="character-count" id="salaryCount">
                                0 / 100 characters
                            </div>
                            <div class="form-hint">
                                <i class="fas fa-lightbulb"></i>
                                <span>Include currency and time period (e.g., per year, per hour)</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Application Details Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div>
                                <div class="section-title">Application Details</div>
                                <div class="section-description">How should candidates apply for this job?</div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="email_to_apply" class="form-label">
                                <i class="fas fa-at"></i>
                                Email to Apply
                            </label>
                            <div class="input-with-icon">
                                <i class="fas fa-envelope input-icon"></i>
                                <input type="email" 
                                       id="email_to_apply" 
                                       name="email_to_apply" 
                                       class="form-control" 
                                       placeholder="careers@yourcompany.com"
                                       maxlength="100">
                            </div>
                            <div class="character-count" id="emailCount">
                                0 / 100 characters
                            </div>
                            <div class="form-hint">
                                <i class="fas fa-lightbulb"></i>
                                <span>Enter the email address where candidates should send applications</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Form Actions -->
                    <div class="form-actions">
                        <a href="<%= contextPath %>/employer/dashboard" class="btn-cancel">
                            <i class="fas fa-times"></i>
                            Cancel
                        </a>
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-paper-plane"></i>
                            Post Job
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - Post Job. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/employer/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span>•</span>
                <a href="<%= contextPath %>/employer/profile"><i class="fas fa-user-edit"></i> Profile</a>
                <span>•</span>
                <a href="<%= contextPath %>/employer/postJob"><i class="fas fa-plus-circle"></i> Post Job</a>
                <span>•</span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <i class="fas fa-cog fa-spin"></i>
            <p>Posting Job...</p>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
    /**
     * Post Job JavaScript
     * ES5 Compatible for Eclipse
     */
    
    var PostJob = {
        init: function() {
            this.setupThemeToggle();
            this.setupFormValidation();
            this.setupCharacterCounters();
            this.setupTypeSelection();
        },
        
        setupThemeToggle: function() {
            var themeToggle = document.getElementById('themeToggle');
            if (!themeToggle) return;
            
            themeToggle.addEventListener('click', function() {
                var body = document.body;
                
                if (body.classList.contains('dark')) {
                    body.classList.remove('dark');
                    localStorage.setItem('seekerTheme', 'light');
                    this.innerHTML = '<i class="fas fa-moon"></i><span>Dark Mode</span>';
                } else {
                    body.classList.add('dark');
                    localStorage.setItem('seekerTheme', 'dark');
                    this.innerHTML = '<i class="fas fa-sun"></i><span>Light Mode</span>';
                }
            });
            
            // Apply saved theme
            var savedTheme = localStorage.getItem('seekerTheme');
            if (savedTheme === 'dark') {
                document.body.classList.add('dark');
                themeToggle.innerHTML = '<i class="fas fa-sun"></i><span>Light Mode</span>';
            }
        },
        
        setupFormValidation: function() {
            var form = document.getElementById('postJobForm');
            if (!form) return;
            
            form.addEventListener('submit', function(e) {
                var title = document.getElementById('title').value.trim();
                var description = document.getElementById('description').value.trim();
                
                // Basic validation
                if (title.length === 0) {
                    e.preventDefault();
                    alert('Please enter a job title.');
                    document.getElementById('title').focus();
                    return;
                }
                
                if (description.length === 0) {
                    e.preventDefault();
                    alert('Please enter a job description.');
                    document.getElementById('description').focus();
                    return;
                }
                
                // Show loading
                PostJob.showLoading();
            });
        },
        
        setupCharacterCounters: function() {
            var titleInput = document.getElementById('title');
            var descriptionInput = document.getElementById('description');
            var locationInput = document.getElementById('location');
            var categoryInput = document.getElementById('category');
            var salaryInput = document.getElementById('salary');
            var emailInput = document.getElementById('email_to_apply');
            
            var inputs = [
                {input: titleInput, counter: 'titleCount', max: 200},
                {input: descriptionInput, counter: 'descriptionCount', max: 2000},
                {input: locationInput, counter: 'locationCount', max: 100},
                {input: categoryInput, counter: 'categoryCount', max: 100},
                {input: salaryInput, counter: 'salaryCount', max: 100},
                {input: emailInput, counter: 'emailCount', max: 100}
            ];
            
            for (var i = 0; i < inputs.length; i++) {
                var item = inputs[i];
                if (item.input) {
                    item.input.addEventListener('input', function() {
                        var matchingItem = inputs.find(function(it) {
                            return it.input.id === this.id;
                        }.bind(this));
                        if (matchingItem) {
                            document.getElementById(matchingItem.counter).textContent = 
                                this.value.length + ' / ' + matchingItem.max + ' characters';
                        }
                    });
                    // Initialize count
                    document.getElementById(item.counter).textContent = 
                        item.input.value.length + ' / ' + item.max + ' characters';
                }
            }
        },
        
        setupTypeSelection: function() {
            var radioOptions = document.querySelectorAll('.type-option input[type="radio"]');
            var hiddenSelect = document.querySelector('select[name="employment_type"]');
            
            if (radioOptions.length > 0 && hiddenSelect) {
                // Sync radio selection with hidden select
                for (var i = 0; i < radioOptions.length; i++) {
                    radioOptions[i].addEventListener('change', function() {
                        hiddenSelect.value = this.value;
                    });
                }
                
                // Set initial value
                var checkedRadio = document.querySelector('.type-option input[type="radio"]:checked');
                if (checkedRadio) {
                    hiddenSelect.value = checkedRadio.value;
                }
            }
        },
        
        showLoading: function() {
            var overlay = document.getElementById('loadingOverlay');
            if (!overlay) {
                overlay = document.createElement('div');
                overlay.id = 'loadingOverlay';
                overlay.className = 'loading-overlay';
                overlay.innerHTML = '<div class="loading-spinner"><i class="fas fa-cog fa-spin"></i><p>Posting Job...</p></div>';
                document.body.appendChild(overlay);
            }
            overlay.style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }
    };
    
    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            PostJob.init();
        });
    } else {
        PostJob.init();
    }
    </script>
</body>
</html>