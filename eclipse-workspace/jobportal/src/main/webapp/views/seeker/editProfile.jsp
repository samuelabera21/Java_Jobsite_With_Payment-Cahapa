<%@ page import="models.User" %>

<%
    User u = (User) request.getAttribute("user");
    String contextPath = request.getContextPath();
    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    <style>
        /* Additional styles for edit profile page */
        .edit-profile-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-header-section {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .page-header {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 5px;
        }
        
        .page-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: var(--radius-xl);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.8rem;
        }
        
        .page-subtitle {
            color: var(--text-secondary);
            font-size: 1.1rem;
            max-width: 500px;
            margin: 0 auto;
        }
        
        .profile-edit-card {
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            padding: 40px;
            box-shadow: var(--shadow-xl);
            border: 1px solid var(--border-light);
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--border-light);
        }
        
        .form-header h3 {
            font-size: 1.5rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .form-header h3 i {
            color: var(--primary);
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
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
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            background: var(--bg-primary);
        }
        
        .photo-upload-section {
            background: var(--bg-secondary);
            border-radius: var(--radius-xl);
            padding: 30px;
            border: 2px dashed var(--border-medium);
            text-align: center;
            margin-top: 10px;
            transition: all var(--transition-base);
        }
        
        .photo-upload-section:hover {
            border-color: var(--primary);
            background: var(--bg-tertiary);
        }
        
        .current-photo {
            margin-bottom: 20px;
        }
        
        .photo-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--primary);
            margin: 0 auto 15px;
            display: block;
        }
        
        .photo-placeholder {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.5rem;
        }
        
        .photo-instructions {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
        
        .file-input-wrapper {
            position: relative;
            display: inline-block;
        }
        
        .file-input-wrapper input[type="file"] {
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }
        
        .file-input-label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: var(--primary);
            color: white;
            border-radius: var(--radius-lg);
            cursor: pointer;
            font-weight: 500;
            transition: all var(--transition-base);
        }
        
        .file-input-label:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid var(--border-light);
        }
        
        .btn-save {
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
        
        .btn-save:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, var(--primary-dark), var(--secondary));
        }
        
        .btn-cancel {
            flex: 1;
            background: var(--bg-tertiary);
            color: var(--text-primary);
            padding: 16px;
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
            gap: 10px;
            text-align: center;
        }
        
        .btn-cancel:hover {
            background: var(--border-light);
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }
        
        @media (max-width: 768px) {
            .edit-profile-container {
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
            
            .profile-edit-card {
                padding: 25px;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .form-actions {
                flex-direction: column;
            }
        }
        
        @media (max-width: 480px) {
            .profile-edit-card {
                padding: 20px;
            }
            
            .photo-upload-section {
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
            <a href="<%= contextPath %>/seeker/dashboard" class="back-home">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Dashboard</span>
            </a>
            
            <div class="header-controls">
                <div class="current-date">
                    <i class="fas fa-user-edit"></i>
                    <span>Edit Profile</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <div class="edit-profile-container">
            <!-- Page Header -->
            <div class="page-header-section">
                <div class="page-header">
                    <div class="page-icon">
                        <i class="fas fa-user-edit"></i>
                    </div>
                    <h1 class="page-title">Edit Profile</h1>
                </div>
                <p class="page-subtitle">Update your personal information and profile details</p>
            </div>

            <!-- Success/Error Alerts -->
            <% if ("1".equals(successMsg)) { %>
                <div class="alert success fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Profile Updated Successfully!</h4>
                        <p>Your profile information has been saved.</p>
                    </div>
                </div>
            <% } %>
            
            <% if ("1".equals(errorMsg)) { %>
                <div class="alert danger fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Update Failed</h4>
                        <p>There was an error updating your profile. Please try again.</p>
                    </div>
                </div>
            <% } %>

            <!-- Profile Edit Form -->
            <div class="profile-edit-card">
                <div class="form-header">
                    <h3><i class="fas fa-user-cog"></i> Personal Information</h3>
                </div>

                <form action="<%= contextPath %>/seeker/editProfile" 
                      method="post" 
                      enctype="multipart/form-data"
                      id="editProfileForm">
                    
                    <div class="form-grid">
                        <!-- Name Field -->
                        <div class="form-group">
                            <label for="name" class="form-label">
                                <i class="fas fa-user"></i> Full Name
                            </label>
                            <input type="text" 
                                   id="name" 
                                   name="name" 
                                   class="form-control" 
                                   value="<%= u.getName() != null ? u.getName() : "" %>" 
                                   placeholder="Enter your full name"
                                   required>
                        </div>
                        
                        <!-- Email Field -->
                        <div class="form-group">
                            <label for="email" class="form-label">
                                <i class="fas fa-envelope"></i> Email Address
                            </label>
                            <input type="email" 
                                   id="email" 
                                   name="email" 
                                   class="form-control" 
                                   value="<%= u.getEmail() != null ? u.getEmail() : "" %>" 
                                   placeholder="your.email@example.com"
                                   required>
                        </div>
                        
                        <!-- Phone Field -->
                        <div class="form-group">
                            <label for="phone" class="form-label">
                                <i class="fas fa-phone"></i> Phone Number
                            </label>
                            <input type="text" 
                                   id="phone" 
                                   name="phone" 
                                   class="form-control" 
                                   value="<%= u.getPhone() != null ? u.getPhone() : "" %>" 
                                   placeholder="+1234567890">
                        </div>
                        
                        <!-- Profile Photo Field -->
                        <div class="form-group full-width">
                            <label class="form-label">
                                <i class="fas fa-camera"></i> Profile Photo
                            </label>
                            
                            <div class="photo-upload-section">
                                <div class="current-photo">
                                    <!-- Since your User model doesn't have getAvatar(), we'll just show a placeholder -->
                                    <div class="photo-placeholder">
                                        <i class="fas fa-user"></i>
                                    </div>
                                </div>
                                
                                <div class="photo-instructions">
                                    Upload a clear photo of yourself (JPG, PNG, Max 2MB)
                                </div>
                                
                                <div class="file-input-wrapper">
                                    <input type="file" 
                                           id="avatar" 
                                           name="avatar" 
                                           accept="image/*"
                                           onchange="EditProfile.previewImage(this)">
                                    <label for="avatar" class="file-input-label">
                                        <i class="fas fa-upload"></i>
                                        Choose Photo
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="<%= contextPath %>/seeker/profile" class="btn-cancel">
                            <i class="fas fa-times"></i>
                            Cancel
                        </a>
                        <button type="submit" class="btn-save">
                            <i class="fas fa-save"></i>
                            Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - Edit Profile. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/seeker/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span></span>
                <a href="<%= contextPath %>/seeker/profile"><i class="fas fa-user"></i> View Profile</a>
                <span></span>
                <a href="<%= contextPath %>/seeker/viewJobs"><i class="fas fa-briefcase"></i> View Jobs</a>
                <span></span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- JavaScript -->
    <script>
    /**
     * Edit Profile Page JavaScript
     * ES5 Compatible for Eclipse
     */
    
    var EditProfile = {
        init: function() {
            this.setupThemeToggle();
            this.setupFormValidation();
            this.setupImagePreview();
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
            var form = document.getElementById('editProfileForm');
            if (!form) return;
            
            form.addEventListener('submit', function(e) {
                var nameInput = document.getElementById('name');
                var emailInput = document.getElementById('email');
                var avatarInput = document.getElementById('avatar');
                
                // Validate name
                if (!nameInput.value.trim()) {
                    e.preventDefault();
                    alert('Please enter your name');
                    nameInput.focus();
                    return;
                }
                
                // Validate email
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(emailInput.value)) {
                    e.preventDefault();
                    alert('Please enter a valid email address');
                    emailInput.focus();
                    return;
                }
                
                // Validate file if selected
                if (avatarInput.files && avatarInput.files.length > 0) {
                    var file = avatarInput.files[0];
                    var maxSize = 2 * 1024 * 1024; // 2MB
                    var allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
                    
                    if (!allowedTypes.includes(file.type)) {
                        e.preventDefault();
                        alert('Please upload only JPG, PNG, or GIF images');
                        return;
                    }
                    
                    if (file.size > maxSize) {
                        e.preventDefault();
                        alert('Image size should be less than 2MB');
                        return;
                    }
                }
                
                // Show loading
                EditProfile.showLoading();
            });
        },
        
        setupImagePreview: function() {
            // Preview function is called from onchange attribute
        },
        
        previewImage: function(input) {
            var preview = document.getElementById('photoPreview');
            var placeholder = document.querySelector('.photo-placeholder');
            
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                
                reader.onload = function(e) {
                    // Remove placeholder if exists
                    if (placeholder) {
                        placeholder.style.display = 'none';
                    }
                    
                    // Create preview image if it doesn't exist
                    if (!preview) {
                        preview = document.createElement('img');
                        preview.id = 'photoPreview';
                        preview.className = 'photo-preview';
                        var currentPhoto = document.querySelector('.current-photo');
                        if (currentPhoto) {
                            currentPhoto.appendChild(preview);
                        }
                    }
                    
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                };
                
                reader.readAsDataURL(input.files[0]);
            }
        },
        
        showLoading: function() {
            // Create a simple loading overlay
            var overlay = document.createElement('div');
            overlay.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); display: flex; align-items: center; justify-content: center; z-index: 1000;';
            overlay.innerHTML = '<div style="background: var(--bg-card); padding: 30px; border-radius: var(--radius-xl); text-align: center; border: 1px solid var(--border-light);"><i class="fas fa-spinner fa-spin" style="font-size: 2rem; color: var(--primary);"></i><p style="margin-top: 15px; color: var(--text-primary);">Saving Profile...</p></div>';
            overlay.id = 'loadingOverlay';
            document.body.appendChild(overlay);
            document.body.style.overflow = 'hidden';
        }
    };
    
    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            EditProfile.init();
        });
    } else {
        EditProfile.init();
    }
    
    
    </script>
</body>
</html>