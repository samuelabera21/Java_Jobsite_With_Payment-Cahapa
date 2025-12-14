<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Job, models.Application, models.User" %>
<%@ page import="dao.UserDAO, dao.UserDAOImpl" %>
<%@ page import="dao.EmployerProfileDAO, dao.EmployerProfileDAOImpl" %>
<%@ page import="models.EmployerProfile" %>

<%
    String contextPath = request.getContextPath();
    
    // ========== SECURITY CHECK ==========
    // Verify this is an employer
    Integer employerId = (Integer) session.getAttribute("employerId");
    if (employerId == null) {
        // Not logged in as employer - redirect to login
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    // ========== END SECURITY CHECK ==========
    
    // ========== UPDATED: Get user from request (set by servlet) ==========
    // 1. First try to get user from request attribute (set by servlet)
    User user = (User) request.getAttribute("user");
    
    // 2. If not in request, try role-specific session attribute
    if (user == null) {
        user = (User) session.getAttribute("employerUser");
    }
    
    // 3. If still null, try generic session attribute (fallback)
    if (user == null) {
        user = (User) session.getAttribute("user");
    }
    
    // 4. If still null, fetch from database using employerId
    if (user == null) {
        try {
            UserDAO userDAO = new UserDAOImpl();
            user = userDAO.findById(employerId); // Use employerId instead of userId
            
            // Verify this is actually an employer
            if (user != null && "employer".equalsIgnoreCase(user.getRole())) {
                session.setAttribute("employerUser", user);
                session.setAttribute("user", user);
            } else if (user != null) {
                // Wrong role - don't use this user
                System.out.println("ERROR: User " + user.getName() + " is not an employer!");
                user = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Get employer profile
    EmployerProfile profile = null;
    if (employerId != null) {
        try {
            EmployerProfileDAO profileDAO = new EmployerProfileDAOImpl();
            profile = profileDAO.getByEmployerId(employerId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Check if profile was just updated
    String profileUpdated = request.getParameter("profileUpdated");
    
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    List<Application> apps = (List<Application>) request.getAttribute("applications");
    
    // Get statistics
    int activeJobsCount = 0;
    int totalApplications = apps != null ? apps.size() : 0;
    int pendingApplications = 0;
    
    if (jobs != null) {
        for (Job job : jobs) {
            if (job.isActive()) activeJobsCount++;
        }
    }
    
    if (apps != null) {
        for (Application app : apps) {
            if ("pending".equalsIgnoreCase(app.getStatus())) {
                pendingApplications++;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employer Dashboard - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    
    <style>
        /* ========== PROFILE SECTION STYLES ========== */
        .profile-overview-section {
            display: flex;
            align-items: center;
            gap: 25px;
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-lg);
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 7px;
            object-fit: cover;
            border: 4px solid #8B5CF6;
        }
        
        .avatar-placeholder {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #8B5CF6, #6366F1);
            border-radius: 7px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.5rem;
            border: 4px solid #8B5CF6;
        }
        
        .profile-info {
            flex: 1;
        }
        
        .profile-name {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 5px;
        }
        
        .profile-company {
            font-size: 1.2rem;
            color: var(--text-secondary);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .profile-company i {
            color: #8B5CF6;
        }
        
        .profile-contact {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
        }
        
        .contact-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-secondary);
            font-size: 0.95rem;
        }
        
        .contact-item i {
            color: #8B5CF6;
            width: 20px;
        }
        
        .profile-actions {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        
        .profile-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: var(--radius-lg);
            font-weight: 500;
            font-size: 0.95rem;
            text-decoration: none;
            transition: all var(--transition-base);
        }
        
        .btn-edit-profile {
            background: #8B5CF6;
            color: white;
            border: 1px solid #8B5CF6;
        }
        
        .btn-edit-profile:hover {
            background: #7C3AED;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .btn-view-profile {
            background: transparent;
            color: var(--text-primary);
            border: 1px solid var(--border-light);
        }
        
        .btn-view-profile:hover {
            border-color: #8B5CF6;
            background: rgba(139, 92, 246, 0.05);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        
        /* ========== STATS CARDS ========== */
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            padding: 25px;
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-md);
            transition: all var(--transition-base);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }
        
        .stat-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }
        
        .stat-icon.active {
            background: rgba(16, 185, 129, 0.1);
            color: #10B981;
        }
        
        .stat-icon.interview {
            background: rgba(59, 130, 246, 0.1);
            color: #3B82F6;
        }
        
        .stat-icon.saved {
            background: rgba(245, 158, 11, 0.1);
            color: #F59E0B;
        }
        
        .stat-icon.views {
            background: rgba(139, 92, 246, 0.1);
            color: #8B5CF6;
        }
        
        .stat-trend {
            font-size: 0.85rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        
        .trend-up {
            color: #10B981;
        }
        
        .trend-down {
            color: #EF4444;
        }
        
        .trend-up i {
            color: #10B981;
        }
        
        .trend-down i {
            color: #EF4444;
        }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 0.95rem;
            color: var(--text-secondary);
        }
        
        /* ========== SUCCESS MESSAGE ========== */
        .success-message {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.2);
            border-radius: var(--radius-lg);
            padding: 15px 20px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 15px;
            animation: slideDown 0.5s ease;
        }
        
        .success-message i {
            color: #10B981;
            font-size: 1.2rem;
        }
        
        .success-message p {
            color: #065F46;
            font-weight: 500;
            margin: 0;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* ========== QUICK ACTIONS ========== */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .action-card {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            padding: 25px;
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-md);
            transition: all var(--transition-base);
            text-decoration: none;
            display: block;
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: #8B5CF6;
        }
        
        .action-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #8B5CF6, #6366F1);
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            margin-bottom: 15px;
        }
        
        .action-title {
            font-size: 1.3rem;
            color: var(--text-primary);
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .action-description {
            color: var(--text-secondary);
            font-size: 0.95rem;
        }
        
        /* ========== EXISTING STYLES (keep all your existing styles) ========== */
        .employer-dashboard-container {
            max-width: 1400px;
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
        
        .dashboard-section {
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            padding: 30px;
            box-shadow: var(--shadow-xl);
            border: 1px solid var(--border-light);
            margin-bottom: 40px;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--border-light);
        }
        
        .section-title {
            font-size: 1.5rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .section-title i {
            color: #8B5CF6;
        }
        
        .section-stats {
            display: flex;
            gap: 20px;
        }
        
        .stat-badge {
            background: var(--primary-light);
            color: var(--primary-dark);
            padding: 8px 16px;
            border-radius: var(--radius-full);
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .jobs-table, .applications-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: var(--radius-lg);
            overflow: hidden;
            background: var(--bg-secondary);
            border: 1px solid var(--border-light);
        }
        
        .jobs-table thead, .applications-table thead {
            background: linear-gradient(135deg, #8B5CF6, #6366F1);
        }
        
        .jobs-table th, .applications-table th {
            padding: 18px 20px;
            text-align: left;
            color: white;
            font-weight: 600;
            font-size: 0.95rem;
            border-right: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .jobs-table th:last-child, .applications-table th:last-child {
            border-right: none;
        }
        
        .jobs-table tbody tr, .applications-table tbody tr {
            transition: all var(--transition-base);
            border-bottom: 1px solid var(--border-light);
        }
        
        .jobs-table tbody tr:last-child, .applications-table tbody tr:last-child {
            border-bottom: none;
        }
        
        .jobs-table tbody tr:hover, .applications-table tbody tr:hover {
            background: var(--bg-primary);
        }
        
        .jobs-table td, .applications-table td {
            padding: 16px 20px;
            color: var(--text-primary);
            border-right: 1px solid var(--border-light);
        }
        
        .jobs-table td:last-child, .applications-table td:last-child {
            border-right: none;
        }
        
        .job-title-cell {
            font-weight: 600;
            color: var(--text-primary);
        }
        
        .location-cell {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-secondary);
        }
        
        .location-cell i {
            color: #8B5CF6;
        }
        
        .category-cell, .type-cell {
            background: var(--bg-tertiary);
            padding: 6px 12px;
            border-radius: var(--radius-full);
            font-size: 0.85rem;
            text-align: center;
        }
        
        .salary-cell {
            font-weight: 600;
            color: #059669;
        }
        
        .status-cell {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: var(--radius-full);
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-active {
            background: #d1fae5;
            color: #065f46;
        }
        
        .status-inactive {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .actions-cell {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .action-link {
            padding: 8px 12px;
            border-radius: var(--radius-md);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.85rem;
            transition: all var(--transition-base);
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .action-edit {
            background: var(--primary-light);
            color: var(--primary-dark);
            border: 1px solid var(--primary);
        }
        
        .action-edit:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        
        .action-delete {
            background: #fee2e2;
            color: #dc2626;
            border: 1px solid #fca5a5;
        }
        
        .action-delete:hover {
            background: #dc2626;
            color: white;
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        
        .action-toggle {
            background: var(--bg-tertiary);
            color: var(--text-primary);
            border: 1px solid var(--border-light);
        }
        
        .action-toggle:hover {
            background: var(--border-light);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        
        .job-id-cell, .seeker-id-cell {
            font-family: 'Courier New', monospace;
            font-weight: 600;
            color: var(--text-primary);
        }
        
        .app-status-cell {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .app-status-badge {
            padding: 6px 12px;
            border-radius: var(--radius-full);
            font-size: 0.85rem;
            font-weight: 600;
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
        
        .app-action-cell {
            display: flex;
            gap: 10px;
        }
        
        .no-data-message {
            text-align: center;
            padding: 60px 40px;
            background: var(--bg-secondary);
            border-radius: var(--radius-xl);
            border: 2px dashed var(--border-light);
        }
        
        .no-data-icon {
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
        
        .no-data-title {
            font-size: 1.5rem;
            color: var(--text-primary);
            margin-bottom: 10px;
        }
        
        .no-data-description {
            color: var(--text-secondary);
            margin-bottom: 25px;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }
        
        @media (max-width: 1200px) {
            .employer-dashboard-container {
                padding: 0 15px;
                margin: 20px auto;
            }
            
            .jobs-table, .applications-table {
                display: block;
                overflow-x: auto;
            }
        }
        
        @media (max-width: 992px) {
            .profile-overview-section {
                flex-direction: column;
                text-align: center;
                padding: 25px;
            }
            
            .profile-contact {
                justify-content: center;
                flex-wrap: wrap;
            }
            
            .profile-actions {
                justify-content: center;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .page-icon {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
            }
            
            .dashboard-section {
                padding: 25px;
            }
            
            .section-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .section-stats {
                width: 100%;
                justify-content: center;
            }
            
            .quick-actions {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }
            
            .stats-section {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .dashboard-section {
                padding: 20px;
            }
            
            .jobs-table th, .jobs-table td,
            .applications-table th, .applications-table td {
                padding: 12px 15px;
            }
            
            .actions-cell {
                flex-direction: column;
                gap: 8px;
            }
            
            .action-link {
                justify-content: center;
                padding: 10px;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .stats-section {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 576px) {
            .page-title {
                font-size: 1.8rem;
            }
            
            .section-title {
                font-size: 1.3rem;
            }
            
            .quick-actions {
                grid-template-columns: 1fr;
            }
            
            .action-card {
                padding: 20px;
            }
            
            .no-data-message {
                padding: 40px 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Main Container -->
    <div class="dashboard-container">
        <!-- Header -->
        <header class="dashboard-header">
            <a href="<%= contextPath %>/" class="back-home">
                <i class="fas fa-home"></i>
                <span>Home</span>
            </a>
            
            <div class="header-controls">
                <div class="current-date">
                    <i class="fas fa-briefcase"></i>
                    <span>Employer Dashboard</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <div class="employer-dashboard-container">
            <% if (user == null) { %>
                <div class="no-data-message">
                    <div class="no-data-icon">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <h3 class="no-data-title">Access Denied</h3>
                    <p class="no-data-description">
                        You must be logged in as an employer to access this dashboard.
                    </p>
                    <a href="<%= contextPath %>/login.jsp" class="action-link action-edit">
                        <i class="fas fa-sign-in-alt"></i>
                        Go to Login
                    </a>
                </div>
            <% } else { %>
            
            <!-- Success Message after Profile Update -->
            <% if ("1".equals(profileUpdated)) { %>
                <div class="success-message" id="successMessage">
                    <i class="fas fa-check-circle"></i>
                    <p>Your profile has been updated successfully!</p>
                </div>
                
                <script>
                    setTimeout(function() {
                        var msg = document.getElementById('successMessage');
                        if (msg) {
                            msg.style.transition = 'all 0.5s ease';
                            msg.style.opacity = '0';
                            msg.style.transform = 'translateY(-20px)';
                            setTimeout(function() {
                                if (msg.parentNode) {
                                    msg.parentNode.removeChild(msg);
                                }
                            }, 500);
                        }
                    }, 5000);
                </script>
            <% } %>
            
            <!-- Profile Overview Section -->
            <div class="profile-overview-section fade-in">
                <!-- Avatar -->
                <div>
                    <% if (user.getAvatarPath() != null) { %>
                        <img src="<%= contextPath + "/" + user.getAvatarPath() %>" 
                             alt="Profile Picture" 
                             class="profile-avatar">
                    <% } else { %>
                        <div class="avatar-placeholder">
                            <i class="fas fa-building"></i>
                        </div>
                    <% } %>
                </div>
                
                <!-- Profile Info -->
                <div class="profile-info">
                    <h1 class="profile-name"><%= user.getName() %></h1>
                    <div class="profile-company">
                        <i class="fas fa-building"></i>
                        <%= profile != null && profile.getCompanyName() != null ? profile.getCompanyName() : "Your Company" %>
                    </div>
                    
                    <div class="profile-contact">
                        <% if (user.getEmail() != null) { %>
                            <div class="contact-item">
                                <i class="fas fa-envelope"></i>
                                <%= user.getEmail() %>
                            </div>
                        <% } %>
                        
                        <% if (user.getPhone() != null) { %>
                            <div class="contact-item">
                                <i class="fas fa-phone"></i>
                                <%= user.getPhone() %>
                            </div>
                        <% } %>
                        
                        <% if (profile != null && profile.getWebsite() != null) { %>
                            <div class="contact-item">
                                <i class="fas fa-globe"></i>
                                <%= profile.getWebsite() %>
                            </div>
                        <% } %>
                    </div>
                    
                    <!-- Quick Actions -->
                    <div class="profile-actions">
                        <a href="<%= contextPath %>/employer/editProfile" class="profile-btn btn-edit-profile">
                            <i class="fas fa-edit"></i>
                            Edit Profile
                        </a>
                        
                        <a href="<%= contextPath %>/employer/profile" class="profile-btn btn-view-profile">
                            <i class="fas fa-eye"></i>
                            View Full Profile
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Stats Cards (like seeker dashboard) -->
            <div class="stats-section">
                <!-- Active Jobs Card -->
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon active">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <div class="stat-trend trend-up">
                            <i class="fas fa-arrow-up"></i>
                            <span>Active</span>
                        </div>
                    </div>
                    <div class="stat-value"><%= activeJobsCount %></div>
                    <div class="stat-label">Active Jobs</div>
                </div>
                
                <!-- Total Applications Card -->
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon interview">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <div class="stat-trend trend-up">
                            <i class="fas fa-arrow-up"></i>
                            <span>Total</span>
                        </div>
                    </div>
                    <div class="stat-value"><%= totalApplications %></div>
                    <div class="stat-label">Applications Received</div>
                </div>
                
                <!-- Pending Applications Card -->
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon saved">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-trend trend-down">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>Pending</span>
                        </div>
                    </div>
                    <div class="stat-value"><%= pendingApplications %></div>
                    <div class="stat-label">Pending Review</div>
                </div>
                
                <!-- Profile Views Card -->
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon views">
                            <i class="fas fa-eye"></i>
                        </div>
                        <div class="stat-trend trend-up">
                            <i class="fas fa-arrow-up"></i>
                            <span>+12</span>
                        </div>
                    </div>
                    <div class="stat-value">56</div>
                    <div class="stat-label">Profile Views</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <a href="<%= contextPath %>/employer/postJob" class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-plus-circle"></i>
                    </div>
                    <div class="action-title">Post New Job</div>
                    <div class="action-description">Create a new job listing to attract candidates</div>
                </a>
                
                <a href="<%= contextPath %>/employer/jobAlerts" class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="action-title">Set Alerts</div>
                    <div class="action-description">Get notified about new applications</div>
                </a>
                
                <a href="<%= contextPath %>/employer/changePassword" class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-key"></i>
                    </div>
                    <div class="action-title">Security</div>
                    <div class="action-description">Change password and security settings</div>
                </a>
            </div>

            <!-- Your Jobs Section -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-list-alt"></i>
                        Your Jobs
                    </h2>
                    <div class="section-stats">
                        <span class="stat-badge">
                            <i class="fas fa-briefcase"></i>
                            <%= jobs != null ? jobs.size() : 0 %> Jobs
                        </span>
                    </div>
                </div>

                <% if (jobs == null || jobs.isEmpty()) { %>
                    <div class="no-data-message">
                        <div class="no-data-icon">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <h3 class="no-data-title">No Jobs Posted</h3>
                        <p class="no-data-description">
                            You haven't posted any jobs yet. Start by posting your first job listing.
                        </p>
                        <a href="<%= contextPath %>/employer/postJob" class="action-link action-edit">
                            <i class="fas fa-plus-circle"></i>
                            Post Your First Job
                        </a>
                    </div>
                <% } else { %>
                    <table class="jobs-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Location</th>
                                <th>Category</th>
                                <th>Type</th>
                                <th>Salary</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Job j : jobs) { %>
                                <tr>
                                    <td class="job-title-cell"><%= j.getTitle() %></td>
                                    <td>
                                        <div class="location-cell">
                                            <i class="fas fa-map-marker-alt"></i>
                                            <%= j.getLocation() != null ? j.getLocation() : "-" %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="category-cell">
                                            <%= j.getCategory() != null ? j.getCategory() : "-" %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="type-cell">
                                            <%= j.getType() != null ? j.getType() : "-" %>
                                        </div>
                                    </td>
                                    <td class="salary-cell">
                                        <%= j.getSalary() != null ? j.getSalary() : "-" %>
                                    </td>
                                    <td>
                                        <div class="status-cell">
                                            <% if (j.isActive()) { %>
                                                <span class="status-badge status-active">
                                                    <i class="fas fa-check-circle"></i>
                                                    Active
                                                </span>
                                            <% } else { %>
                                                <span class="status-badge status-inactive">
                                                    <i class="fas fa-pause-circle"></i>
                                                    Inactive
                                                </span>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <a href="<%= contextPath %>/employer/editJob?id=<%= j.getId() %>"
                                               class="action-link action-edit">
                                                <i class="fas fa-edit"></i>
                                                Edit
                                            </a>
                                            
                                            <a href="<%= contextPath %>/employer/deleteJob?id=<%= j.getId() %>"
                                               class="action-link action-delete"
                                               onclick="return confirm('Delete this job?');">
                                                <i class="fas fa-trash"></i>
                                                Delete
                                            </a>
                                            
                                            <% if (j.isActive()) { %>
                                                <a href="<%= contextPath %>/employer/toggleJob?id=<%= j.getId() %>&active=0"
                                                   class="action-link action-toggle">
                                                    <i class="fas fa-pause"></i>
                                                    Deactivate
                                                </a>
                                            <% } else { %>
                                                <a href="<%= contextPath %>/employer/toggleJob?id=<%= j.getId() %>&active=1"
                                                   class="action-link action-toggle">
                                                    <i class="fas fa-play"></i>
                                                    Activate
                                                </a>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>

            <!-- Applications Received Section -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-file-alt"></i>
                        Applications Received
                    </h2>
                    <div class="section-stats">
                        <span class="stat-badge">
                            <i class="fas fa-users"></i>
                            <%= apps != null ? apps.size() : 0 %> Applications
                        </span>
                    </div>
                </div>

                <% if (apps == null || apps.isEmpty()) { %>
                    <div class="no-data-message">
                        <div class="no-data-icon">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <h3 class="no-data-title">No Applications Yet</h3>
                        <p class="no-data-description">
                            You haven't received any applications yet. Promote your jobs to attract candidates.
                        </p>
                    </div>
                <% } else { %>
                    <table class="applications-table">
                        <thead>
                            <tr>
                                <th>Job ID</th>
                                <th>Seeker ID</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Application a : apps) { 
                                // Determine status class based on status
                                String statusClass = "app-status-badge";
                                if (a.getStatus() != null) {
                                    if (a.getStatus().equalsIgnoreCase("pending")) {
                                        statusClass += " status-pending";
                                    } else if (a.getStatus().equalsIgnoreCase("reviewed")) {
                                        statusClass += " status-reviewed";
                                    } else if (a.getStatus().equalsIgnoreCase("interview")) {
                                        statusClass += " status-interview";
                                    } else if (a.getStatus().equalsIgnoreCase("accepted")) {
                                        statusClass += " status-accepted";
                                    } else if (a.getStatus().equalsIgnoreCase("rejected")) {
                                        statusClass += " status-rejected";
                                    }
                                }
                            %>
                                <tr>
                                    <td class="job-id-cell"><%= a.getJobId() %></td>
                                    <td class="seeker-id-cell"><%= a.getSeekerId() %></td>
                                    <td>
                                        <div class="app-status-cell">
                                            <span class="<%= statusClass %>">
                                                <%= a.getStatus() != null ? a.getStatus() : "Pending" %>
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="app-action-cell">
                                            <a href="<%= contextPath %>/employer/viewApplication?id=<%= a.getId() %>"
                                               class="action-link action-edit">
                                                <i class="fas fa-eye"></i>
                                                View Application
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
            <% } %>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - Employer Dashboard. All rights reserved.</p>
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
     * Employer Dashboard JavaScript
     * ES5 Compatible for Eclipse
     */
    
    var EmployerDashboard = {
        init: function() {
            this.setupThemeToggle();
            this.setupConfirmations();
            this.setupFadeIn();
        },
        
        setupThemeToggle: function() {
            var themeToggle = document.getElementById('themeToggle');
            if (!themeToggle) return;
            
            themeToggle.addEventListener('click', function() {
                var body = document.body;
                
                if (body.classList.contains('dark')) {
                    body.classList.remove('dark');
                    localStorage.setItem('employerTheme', 'light');
                    this.innerHTML = '<i class="fas fa-moon"></i><span>Dark Mode</span>';
                } else {
                    body.classList.add('dark');
                    localStorage.setItem('employerTheme', 'dark');
                    this.innerHTML = '<i class="fas fa-sun"></i><span>Light Mode</span>';
                }
            });
            
            // Apply saved theme
            var savedTheme = localStorage.getItem('employerTheme');
            if (savedTheme === 'dark') {
                document.body.classList.add('dark');
                themeToggle.innerHTML = '<i class="fas fa-sun"></i><span>Light Mode</span>';
            }
        },
        
        setupConfirmations: function() {
            var deleteLinks = document.querySelectorAll('.action-delete');
            for (var i = 0; i < deleteLinks.length; i++) {
                deleteLinks[i].addEventListener('click', function(e) {
                    if (!confirm('Delete this job?')) {
                        e.preventDefault();
                    }
                });
            }
        },
        
        setupFadeIn: function() {
            var fadeElements = document.querySelectorAll('.fade-in');
            fadeElements.forEach(function(element) {
                element.style.opacity = '0';
                element.style.transform = 'translateY(20px)';
                element.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                
                setTimeout(function() {
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, 100);
            });
        }
    };
    
    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            EmployerDashboard.init();
        });
    } else {
        EmployerDashboard.init();
    }
    </script>
</body>
</html>