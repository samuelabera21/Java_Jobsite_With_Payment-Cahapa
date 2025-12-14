<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="models.User" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.UserDAOImpl" %>

<%
    String contextPath = request.getContextPath();
    String successMsg = request.getParameter("success");
    String profileUpdated = request.getParameter("profileUpdated");
    String msg = request.getParameter("msg"); // For profile edit success
    
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
    String currentDate = now.format(formatter);
    
    // ========== UPDATED: Get user from request (set by servlet) ==========
    // 1. First try to get user from request attribute (set by servlet)
    User user = (User) request.getAttribute("user");
    
    // 2. If not in request, try role-specific session attribute
    if (user == null) {
        user = (User) session.getAttribute("seekerUser");
    }
    
    // 3. If still null, try generic session attribute (fallback)
    if (user == null) {
        user = (User) session.getAttribute("user");
    }
    
    // 4. If still null, fetch from database as last resort
    if (user == null) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId != null) {
            try {
                UserDAO userDAO = new UserDAOImpl();
                user = userDAO.getById(userId);
                
                // Verify this is actually a seeker
                if (user != null && "seeker".equalsIgnoreCase(user.getRole())) {
                    session.setAttribute("seekerUser", user);
                    session.setAttribute("user", user);
                } else if (user != null) {
                    // Wrong role - don't use this user
                    System.out.println("ERROR: User " + user.getName() + " is not a seeker!");
                    user = null;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    // Check if we need to refresh user data (after profile edit)
    boolean refreshUserData = "updated".equals(msg) || "1".equals(profileUpdated);
    if (refreshUserData && user != null) {
        try {
            // Refresh user data from database
            UserDAO userDAO = new UserDAOImpl();
            User refreshedUser = userDAO.getById(user.getId());
            if (refreshedUser != null && "seeker".equalsIgnoreCase(refreshedUser.getRole())) {
                user = refreshedUser;
                session.setAttribute("seekerUser", user);
                session.setAttribute("user", user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // ========== END UPDATE ==========
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Seeker Dashboard - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    
    <!-- JavaScript -->
    <script src="<%= contextPath %>/assets/js/seeker_dashboard.js" defer></script>
    
    <!-- Hidden data container for JavaScript -->
    <script type="application/json" id="dashboardStats">
        {
            "applications": <%= Math.floor(Math.random() * 20) + 5 %>,
            "interviews": <%= Math.floor(Math.random() * 5) %>,
            "savedJobs": <%= Math.floor(Math.random() * 15) + 3 %>,
            "profileViews": <%= Math.floor(Math.random() * 100) + 20 %>
        }
    </script>
    
    <style>
        /* Additional styles for user profile in header */
        .user-profile-section {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 10px 20px;
            background: var(--bg-secondary);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border-light);
            margin-right: 20px;
            transition: all var(--transition-base);
        }
        
        .user-profile-section:hover {
            background: var(--bg-tertiary);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .profile-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--primary);
            flex-shrink: 0;
        }
        
        .profile-avatar-placeholder {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        
        .profile-info {
            display: flex;
            flex-direction: column;
            min-width: 120px;
        }
        
        .profile-name {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.95rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .profile-role {
            color: var(--text-secondary);
            font-size: 0.85rem;
            margin-top: 2px;
            text-transform: capitalize;
        }
        
        .profile-link {
            text-decoration: none;
            color: inherit;
            display: flex;
            align-items: center;
            gap: 15px;
            flex: 1;
        }
        
        .profile-link:hover {
            text-decoration: none;
        }
        
        /* Update header controls for new layout */
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 20px;
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-light);
            animation: slideIn 0.6s ease;
        }
        
        .header-left {
            display: flex;
            align-items: center;
            gap: 20px;
            flex: 1;
        }
        
        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        @media (max-width: 992px) {
            .dashboard-header {
                flex-direction: column;
                gap: 20px;
            }
            
            .header-left, .header-right {
                width: 100%;
                justify-content: space-between;
            }
            
            .user-profile-section {
                margin-right: 0;
                flex: 1;
            }
        }
        
        @media (max-width: 576px) {
            .user-profile-section {
                padding: 8px 15px;
            }
            
            .profile-info {
                min-width: 100px;
            }
        }
    </style>
</head>
<body>
    <!-- Main Container -->
    <div class="dashboard-container">
        <!-- Header -->
        <header class="dashboard-header">
            <div class="header-left">
                <a href="<%= contextPath %>/seeker/dashboard" class="back-home">
                    <i class="fas fa-home"></i>
                    <span>Dashboard Home</span>
                </a>
                
                <!-- User Profile Section -->
                <div class="user-profile-section">
                    <a href="<%= contextPath %>/seeker/profile" class="profile-link">
                        <% 
                            // Check if user has avatar
                            boolean hasAvatar = false;
                            String avatarUrl = null;
                            
                            if (user != null) {
                                hasAvatar = user.getAvatarPath() != null && !user.getAvatarPath().isEmpty();
                                if (hasAvatar) {
                                    // Your servlet saves as "uploads/avatars/filename.jpg"
                                    String avatarPath = user.getAvatarPath();
                                    
                                    // Fix the avatar URL based on how your servlet saves it
                                    if (avatarPath.startsWith("uploads/avatars/")) {
                                        avatarUrl = contextPath + "/" + avatarPath;
                                    } else if (avatarPath.startsWith("/uploads/avatars/")) {
                                        avatarUrl = contextPath + avatarPath;
                                    } else if (avatarPath.startsWith("avatars/")) {
                                        avatarUrl = contextPath + "/uploads/" + avatarPath;
                                    } else {
                                        // Default: assume it's already the full path
                                        avatarUrl = contextPath + "/" + avatarPath;
                                    }
                                }
                            }
                        %>
                        
                        <% if (user != null && hasAvatar) { %>
                            <img src="<%= avatarUrl %>" 
                                 alt="Profile" 
                                 class="profile-avatar"
                                 onerror="
                                    console.log('Avatar failed to load: ', this.src);
                                    this.style.display='none';
                                    var placeholder = this.nextElementSibling;
                                    if (placeholder) placeholder.style.display='flex';
                                 ">
                            <div class="profile-avatar-placeholder" style="display: none;">
                                <i class="fas fa-user"></i>
                            </div>
                        <% } else { %>
                            <div class="profile-avatar-placeholder">
                                <i class="fas fa-user"></i>
                            </div>
                        <% } %>
                        
                        <div class="profile-info">
                            <span class="profile-name">
                                <%= user != null ? user.getName() : "User Not Found" %>
                            </span>
                            <span class="profile-role">
                                <%= user != null && user.getRole() != null ? user.getRole() : "Job Seeker" %>
                            </span>
                        </div>
                    </a>
                </div>
            </div>
            
            <div class="header-right">
                <div class="current-date">
                    <i class="fas fa-calendar-alt"></i>
                    <span><%= currentDate %></span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <!-- Dashboard Container -->
        <div class="seeker-container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-icon">
                    <i class="fas fa-user-tie"></i>
                </div>
                <h1 class="page-title">Job Seeker Dashboard</h1>
                <p class="page-subtitle">Welcome to your personal job search dashboard</p>
            </div>

            <% if (user == null) { %>
                <div class="alert warning fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Access Denied</h4>
                        <p>You must be logged in as a job seeker to access this dashboard.</p>
                        <a href="<%= contextPath %>/login.jsp" class="btn btn-primary">Go to Login</a>
                    </div>
                </div>
            <% } else { %>
            
            <!-- Success Alerts -->
            <% if ("1".equals(successMsg)) { %>
                <div class="alert success fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Welcome Back!</h4>
                        <p>You have successfully logged in to your dashboard.</p>
                    </div>
                </div>
            <% } %>
            
            <% if ("1".equals(profileUpdated)) { %>
                <div class="alert success fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Profile Updated Successfully!</h4>
                        <p>Your profile information has been saved and updated.</p>
                    </div>
                </div>
            <% } %>
            
            <% if ("updated".equals(msg)) { %>
                <div class="alert success fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Profile Updated Successfully!</h4>
                        <p>Your profile information has been saved and updated.</p>
                    </div>
                </div>
            <% } %>

            <!-- Stats Cards Container -->
            <div class="stats-container fade-in">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" id="statApplications">0</h3>
                        <p class="stat-label">Active Applications</p>
                        <div class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>+2 this week</span>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" id="statInterviews">0</h3>
                        <p class="stat-label">Upcoming Interviews</p>
                        <div class="stat-trend warning">
                            <i class="fas fa-exclamation"></i>
                            <span>Prepare now</span>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-bookmark"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" id="statSavedJobs">0</h3>
                        <p class="stat-label">Saved Jobs</p>
                        <div class="stat-trend positive">
                            <i class="fas fa-plus"></i>
                            <span>+3 recently</span>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-eye"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" id="statProfileViews">0</h3>
                        <p class="stat-label">Profile Views</p>
                        <div class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>+12 this month</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Dashboard Actions Grid -->
            <div class="dashboard-actions fade-in">
                <h3><i class="fas fa-tasks"></i> Dashboard Actions</h3>
                
                <div class="actions-grid">
                    <!-- 1. View Available Jobs -->
                    <div class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <div class="action-content">
                            <h4 class="action-title">View Available Jobs</h4>
                            <p class="action-description">Browse and search for job opportunities that match your skills.</p>
                        </div>
                        <div class="action-link">
                            <a href="<%= request.getContextPath() %>/seeker/viewJobs" class="btn btn-primary btn-block">
                                <i class="fas fa-search"></i>
                                View Jobs
                            </a>
                        </div>
                    </div>

                    <!-- 2. My Applications -->
                    <div class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <div class="action-content">
                            <h4 class="action-title">My Applications</h4>
                            <p class="action-description">Track the status of your job applications and view history.</p>
                        </div>
                        <div class="action-link">
                            <a href="<%= request.getContextPath() %>/seeker/applications" class="btn btn-primary btn-block">
                                <i class="fas fa-list"></i>
                                View Applications
                            </a>
                        </div>
                    </div>

                    <!-- 3. Edit Profile -->
                    <div class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-user-edit"></i>
                        </div>
                        <div class="action-content">
                            <h4 class="action-title">Edit Profile</h4>
                            <p class="action-description">Update your personal information, skills, and details.</p>
                        </div>
                        <div class="action-link">
                            <a href="<%= contextPath %>/seeker/profile" class="btn btn-primary btn-block">
                                <i class="fas fa-edit"></i>
                                Edit Profile
                            </a>
                        </div>
                    </div>

                    <!-- 4. Download My CV (PDF) -->
                    <div class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-download"></i>
                        </div>
                        <div class="action-content">
                            <h4 class="action-title">Download My CV (PDF)</h4>
                            <p class="action-description">Download your current CV in PDF format for applications.</p>
                        </div>
                        <div class="action-link">
                            <a href="${pageContext.request.contextPath}/seeker/downloadCV" class="btn btn-primary btn-block">
                                <i class="fas fa-file-pdf"></i>
                                Download CV
                            </a>
                        </div>
                    </div>

                    <!-- 5. CV Builder -->
                    <div class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-tools"></i>
                        </div>
                        <div class="action-content">
                            <h4 class="action-title">CV Builder</h4>
                            <p class="action-description">Create or update your professional CV with our builder.</p>
                        </div>
                        <div class="action-link">
                            <a href="${pageContext.request.contextPath}/seeker/cvbuilder" class="btn btn-primary btn-block">
                                <i class="fas fa-plus"></i>
                                Build CV
                            </a>
                        </div>
                    </div>

                    <!-- 6. Job Alerts -->
                    <div class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-bell"></i>
                        </div>
                        <div class="action-content">
                            <h4 class="action-title">Job Alerts</h4>
                            <p class="action-description">Set up and manage job alerts for new opportunities.</p>
                        </div>
                        <div class="action-link">
                            <a href="${pageContext.request.contextPath}/seeker/jobAlerts" class="btn btn-primary btn-block">
                                <i class="fas fa-bell"></i>
                                Manage Alerts
                            </a>
                        </div>
                    </div>

                    <!-- 7. Download CV Templates -->
                    <div class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-file-pdf"></i>
                        </div>
                        <div class="action-content">
                            <h4 class="action-title">Download CV Templates</h4>
                            <p class="action-description">Browse and download professionally designed CV templates.</p>
                        </div>
                        <div class="action-link">
                            <a href="${pageContext.request.contextPath}/seeker/cvTemplates" class="btn btn-primary btn-block">
                                <i class="fas fa-download"></i>
                                Get Templates
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Access Links -->
            <div class="quick-access fade-in">
                <h3><i class="fas fa-bolt"></i> Quick Access</h3>
                <div class="quick-links">
                    <a href="<%= request.getContextPath() %>/seeker/viewJobs" class="quick-link">
                        <i class="fas fa-briefcase"></i>
                        <span>View Jobs</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/seeker/applications" class="quick-link">
                        <i class="fas fa-file-alt"></i>
                        <span>My Applications</span>
                    </a>
                    <a href="<%= contextPath %>/seeker/profile" class="quick-link">
                        <i class="fas fa-user-edit"></i>
                        <span>Edit Profile</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/seeker/downloadCV" class="quick-link">
                        <i class="fas fa-download"></i>
                        <span>Download CV</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/seeker/cvbuilder" class="quick-link">
                        <i class="fas fa-tools"></i>
                        <span>CV Builder</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/seeker/jobAlerts" class="quick-link">
                        <i class="fas fa-bell"></i>
                        <span>Job Alerts</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/seeker/cvTemplates" class="quick-link">
                        <i class="fas fa-file-pdf"></i>
                        <span>CV Templates</span>
                    </a>
                </div>
            </div>
            <% } %>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - Job Seeker Dashboard. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/seeker/profile"><i class="fas fa-user-circle"></i> Profile</a>
                <span>•</span>
                <a href="#"><i class="fas fa-question-circle"></i> Help Center</a>
                <span>•</span>
                <a href="#"><i class="fas fa-cog"></i> Settings</a>
                <span>•</span>
                <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <i class="fas fa-cog fa-spin"></i>
            <p>Loading Dashboard...</p>
        </div>
    </div>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>

    <!-- Confirmation Modal -->
    <div class="confirmation-modal" id="confirmationModal">
        <div class="confirmation-content">
            <div class="confirmation-icon">
                <i class="fas fa-question-circle"></i>
            </div>
            <h3 class="confirmation-title" id="confirmTitle">Confirm Action</h3>
            <p class="confirmation-message" id="confirmMessage">Are you sure you want to perform this action?</p>
            <div class="confirmation-actions">
                <button class="btn btn-secondary" id="confirmCancel">Cancel</button>
                <button class="btn btn-primary" id="confirmOk">OK</button>
            </div>
        </div>
    </div>

    <script>
    console.log('Dashboard loaded');
    console.log('User available:', <%= user != null %>);
    <% if (user != null) { %>
        console.log('User name:', '<%= user.getName() %>');
        console.log('User role:', '<%= user.getRole() %>');
    <% } %>
    
    // Check URL parameters for success messages
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('msg') && urlParams.get('msg') === 'updated') {
        console.log('Profile was updated, user data refreshed');
    }
    if (urlParams.has('profileUpdated') && urlParams.get('profileUpdated') === '1') {
        console.log('Profile was updated via profileUpdated parameter');
    }
    </script>
</body>
</html>