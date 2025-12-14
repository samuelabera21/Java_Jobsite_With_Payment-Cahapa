<%@ page import="dao.JobDAO, dao.JobDAOImpl, java.sql.*, models.Job" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String contextPath = request.getContextPath();
    String jobIdStr = request.getParameter("job_id");
    if (jobIdStr == null) {
        response.sendRedirect(contextPath + "/seeker/viewJobs.jsp");
        return;
    }
    int jobId = Integer.parseInt(jobIdStr);

    JobDAO jobDAO = new JobDAOImpl();
    models.Job job = jobDAO.getById(jobId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Job - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    <style>
        /* Additional styles for apply job page */
        .apply-job-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .job-details-card {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-light);
        }
        
        .job-header {
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--border-light);
        }
        
        .job-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .job-title i {
            color: var(--primary);
        }
        
        .job-info {
            margin-top: 20px;
        }
        
        .job-info-item {
            margin-bottom: 15px;
            color: var(--text-secondary);
        }
        
        .job-info-item strong {
            color: var(--text-primary);
            margin-right: 8px;
        }
        
        .job-description {
            background: var(--bg-secondary);
            border-radius: var(--radius-lg);
            padding: 25px;
            margin: 25px 0;
            border: 1px solid var(--border-light);
        }
        
        .job-description strong {
            color: var(--text-primary);
            display: block;
            margin-bottom: 15px;
            font-size: 1.1rem;
        }
        
        .job-description pre {
            color: var(--text-secondary);
            line-height: 1.7;
            white-space: pre-wrap;
            font-family: inherit;
            font-size: 1rem;
            margin: 0;
        }
        
        .application-form-card {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            padding: 35px;
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-light);
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .form-header h2 {
            font-size: 1.8rem;
            color: var(--text-primary);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .form-header h2 i {
            color: var(--primary);
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            color: var(--text-primary);
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 1rem;
        }
        
        .form-label i {
            color: var(--primary);
            margin-right: 8px;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 18px;
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
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            background: var(--bg-primary);
        }
        
        textarea.form-control {
            min-height: 200px;
            resize: vertical;
        }
        
        .form-control[type="file"] {
            padding: 12px;
            cursor: pointer;
        }
        
        .form-control[type="file"]::file-selector-button {
            background: var(--bg-tertiary);
            color: var(--text-primary);
            border: 1px solid var(--border-light);
            padding: 8px 16px;
            border-radius: var(--radius-md);
            margin-right: 15px;
            cursor: pointer;
            transition: all var(--transition-base);
        }
        
        .form-control[type="file"]::file-selector-button:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }
        
        .file-requirements {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-top: 8px;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 40px;
            padding-top: 25px;
            border-top: 1px solid var(--border-light);
        }
        
        .btn-apply {
            flex: 1;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 16px;
            border: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all var(--transition-base);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-apply:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, var(--primary-dark), var(--secondary));
        }
        
        .back-links {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--border-light);
        }
        
        .back-link {
            color: var(--text-secondary);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: var(--radius-lg);
            transition: all var(--transition-base);
        }
        
        .back-link:hover {
            color: var(--primary);
            background: var(--bg-secondary);
        }
        
        @media (max-width: 768px) {
            .apply-job-container {
                padding: 0 15px;
                margin: 20px auto;
            }
            
            .job-details-card,
            .application-form-card {
                padding: 20px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .back-links {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
    <!-- Main Container -->
    <div class="dashboard-container">
        <!-- Header -->
        <header class="dashboard-header">
            <a href="<%= contextPath %>/seeker/dashboard" class="back-home">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Dashboard</span>
            </a>
            
            <div class="header-controls">
                <div class="current-date">
                    <i class="fas fa-calendar-alt"></i>
                    <span>Apply for Job</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <div class="apply-job-container">
            <!-- Job Details Card -->
            <div class="job-details-card">
                <div class="job-header">
                    <h2 class="job-title">
                        <i class="fas fa-briefcase"></i>
                        Apply for: <%= job != null ? job.getTitle() : "Job" %>
                    </h2>
                </div>

                <% if (job != null) { %>
                    <div class="job-info">
                        <div class="job-info-item">
                            <strong>Company:</strong> <!-- optionally fetch company name through employer profile -->
                        </div>
                        <div class="job-info-item">
                            <strong>Location:</strong> <%= job.getLocation() %>
                        </div>
                    </div>
                    
                    <div class="job-description">
                        <strong>Description:</strong>
                        <pre><%= job.getDescription() %></pre>
                    </div>
                <% } %>
            </div>

            <!-- Application Form Card -->
            <div class="application-form-card">
                <div class="form-header">
                    <h2><i class="fas fa-edit"></i> Complete Your Application</h2>
                    <p style="color: var(--text-secondary);">Fill in the details below to apply for this position</p>
                </div>

                <form action="<%= contextPath %>/seeker/applyJob"
                      method="post"
                      enctype="multipart/form-data"
                      id="applicationForm">

                    <input type="hidden" name="job_id" value="<%= jobId %>">

                    <div class="form-group">
                        <label for="message" class="form-label">
                            <i class="fas fa-comment"></i> Cover Letter / Message
                        </label>
                        <textarea id="message" 
                                  name="message" 
                                  class="form-control" 
                                  rows="8" 
                                  placeholder="Write your cover letter here..."
                                  required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="cv" class="form-label">
                            <i class="fas fa-file-upload"></i> Upload CV (PDF / DOC / DOCX)
                        </label>
                        <input type="file" 
                               id="cv" 
                               name="cv" 
                               class="form-control" 
                               accept=".pdf,.doc,.docx" 
                               required>
                        <div class="file-requirements">
                            <i class="fas fa-info-circle"></i>
                            Accepted formats: PDF, DOC, DOCX
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-apply">
                            <i class="fas fa-paper-plane"></i>
                            Submit Application
                        </button>
                    </div>
                </form>

                <div class="back-links">
                    <a href="<%= contextPath %>/seeker/profile" class="back-link">
                        <i class="fas fa-user"></i>
                        Back to Profile
                    </a>
                    <a href="<%= request.getContextPath() %>/seeker/viewJobs" class="back-link">
                        <i class="fas fa-briefcase"></i>
                        Back to Jobs
                    </a>
                    
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - Job Application. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/seeker/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/viewJobs.jsp"><i class="fas fa-briefcase"></i> View Jobs</a>
                <span>•</span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- JavaScript -->
    <script>
    /**
     * Apply Job Page JavaScript
     * ES5 Compatible for Eclipse
     */
    
    var ApplyJob = {
        init: function() {
            this.setupThemeToggle();
            this.setupFormValidation();
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
            var form = document.getElementById('applicationForm');
            if (!form) return;
            
            form.addEventListener('submit', function(e) {
                var fileInput = document.getElementById('cv');
                var messageInput = document.getElementById('message');
                
                // Validate message
                if (!messageInput.value.trim()) {
                    e.preventDefault();
                    alert('Please write a cover letter message');
                    messageInput.focus();
                    return;
                }
                
                // Validate file
                if (!fileInput.files || fileInput.files.length === 0) {
                    e.preventDefault();
                    alert('Please upload your CV');
                    return;
                }
                
                var file = fileInput.files[0];
                var allowedTypes = ['application/pdf', 
                                    'application/msword', 
                                    'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
                var maxSize = 5 * 1024 * 1024; // 5MB
                
                if (!allowedTypes.includes(file.type)) {
                    e.preventDefault();
                    alert('Please upload PDF, DOC, or DOCX files only');
                    return;
                }
                
                if (file.size > maxSize) {
                    e.preventDefault();
                    alert('File size should be less than 5MB');
                    return;
                }
                
                // Show loading
                ApplyJob.showLoading();
            });
        },
        
        showLoading: function() {
            // Create a simple loading overlay
            var overlay = document.createElement('div');
            overlay.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); display: flex; align-items: center; justify-content: center; z-index: 1000;';
            overlay.innerHTML = '<div style="background: white; padding: 30px; border-radius: 10px; text-align: center;"><i class="fas fa-spinner fa-spin" style="font-size: 2rem; color: var(--primary);"></i><p style="margin-top: 15px;">Submitting Application...</p></div>';
            overlay.id = 'loadingOverlay';
            document.body.appendChild(overlay);
            document.body.style.overflow = 'hidden';
        }
    };
    
    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            ApplyJob.init();
        });
    } else {
        ApplyJob.init();
    }
    </script>
</body>
</html>