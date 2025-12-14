<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — JobPortal</title>
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin_dashboard.css">

    <!-- JavaScript -->
    <script defer src="<%= request.getContextPath() %>/assets/js/admin_dashboard.js"></script>
</head>

<body>
    <!-- Floating Background Elements -->
    <div class="floating-element"></div>
    <div class="floating-element"></div>
    <div class="floating-element"></div>

    <!-- Hero Background -->
    <div class="hero-image" style="background-image: url('https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');"></div>
    <div class="hero-overlay"></div>

    <!-- Main Container -->
    <div class="admin-container">
        <!-- NAVBAR -->
        <nav class="admin-navbar">
            <div class="navbar-content">
                <div class="logo">
                    <i class="fas fa-briefcase"></i>
                    <span>JobPortal <strong>Admin</strong></span>
                </div>

                <div class="nav-controls">
                    <div class="admin-info">
                        <div class="admin-avatar">
                            <i class="fas fa-user-shield"></i>
                        </div>
                        <div class="admin-details">
                            <span class="admin-name">Administrator</span>
                            <span class="admin-role">System Admin</span>
                        </div>
                    </div>
                    
                    <div class="nav-actions">
                        <button id="themeToggle" class="theme-btn" title="Toggle Theme">
                            <i class="fas fa-moon"></i>
                        </button>
                        
                        <div class="notifications">
                            <button class="notification-btn" id="notificationBtn" title="Notifications">
                                <i class="fas fa-bell"></i>
                                <span class="notification-badge">3</span>
                            </button>
                        </div>
                        
                        <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HEADER -->
        <header class="admin-header">
            <div class="header-content">
                <div class="welcome-section">
                    <h1 class="welcome-title">Welcome back, Admin!</h1>
                    <p class="welcome-subtitle">Manage users, jobs, applications, and system settings from one dashboard</p>
                    <div class="date-time">
                        <i class="fas fa-calendar-alt"></i>
                        <span id="currentDateTime"></span>
                    </div>
                </div>
                
                <div class="header-actions">
                    <a href="<%= request.getContextPath() %>/admin/systemSettings" class="btn btn-outline">
                        <i class="fas fa-cog"></i>
                        System Settings
                    </a>
                    <a href="#" class="btn btn-primary" id="quickStatsBtn">
                        <i class="fas fa-chart-line"></i>
                        View Analytics
                    </a>
                </div>
            </div>
        </header>

        <!-- STATS CARDS - Simple & Clear -->
        <section class="stats-section">
            <h2 class="section-title">
                <i class="fas fa-chart-bar"></i>
                Dashboard Overview
            </h2>
            
            <div class="stats-grid">
                <div class="stat-card fade-in">
                    <div class="stat-icon user-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3 class="stat-title">Total Users</h3>
                        <div class="stat-value"><%= request.getAttribute("users") != null ? request.getAttribute("users") : "0" %></div>
                        <div class="stat-change">All registered users</div>
                    </div>
                </div>

                <div class="stat-card fade-in">
                    <div class="stat-icon pending-icon">
                        <i class="fas fa-user-clock"></i>
                    </div>
                    <div class="stat-info">
                        <h3 class="stat-title">Pending Employers</h3>
                        <div class="stat-value"><%= request.getAttribute("pendingEmployers") != null ? request.getAttribute("pendingEmployers") : "0" %></div>
                        <div class="stat-change">Awaiting approval</div>
                    </div>
                </div>

                <div class="stat-card fade-in">
                    <div class="stat-icon job-icon">
                        <i class="fas fa-briefcase"></i>
                    </div>
                    <div class="stat-info">
                        <h3 class="stat-title">Total Jobs</h3>
                        <div class="stat-value"><%= request.getAttribute("jobs") != null ? request.getAttribute("jobs") : "0" %></div>
                        <div class="stat-change">Active job postings</div>
                    </div>
                </div>

                <div class="stat-card fade-in">
                    <div class="stat-icon application-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="stat-info">
                        <h3 class="stat-title">Total Applications</h3>
                        <div class="stat-value"><%= request.getAttribute("applications") != null ? request.getAttribute("applications") : "0" %></div>
                        <div class="stat-change">Job applications</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- QUICK ACTIONS -->
        <section class="actions-section">
            <div class="section-header">
                <h2 class="section-title">
                    <i class="fas fa-rocket"></i>
                    Quick Actions
                </h2>
                <p class="section-subtitle">Manage your platform with these tools</p>
            </div>

            <div class="actions-grid">
                <a href="<%= request.getContextPath() %>/admin/manageUsers" class="action-card">
                    <div class="action-icon user-action">
                        <i class="fas fa-user-cog"></i>
                    </div>
                    <div class="action-content">
                        <h3>Manage Users</h3>
                        <p>View, edit, and manage all user accounts</p>
                    </div>
                    <div class="action-arrow">
                        <i class="fas fa-chevron-right"></i>
                    </div>
                </a>

                <a href="<%= request.getContextPath() %>/admin/pendingEmployers" class="action-card">
                    <div class="action-icon approve-action">
                        <i class="fas fa-user-check"></i>
                    </div>
                    <div class="action-content">
                        <h3>Approve Employers</h3>
                        <p>Review and approve employer registrations</p>
                    </div>
                    <div class="action-arrow">
                        <i class="fas fa-chevron-right"></i>
                    </div>
                </a>

                <a href="<%= request.getContextPath() %>/admin/cvTemplates" class="action-card">
                    <div class="action-icon cv-action">
                        <i class="fas fa-file-contract"></i>
                    </div>
                    <div class="action-content">
                        <h3>CV Templates</h3>
                        <p>Manage professional CV templates</p>
                    </div>
                    <div class="action-arrow">
                        <i class="fas fa-chevron-right"></i>
                    </div>
                </a>

                <a href="<%= request.getContextPath() %>/admin/systemSettings" class="action-card">
                    <div class="action-icon settings-action">
                        <i class="fas fa-sliders-h"></i>
                    </div>
                    <div class="action-content">
                        <h3>System Settings</h3>
                        <p>Configure platform settings and preferences</p>
                    </div>
                    <div class="action-arrow">
                        <i class="fas fa-chevron-right"></i>
                    </div>
                </a>
            </div>
        </section>

        <!-- ALL ADMIN CONTROLS -->
        <section class="menu-section">
            <div class="section-header">
                <h2 class="section-title">
                    <i class="fas fa-th-large"></i>
                    All Admin Controls
                </h2>
                <p class="section-subtitle">Complete access to all administrative functions</p>
            </div>

            <div class="menu-grid">
                <a href="<%= request.getContextPath() %>/admin/viewSeekers" class="menu-card">
                    <div class="menu-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <div class="menu-content">
                        <h3>View All Seekers</h3>
                        <p>Browse all job seeker profiles</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath() %>/admin/viewEmployers" class="menu-card">
                    <div class="menu-icon">
                        <i class="fas fa-building"></i>
                    </div>
                    <div class="menu-content">
                        <h3>View All Employers</h3>
                        <p>View all registered companies</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath() %>/admin/viewJobs" class="menu-card">
                    <div class="menu-icon">
                        <i class="fas fa-briefcase"></i>
                    </div>
                    <div class="menu-content">
                        <h3>View All Jobs</h3>
                        <p>Monitor all posted job listings</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath() %>/admin/viewApplications" class="menu-card">
                    <div class="menu-icon">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <div class="menu-content">
                        <h3>View All Applications</h3>
                        <p>Track all job applications</p>
                    </div>
                </a>
                
                <a href="<%= request.getContextPath() %>/admin/managed.less.jsp" class="menu-card">
                    <div class="menu-icon">
                        <i class="fas fa-chart-pie"></i>
                    </div>
                    <div class="menu-content">
                        <h3>Analytics Dashboard</h3>
                        <p>View detailed platform analytics</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath() %>/admin/view_applications.jsp" class="menu-card">
                    <div class="menu-icon">
                        <i class="fas fa-tasks"></i>
                    </div>
                    <div class="menu-content">
                        <h3>Application Management</h3>
                        <p>Detailed application oversight</p>
                    </div>
                </a>
            </div>
        </section>

        <!-- SIMPLE SYSTEM INFO -->
        <section class="info-section">
            <div class="info-grid">
                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-server"></i>
                    </div>
                    <div class="info-content">
                        <h3>System Status</h3>
                        <p class="status-active">All Systems Operational</p>
                    </div>
                </div>
                
                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="info-content">
                        <h3>Last Updated</h3>
                        <p id="lastUpdatedTime">Just now</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- FOOTER -->
        <footer class="admin-footer">
            <div class="footer-content">
                <div class="footer-logo">
                    <i class="fas fa-briefcase"></i>
                    <span>JobPortal Admin Panel</span>
                </div>
                
                <div class="footer-links">
                    <a href="#"><i class="fas fa-shield-alt"></i> Security</a>
                    <a href="#"><i class="fas fa-question-circle"></i> Help</a>
                    <a href="#"><i class="fas fa-envelope"></i> Contact</a>
                </div>
                
                <div class="footer-copyright">
                    <p>&copy; 2025 JobPortal — Admin Dashboard v2.0</p>
                </div>
            </div>
        </footer>
    </div>
</body>
</html>