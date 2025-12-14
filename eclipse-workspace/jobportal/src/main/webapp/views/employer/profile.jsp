<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="models.EmployerProfile" %>
<%@ page import="models.User" %>

<%
    EmployerProfile profile = (EmployerProfile) request.getAttribute("profile");
    User user = (User) request.getAttribute("user");
    String contextPath = request.getContextPath();
    String successMsg = request.getParameter("success");
    String passwordMsg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Profile - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    
    <style>
        /* Additional profile-specific styles */
        .profile-info-section {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            padding: 40px;
            border: 1px solid var(--border-light);
            margin-bottom: 30px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 20px;
        }
        
        .info-item {
            margin-bottom: 25px;
        }
        
        .info-label {
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-label strong {
            color: var(--text-primary);
            font-weight: 600;
        }
        
        .info-value {
            color: var(--text-primary);
            font-size: 1.1rem;
            font-weight: 500;
            padding: 10px 0;
            min-height: 24px;
        }
        
        .avatar-section {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid var(--border-light);
        }
        
        .avatar-image {
            width: 150px;
            height: 150px;
            border-radius: 7px;
            object-fit: cover;
            border: 3px solid var(--primary-light);
        }
        
        .no-avatar {
            color: var(--text-secondary);
            font-style: italic;
        }
        
        .profile-links {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            padding: 30px;
            border: 1px solid var(--border-light);
        }
        
        .profile-link {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 24px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: var(--radius-lg);
            font-weight: 500;
            margin-right: 15px;
            margin-bottom: 15px;
            transition: all var(--transition-base);
        }
        
        .profile-link:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .profile-link.secondary {
            background: var(--secondary);
        }
        
        .profile-link.secondary:hover {
            background: var(--secondary-dark);
        }
        
        .profile-link.outline {
            background: transparent;
            border: 2px solid var(--border-light);
            color: var(--text-primary);
        }
        
        .profile-link.outline:hover {
            border-color: var(--primary);
            background: rgba(37, 99, 235, 0.05);
        }
        
        .bio-content {
            white-space: pre-wrap;
            line-height: 1.6;
            padding: 15px;
            background: var(--bg-secondary);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-light);
        }
        
        @media (max-width: 768px) {
            .info-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .profile-info-section {
                padding: 25px;
            }
            
            .profile-links {
                padding: 20px;
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
                    <i class="fas fa-building"></i>
                    <span>Company Profile</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <!-- Profile Container -->
        <div class="apply-container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-icon">
                    <i class="fas fa-building"></i>
                </div>
                <h1 class="page-title">Company Profile</h1>
                <p class="page-subtitle">View and manage your company information</p>
            </div>

            <!-- Success Messages -->
            <% if ("1".equals(successMsg)) { %>
                <div class="alert success fade-in" style="margin-bottom: 30px;">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Profile Updated!</h4>
                        <p>Your company profile has been updated successfully.</p>
                    </div>
                </div>
            <% } %>
            
            <% if ("password_updated".equals(passwordMsg)) { %>
                <div class="alert success fade-in" style="margin-bottom: 30px;">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Password Updated!</h4>
                        <p>Your password has been changed successfully.</p>
                    </div>
                </div>
            <% } %>

            <!-- Profile Information Section -->
            <div class="profile-info-section fade-in">
                <h2 style="margin-bottom: 30px; color: var(--text-primary); font-size: 1.5rem;">
                    <i class="fas fa-id-card"></i>
                    Company Information
                </h2>
                
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-user"></i>
                            <strong>Contact Person:</strong>
                        </div>
                        <div class="info-value"><%= user != null ? user.getName() : "" %></div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-building"></i>
                            <strong>Company Name:</strong>
                        </div>
                        <div class="info-value"><%= profile != null ? profile.getCompanyName() : "Not set" %></div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-envelope"></i>
                            <strong>Email:</strong>
                        </div>
                        <div class="info-value"><%= user != null ? user.getEmail() : "" %></div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-globe"></i>
                            <strong>Website:</strong>
                        </div>
                        <div class="info-value">
                            <% if (profile != null && profile.getWebsite() != null && !profile.getWebsite().isEmpty()) { %>
                                <a href="<%= profile.getWebsite() %>" target="_blank" style="color: var(--primary);">
                                    <%= profile.getWebsite() %>
                                </a>
                            <% } else { %>
                                Not provided
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-phone"></i>
                            <strong>Phone:</strong>
                        </div>
                        <div class="info-value"><%= user != null && user.getPhone() != null ? user.getPhone() : "Not provided" %></div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-map-marker-alt"></i>
                            <strong>Address:</strong>
                        </div>
                        <div class="info-value"><%= profile != null && profile.getAddress() != null ? profile.getAddress() : "Not provided" %></div>
                    </div>
                </div>
                
                <!-- Company Bio -->
                <div class="info-item">
                    <div class="info-label">
                        <i class="fas fa-file-alt"></i>
                        <strong>Company Bio:</strong>
                    </div>
                    <div class="bio-content">
                        <%= profile != null && profile.getBio() != null ? profile.getBio() : "No bio provided. Click 'Edit Profile' to add one." %>
                    </div>
                </div>
                
                <!-- Profile Picture -->
                <div class="avatar-section">
                    <div class="info-label">
                        <i class="fas fa-image"></i>
                        <strong>Profile Picture:</strong>
                    </div>
                    <div style="margin-top: 15px;">
                        <% if (user != null && user.getAvatarPath() != null) { %>
                            <img src="<%= contextPath + "/" + user.getAvatarPath() %>"
                                 alt="Profile Avatar"
                                 class="avatar-image">
                        <% } else { %>
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <div class="photo-placeholder" style="width: 80px; height: 80px;">
                                    <i class="fas fa-building"></i>
                                </div>
                                <span class="no-avatar">No company logo uploaded.</span>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Profile Links Section -->
            <div class="profile-links fade-in">
                <h3 style="margin-bottom: 25px; color: var(--text-primary); font-size: 1.3rem;">
                    <i class="fas fa-cog"></i>
                    Account Management
                </h3>
                
                <a href="<%= contextPath %>/employer/editProfile" class="profile-link">
                    <i class="fas fa-edit"></i>
                    Edit Profile
                </a>
                
                <a href="<%= contextPath %>/employer/changePassword" class="profile-link secondary">
                    <i class="fas fa-key"></i>
                    Change Password
                </a>
                
                <a href="<%= contextPath %>/employer/dashboard" class="profile-link outline">
                    <i class="fas fa-arrow-left"></i>
                    Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - Company Profile. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/employer/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span></span>
                <a href="<%= contextPath %>/employer/postJob"><i class="fas fa-plus"></i> Post Job</a>
                <span></span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Theme toggle functionality
            var themeToggle = document.getElementById('themeToggle');
            if (themeToggle) {
                themeToggle.addEventListener('click', function() {
                    document.body.classList.toggle('dark-theme');
                    var icon = this.querySelector('i');
                    var text = this.querySelector('span');
                    
                    if (document.body.classList.contains('dark-theme')) {
                        icon.className = 'fas fa-sun';
                        text.textContent = 'Light Mode';
                        localStorage.setItem('employerTheme', 'dark');
                    } else {
                        icon.className = 'fas fa-moon';
                        text.textContent = 'Dark Mode';
                        localStorage.setItem('employerTheme', 'light');
                    }
                });
                
                // Load saved theme
                var savedTheme = localStorage.getItem('employerTheme');
                if (savedTheme === 'dark') {
                    document.body.classList.add('dark-theme');
                    themeToggle.querySelector('i').className = 'fas fa-sun';
                    themeToggle.querySelector('span').textContent = 'Light Mode';
                }
            }
            
            // Add fade-in animation
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
        });
    </script>
</body>
</html>