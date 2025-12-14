<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Application, models.Job, models.User" %>
<%@ page import="dao.UserDAO, dao.UserDAOImpl" %>

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

// Get employer from session - use employerUser for employers
User employer = (User) session.getAttribute("employerUser");

// If not in session, try generic user attribute
if (employer == null) {
    employer = (User) session.getAttribute("user"); // Fallback to generic user
}

// Optional: If still null, try to fetch using employerId
if (employer == null) {
    try {
        UserDAO userDAO = new UserDAOImpl();
        employer = userDAO.findById(employerId);
        // Verify this is an employer
        if (employer != null && "employer".equalsIgnoreCase(employer.getRole())) {
            session.setAttribute("employerUser", employer); // Store as employerUser
            session.setAttribute("user", employer); // Also store as generic user
        } else if (employer != null) {
            // Wrong role - don't use
            employer = null;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}
    
    Application app = (Application) request.getAttribute("application");
    Job job = (Job) request.getAttribute("job");
    
    // Get seeker from request attribute
    User seeker = (User) request.getAttribute("seeker");
    
    // FIX: If seeker has role "employer" and same ID as employer, fetch from DB using getById
    User actualSeeker = seeker;
    if (app != null && seeker != null && "employer".equals(seeker.getRole())) {
        try {
            UserDAO userDAO = new UserDAOImpl();
            // Try to fetch using getById method (if it exists)
            java.lang.reflect.Method getByIdMethod = null;
            try {
                getByIdMethod = userDAO.getClass().getMethod("getById", int.class);
                if (getByIdMethod != null) {
                    actualSeeker = (User) getByIdMethod.invoke(userDAO, app.getSeekerId());
                }
            } catch (NoSuchMethodException e) {
                // If getById doesn't exist, try findById again (maybe it was cached)
                actualSeeker = userDAO.findById(app.getSeekerId());
            }
        } catch (Exception e) {
            e.printStackTrace();
            actualSeeker = seeker; // Fallback to original seeker
        }
    }
    
    // Final check: if actualSeeker is still employer, show warning
   // Final check: if actualSeeker is still employer, show warning
boolean isSelfApplication = (actualSeeker != null && employer != null && 
                            actualSeeker.getId() == employerId && 
                            "employer".equals(actualSeeker.getRole()));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Application - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    
    <style>
        /* All CSS styles remain exactly the same as before */
        .view-application-container {
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
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 5px;
        }
        
        .page-subtitle {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }
        
        .application-card {
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            padding: 40px;
            box-shadow: var(--shadow-xl);
            border: 1px solid var(--border-light);
        }
        
        .not-found-message {
            text-align: center;
            padding: 60px 40px;
            background: var(--bg-secondary);
            border-radius: var(--radius-xl);
            border: 2px dashed var(--border-light);
        }
        
        .not-found-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-light), var(--secondary-light));
            border-radius: var(--radius-full);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-size: 2rem;
            margin: 0 auto 20px;
        }
        
        .not-found-title {
            font-size: 1.5rem;
            color: var(--text-primary);
            margin-bottom: 10px;
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
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .info-card {
            background: var(--bg-primary);
            border-radius: var(--radius-xl);
            padding: 25px;
            border: 1px solid var(--border-light);
        }
        
        .info-item {
            margin-bottom: 15px;
        }
        
        .info-label {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin-bottom: 5px;
        }
        
        .info-label i {
            color: #8B5CF6;
            width: 20px;
        }
        
        .info-value {
            color: var(--text-primary);
            font-size: 1.1rem;
            font-weight: 500;
            padding-left: 28px;
        }
        
        .message-card {
            background: var(--bg-primary);
            border-radius: var(--radius-xl);
            padding: 25px;
            border: 1px solid var(--border-light);
            margin-bottom: 40px;
        }
        
        .message-content {
            background: var(--bg-secondary);
            border-radius: var(--radius-lg);
            padding: 20px;
            margin-top: 15px;
            white-space: pre-wrap;
            line-height: 1.6;
            color: var(--text-primary);
            max-height: 300px;
            overflow-y: auto;
        }
        
        .cv-section {
            background: var(--bg-primary);
            border-radius: var(--radius-xl);
            padding: 25px;
            border: 1px solid var(--border-light);
            margin-bottom: 40px;
        }
        
        .cv-download {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 24px;
            background: linear-gradient(135deg, #8B5CF6, #6366F1);
            color: white;
            text-decoration: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            transition: all var(--transition-base);
        }
        
        .cv-download:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            background: linear-gradient(135deg, #7C3AED, #4F46E5);
        }
        
        .status-section {
            background: var(--bg-primary);
            border-radius: var(--radius-xl);
            padding: 25px;
            border: 1px solid var(--border-light);
            margin-bottom: 40px;
        }
        
        .current-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: var(--radius-full);
            font-weight: 600;
            font-size: 1rem;
            margin-top: 10px;
        }
        
        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        .status-reviewed {
            background: #dbeafe;
            color: #1e40af;
        }
        
        .status-interview {
            background: #f0f9ff;
            color: #0369a1;
        }
        
        .status-accepted {
            background: #d1fae5;
            color: #065f46;
        }
        
        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid var(--border-light);
        }
        
        .btn-approve {
            flex: 1;
            background: linear-gradient(135deg, #10b981, #059669);
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
            gap: 12px;
        }
        
        .btn-approve:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, #059669, #047857);
        }
        
        .btn-reject {
            flex: 1;
            background: linear-gradient(135deg, #ef4444, #dc2626);
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
            gap: 12px;
        }
        
        .btn-reject:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, #dc2626, #b91c1c);
        }
        
        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 24px;
            background: var(--bg-tertiary);
            color: var(--text-primary);
            text-decoration: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            transition: all var(--transition-base);
            border: 1px solid var(--border-light);
            margin-top: 20px;
        }
        
        .btn-back:hover {
            background: var(--border-light);
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }
        
        .applicant-info-value {
            color: var(--text-primary);
            font-size: 1.1rem;
            font-weight: 500;
            padding-left: 28px;
        }
        
        .no-applicant-info {
            color: var(--text-secondary);
            font-style: italic;
            font-size: 1rem;
            padding-left: 28px;
        }
        
        /* Self-application warning */
        .self-application-warning {
            background: #fff3cd;
            border: 2px solid #ffc107;
            border-radius: var(--radius-lg);
            padding: 20px;
            margin-bottom: 25px;
            color: #856404;
        }
        
        .warning-icon {
            color: #ffc107;
            font-size: 1.5rem;
            margin-right: 10px;
        }
        
        .warning-title {
            font-weight: bold;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
        }
        
        @media (max-width: 992px) {
            .view-application-container {
                padding: 0 15px;
                margin: 20px auto;
            }
            
            .page-icon {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
            }
            
            .application-card {
                padding: 25px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }
        
        @media (max-width: 768px) {
            .application-card {
                padding: 20px;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .info-card, .message-card, .cv-section, .status-section {
                padding: 20px;
            }
        }
        
        @media (max-width: 576px) {
            .page-title {
                font-size: 1.8rem;
            }
            
            .section-title {
                font-size: 1.2rem;
            }
            
            .info-value, .applicant-info-value {
                font-size: 1rem;
            }
            
            .cv-download, .btn-back {
                width: 100%;
                justify-content: center;
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
                    <i class="fas fa-file-alt"></i>
                    <span>View Application</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <div class="view-application-container">
            <% if (app == null || job == null) { %>
                <div class="not-found-message">
                    <div class="not-found-icon">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                    <h3 class="not-found-title">Application Not Found</h3>
                    <p>The application you're looking for doesn't exist or you don't have permission to view it.</p>
                    <a href="<%= contextPath %>/employer/dashboard" class="btn-back">
                        <i class="fas fa-arrow-left"></i>
                        Back to Dashboard
                    </a>
                </div>
            <% } else { %>
                <!-- Self-application warning -->
                <% if (isSelfApplication) { %>
                    <div class="self-application-warning">
                        <div class="warning-title">
                            <i class="fas fa-exclamation-triangle warning-icon"></i>
                            Self-Application Detected
                        </div>
                        <p>This application appears to be from <strong>your own account</strong> (User ID: <%= actualSeeker.getId() %>).</p>
                        <p>This could be:</p>
                        <ul style="margin-left: 20px;">
                            <li>A test application you created</li>
                            <li>An employer applying to their own job posting</li>
                            <li>A data issue where the applicant ID matches the employer ID</li>
                        </ul>
                        <p><strong>Note:</strong> Employers typically cannot apply to their own job postings.</p>
                    </div>
                <% } %>
                
                <!-- Page Header -->
                <div class="page-header-section">
                    <div class="page-header">
                        <div class="page-icon">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <div>
                            <h1 class="page-title">Application Review</h1>
                            <p class="page-subtitle">Review application for: <%= job.getTitle() %></p>
                            <% if (isSelfApplication) { %>
                                <p style="color: #dc3545; font-weight: bold;">
                                    <i class="fas fa-exclamation-circle"></i>
                                    This is a self-application from your own account
                                </p>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Application Card -->
                <div class="application-card">
                    <!-- Job Information Section -->
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <h2 class="section-title">Job Information</h2>
                    </div>
                    
                    <div class="info-grid">
                        <div class="info-card">
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-heading"></i>
                                    Job Title
                                </div>
                                <div class="info-value"><%= job.getTitle() %></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-map-marker-alt"></i>
                                    Location
                                </div>
                                <div class="info-value"><%= job.getLocation() != null ? job.getLocation() : "Not specified" %></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-tag"></i>
                                    Category
                                </div>
                                <div class="info-value"><%= job.getCategory() != null ? job.getCategory() : "Not specified" %></div>
                            </div>
                        </div>
                        
                        <!-- Applicant Information Section -->
                        <div class="info-card">
                            <div class="section-header" style="border: none; margin-bottom: 20px; padding-bottom: 0;">
                                <div class="section-icon" style="width: 40px; height: 40px; font-size: 1rem;">
                                    <i class="fas fa-user"></i>
                                </div>
                                <h3 class="section-title" style="font-size: 1.2rem;">
                                    Applicant Details
                                    <% if (isSelfApplication) { %>
                                        <span style="color: #dc3545; font-size: 0.8rem;">(Self-Application)</span>
                                    <% } %>
                                </h3>
                            </div>
                            
                            <% if (isSelfApplication) { %>
                                <div style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 5px; padding: 10px; margin-bottom: 15px; font-size: 12px;">
                                    <strong><i class="fas fa-info-circle"></i> Information:</strong> 
                                    This application is from your own employer account. 
                                    <br>Applicant User ID: <%= actualSeeker.getId() %>
                                    <br>Applicant Role: <%= actualSeeker.getRole() %>
                                </div>
                            <% } %>
                            
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-user-circle"></i>
                                    Name
                                </div>
                                <% if (actualSeeker != null && actualSeeker.getName() != null && !actualSeeker.getName().isEmpty()) { %>
                                    <div class="applicant-info-value">
                                        <%= actualSeeker.getName() %>
                                        <% if (isSelfApplication) { %>
                                            <span style="color: #dc3545; font-size: 0.9rem;">
                                                (Your account)
                                            </span>
                                        <% } %>
                                    </div>
                                <% } else { %>
                                    <div class="no-applicant-info">Not provided</div>
                                <% } %>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-envelope"></i>
                                    Email
                                </div>
                                <% if (actualSeeker != null && actualSeeker.getEmail() != null && !actualSeeker.getEmail().isEmpty()) { %>
                                    <div class="applicant-info-value">
                                        <%= actualSeeker.getEmail() %>
                                        <% if (isSelfApplication) { %>
                                            <span style="color: #dc3545; font-size: 0.9rem;">
                                                (Your email)
                                            </span>
                                        <% } %>
                                    </div>
                                <% } else { %>
                                    <div class="no-applicant-info">Not available</div>
                                <% } %>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-phone"></i>
                                    Phone
                                </div>
                                <% if (actualSeeker != null && actualSeeker.getPhone() != null && !actualSeeker.getPhone().isEmpty()) { %>
                                    <div class="applicant-info-value">
                                        <%= actualSeeker.getPhone() %>
                                        <% if (isSelfApplication) { %>
                                            <span style="color: #dc3545; font-size: 0.9rem;">
                                                (Your phone)
                                            </span>
                                        <% } %>
                                    </div>
                                <% } else { %>
                                    <div class="no-applicant-info">Not provided</div>
                                <% } %>
                            </div>
                            
                            <% if (actualSeeker != null) { %>
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-id-card"></i>
                                        User Role
                                    </div>
                                    <div class="applicant-info-value">
                                        <span style="text-transform: capitalize; font-weight: bold;">
                                            <%= actualSeeker.getRole() %>
                                        </span>
                                        <% if ("employer".equals(actualSeeker.getRole())) { %>
                                            <span style="color: #dc3545; font-size: 0.9rem;">
                                                (Note: Employers don't usually apply for jobs)
                                            </span>
                                        <% } %>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    
                    <!-- Application Details Section -->
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <h2 class="section-title">Application Details</h2>
                    </div>
                    
                    <div class="info-grid">
                        <div class="info-card">
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-calendar-alt"></i>
                                    Applied At
                                </div>
                                <div class="info-value"><%= app.getAppliedAt() != null ? app.getAppliedAt() : "N/A" %></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-info-circle"></i>
                                    Current Status
                                </div>
                                <div class="info-value">
                                    <% 
                                        String status = app.getStatus() != null ? app.getStatus().toLowerCase() : "pending";
                                        String statusClass = "current-status ";
                                        if (status.contains("pending")) {
                                            statusClass += "status-pending";
                                        } else if (status.contains("review")) {
                                            statusClass += "status-reviewed";
                                        } else if (status.contains("interview")) {
                                            statusClass += "status-interview";
                                        } else if (status.contains("accept")) {
                                            statusClass += "status-accepted";
                                        } else if (status.contains("reject")) {
                                            statusClass += "status-rejected";
                                        } else {
                                            statusClass += "status-pending";
                                        }
                                    %>
                                    <span class="<%= statusClass %>">
                                        <i class="fas fa-circle"></i>
                                        <%= app.getStatus() != null ? app.getStatus() : "Pending" %>
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <% if (app.getCvPath() != null && !app.getCvPath().trim().isEmpty()) { %>
                            <div class="info-card">
                                <div class="section-header" style="border: none; margin-bottom: 20px; padding-bottom: 0;">
                                    <div class="section-icon" style="width: 40px; height: 40px; font-size: 1rem;">
                                        <i class="fas fa-file-pdf"></i>
                                    </div>
                                    <h3 class="section-title" style="font-size: 1.2rem;">Attached CV</h3>
                                </div>
                                
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-paperclip"></i>
                                        CV Document
                                    </div>
                                    <div class="info-value">
                                        <a href="<%= contextPath + "/" + app.getCvPath() %>" 
                                           target="_blank" 
                                           class="cv-download">
                                            <i class="fas fa-download"></i>
                                             Open CV
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                    
                    <!-- Applicant Message Section -->
                    <% if (app.getMessage() != null && !app.getMessage().trim().isEmpty()) { %>
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-comment-alt"></i>
                            </div>
                            <h2 class="section-title">Applicant's Message</h2>
                        </div>
                        
                        <div class="message-card">
                            <div class="info-label">
                                <i class="fas fa-quote-left"></i>
                                Cover Letter / Message
                            </div>
                            <div class="message-content">
                                <%= app.getMessage() %>
                                <% if (isSelfApplication) { %>
                                    <div style="margin-top: 15px; padding: 10px; background: #f8f9fa; border-radius: 5px; font-style: italic;">
                                        <i class="fas fa-info-circle"></i>
                                        This message is from your own account.
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                    
                    <!-- Action Buttons Section -->
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                        <h2 class="section-title">Application Actions</h2>
                    </div>
                    
                    <div class="action-buttons">
                        <!-- Approve form -->
                        <form action="<%= contextPath %>/employer/updateApplicationStatus" method="post" class="approve-form">
                            <input type="hidden" name="id" value="<%= app.getId() %>">
                            <input type="hidden" name="action" value="approve">
                            <button type="submit" class="btn-approve" onclick="return confirm('Approve this application?')">
                                <i class="fas fa-check-circle"></i>
                                Approve Application
                            </button>
                        </form>
                        
                        <!-- Reject form -->
                        <form action="<%= contextPath %>/employer/updateApplicationStatus" method="post" class="reject-form">
                            <input type="hidden" name="id" value="<%= app.getId() %>">
                            <input type="hidden" name="action" value="reject">
                            <button type="submit" class="btn-reject" onclick="return confirm('Reject this application?')">
                                <i class="fas fa-times-circle"></i>
                                Reject Application
                            </button>
                        </form>
                    </div>
                    
                    <!-- Back Button -->
                    <div style="text-align: center; margin-top: 30px;">
                        <a href="<%= contextPath %>/employer/dashboard" class="btn-back">
                            <i class="fas fa-arrow-left"></i>
                            Back to Dashboard
                        </a>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - View Application. All rights reserved.</p>
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

    <!-- JavaScript -->
    <script>
    /**
     * View Application JavaScript
     * ES5 Compatible for Eclipse
     */
    
    var ViewApplication = {
        init: function() {
            this.setupThemeToggle();
            this.setupConfirmations();
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
        
        setupConfirmations: function() {
            var approveButtons = document.querySelectorAll('.btn-approve');
            var rejectButtons = document.querySelectorAll('.btn-reject');
            
            for (var i = 0; i < approveButtons.length; i++) {
                approveButtons[i].addEventListener('click', function(e) {
                    if (!confirm('Approve this application?')) {
                        e.preventDefault();
                    }
                });
            }
            
            for (var i = 0; i < rejectButtons.length; i++) {
                rejectButtons[i].addEventListener('click', function(e) {
                    if (!confirm('Reject this application?')) {
                        e.preventDefault();
                    }
                });
            }
        }
    };
    
    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            ViewApplication.init();
        });
    } else {
        ViewApplication.init();
    }
    </script>
</body>
</html>