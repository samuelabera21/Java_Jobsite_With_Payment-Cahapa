<%@ page import="models.User" %>

<%
    User u = (User) request.getAttribute("user");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Job Seeker</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
   
    
    <!-- JavaScript -->
    <script src="<%= contextPath %>/assets/js/seeker_dashboard.js" defer></script>
    <script src="<%= contextPath %>/assets/js/profile.js" defer></script>
    
    <style>
        /* Additional profile-specific styles */
        .profile-info-section {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            padding: 40px;
            border: 1px solid var(--border-light);
            margin-bottom: 30px;
        }
        
        .info-item {
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-light);
        }
        
        .info-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
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
        }
        
        .avatar-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid var(--border-light);
        }
        
        .avatar-image {
            width: 120px;
            height: 120px;
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
                    <i class="fas fa-user-circle"></i>
                    <span>My Profile</span>
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
                    <i class="fas fa-user-circle"></i>
                </div>
                <h1 class="page-title">My Profile</h1>
                <p class="page-subtitle">View and manage your personal information</p>
            </div>

            <!-- Profile Information Section -->
            <div class="profile-info-section fade-in">
                <h2 style="margin-bottom: 30px; color: var(--text-primary); font-size: 1.5rem;">
                    <i class="fas fa-id-card"></i>
                    Personal Information
                </h2>
                
                <div class="info-item">
                    <div class="info-label">
                        <i class="fas fa-user"></i>
                        <strong>Name:</strong>
                    </div>
                    <div class="info-value"><%= u.getName() %></div>
                </div>
                
                <div class="info-item">
                    <div class="info-label">
                        <i class="fas fa-envelope"></i>
                        <strong>Email:</strong>
                    </div>
                    <div class="info-value"><%= u.getEmail() %></div>
                </div>
                
                <div class="info-item">
                    <div class="info-label">
                        <i class="fas fa-phone"></i>
                        <strong>Phone:</strong>
                    </div>
                    <div class="info-value"><%= u.getPhone() != null ? u.getPhone() : "Not provided" %></div>
                </div>
                
                <div class="info-item">
                    <div class="info-label">
                        <i class="fas fa-circle"></i>
                        <strong>Status:</strong>
                    </div>
                    <div class="info-value">
                        <span class="status-badge <%= u.getStatus().toLowerCase().replace(" ", "-") %>">
                            <%= u.getStatus() %>
                        </span>
                    </div>
                </div>
                
                <div class="avatar-section">
                    <div class="info-label">
                        <i class="fas fa-image"></i>
                        <strong>Avatar:</strong>
                    </div>
                    <div class="info-value">
                        <% if (u.getAvatarPath() != null) { %>
                            <img src="<%= contextPath + "/" + u.getAvatarPath() %>"
                                 alt="Profile Avatar"
                                 class="avatar-image">
                        <% } else { %>
                            <span class="no-avatar">No photo uploaded.</span>
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
                
                <!-- EXACT SAME LINKS AS ORIGINAL -->
                <a href="<%= contextPath %>/seeker/editProfile" class="profile-link">
                    <i class="fas fa-edit"></i>
                    Edit Profile
                </a>
                
                <a href="<%= contextPath %>/seeker/changePassword" class="profile-link secondary">
                    <i class="fas fa-key"></i>
                    Change Password
                </a>
                
                <a href="<%= contextPath %>/seeker/dashboard" class="profile-link outline">
                    <i class="fas fa-arrow-left"></i>
                    Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - My Profile. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/seeker/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span></span>
                <a href="<%= contextPath %>/seeker/viewJobs"><i class="fas fa-briefcase"></i> Browse Jobs</a>
                <span></span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>
    
    <script>
        // Simple ES5 compatible profile.js
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
                        localStorage.setItem('theme', 'dark');
                    } else {
                        icon.className = 'fas fa-moon';
                        text.textContent = 'Dark Mode';
                        localStorage.setItem('theme', 'light');
                    }
                });
                
                // Load saved theme
                var savedTheme = localStorage.getItem('theme');
                if (savedTheme === 'dark') {
                    document.body.classList.add('dark-theme');
                    themeToggle.querySelector('i').className = 'fas fa-sun';
                    themeToggle.querySelector('span').textContent = 'Light Mode';
                }
            }
            
            // Add status badge colors
            var statusBadges = document.querySelectorAll('.status-badge');
            statusBadges.forEach(function(badge) {
                if (badge.textContent.toLowerCase().includes('active')) {
                    badge.style.background = 'rgba(16, 185, 129, 0.1)';
                    badge.style.color = '#10b981';
                    badge.style.border = '1px solid rgba(16, 185, 129, 0.2)';
                } else if (badge.textContent.toLowerCase().includes('pending')) {
                    badge.style.background = 'rgba(245, 158, 11, 0.1)';
                    badge.style.color = '#f59e0b';
                    badge.style.border = '1px solid rgba(245, 158, 11, 0.2)';
                } else if (badge.textContent.toLowerCase().includes('inactive')) {
                    badge.style.background = 'rgba(107, 114, 128, 0.1)';
                    badge.style.color = '#6b7280';
                    badge.style.border = '1px solid rgba(107, 114, 128, 0.2)';
                }
                
                badge.style.padding = '6px 12px';
                badge.style.borderRadius = '20px';
                badge.style.fontSize = '0.85rem';
                badge.style.fontWeight = '500';
                badge.style.display = 'inline-block';
            });
            
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
            
            // Simple toast notification function
            window.showToast = function(message, type) {
                var toastContainer = document.getElementById('toastContainer');
                if (!toastContainer) {
                    toastContainer = document.createElement('div');
                    toastContainer.id = 'toastContainer';
                    toastContainer.style.cssText = 'position: fixed; bottom: 20px; right: 20px; z-index: 9999;';
                    document.body.appendChild(toastContainer);
                }
                
                var toast = document.createElement('div');
                toast.style.cssText = 'background: white; border-radius: 8px; padding: 15px 20px; ' +
                                     'box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; ' +
                                     'align-items: center; gap: 12px; margin-top: 10px; ' +
                                     'min-width: 300px; border-left: 4px solid #3b82f6; ' +
                                     'animation: slideIn 0.3s ease;';
                
                if (type === 'success') {
                    toast.style.borderLeftColor = '#10b981';
                } else if (type === 'error') {
                    toast.style.borderLeftColor = '#ef4444';
                } else if (type === 'warning') {
                    toast.style.borderLeftColor = '#f59e0b';
                }
                
                var icon = document.createElement('i');
                icon.className = 'fas ' + 
                    (type === 'success' ? 'fa-check-circle' : 
                     type === 'error' ? 'fa-exclamation-circle' : 
                     'fa-info-circle');
                icon.style.color = type === 'success' ? '#10b981' : 
                                  type === 'error' ? '#ef4444' : 
                                  type === 'warning' ? '#f59e0b' : '#3b82f6';
                
                var messageSpan = document.createElement('span');
                messageSpan.textContent = message;
                messageSpan.style.flex = '1';
                
                var closeBtn = document.createElement('button');
                closeBtn.innerHTML = '<i class="fas fa-times"></i>';
                closeBtn.style.cssText = 'background: none; border: none; color: #9ca3af; ' +
                                        'cursor: pointer; padding: 0; font-size: 0.9rem;';
                closeBtn.addEventListener('click', function() {
                    toast.remove();
                });
                
                toast.appendChild(icon);
                toast.appendChild(messageSpan);
                toast.appendChild(closeBtn);
                toastContainer.appendChild(toast);
                
                setTimeout(function() {
                    if (toast.parentNode === toastContainer) {
                        toast.remove();
                    }
                }, 5000);
            };
            
            // Add CSS for slideIn animation if not present
            if (!document.querySelector('#slideInStyle')) {
                var style = document.createElement('style');
                style.id = 'slideInStyle';
                style.textContent = `
                    @keyframes slideIn {
                        from {
                            opacity: 0;
                            transform: translateY(20px);
                        }
                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }
                    
                    .status-badge.active {
                        background: rgba(16, 185, 129, 0.1);
                        color: #10b981;
                        border: 1px solid rgba(16, 185, 129, 0.2);
                        padding: 6px 12px;
                        border-radius: 20px;
                        font-size: 0.85rem;
                        font-weight: 500;
                        display: inline-block;
                    }
                    
                    .status-badge.pending {
                        background: rgba(245, 158, 11, 0.1);
                        color: #f59e0b;
                        border: 1px solid rgba(245, 158, 11, 0.2);
                        padding: 6px 12px;
                        border-radius: 20px;
                        font-size: 0.85rem;
                        font-weight: 500;
                        display: inline-block;
                    }
                    
                    .status-badge.inactive {
                        background: rgba(107, 114, 128, 0.1);
                        color: #6b7280;
                        border: 1px solid rgba(107, 114, 128, 0.2);
                        padding: 6px 12px;
                        border-radius: 20px;
                        font-size: 0.85rem;
                        font-weight: 500;
                        display: inline-block;
                    }
                `;
                document.head.appendChild(style);
            }
        });
    </script>
</body>
</html>