<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String contextPath = request.getContextPath();
    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
    String mismatchMsg = request.getParameter("mismatch");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - Employer - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    
    <style>
        /* Use the exact same CSS as seeker's changePassword.jsp */
        /* Just change the theme colors to employer theme */
        
        :root {
            --primary: #4f46e5;
            --primary-dark: #4338ca;
            --primary-light: #818cf8;
            --secondary: #7c3aed;
            --secondary-dark: #6d28d9;
        }
        
        .change-password-container {
            max-width: 600px;
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
        
        .password-form-card {
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
        
        .input-with-icon {
            position: relative;
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
            padding-right: 50px;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            background: var(--bg-primary);
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-secondary);
            cursor: pointer;
            padding: 5px;
            border-radius: var(--radius-sm);
            transition: all var(--transition-base);
        }
        
        .password-toggle:hover {
            color: var(--primary);
            background: var(--bg-tertiary);
        }
        
        .password-strength {
            margin-top: 10px;
            padding: 10px;
            border-radius: var(--radius-lg);
            background: var(--bg-secondary);
            display: none;
        }
        
        .strength-meter {
            height: 6px;
            background: var(--border-light);
            border-radius: var(--radius-full);
            margin: 8px 0;
            overflow: hidden;
        }
        
        .strength-fill {
            height: 100%;
            width: 0%;
            border-radius: var(--radius-full);
            transition: width var(--transition-base);
        }
        
        .strength-weak .strength-fill {
            background: var(--danger);
            width: 33%;
        }
        
        .strength-medium .strength-fill {
            background: var(--warning);
            width: 66%;
        }
        
        .strength-strong .strength-fill {
            background: var(--success);
            width: 100%;
        }
        
        .strength-text {
            font-size: 0.85rem;
            color: var(--text-secondary);
            display: flex;
            justify-content: space-between;
        }
        
        .password-requirements {
            background: var(--bg-secondary);
            border-radius: var(--radius-lg);
            padding: 20px;
            margin-top: 25px;
            border: 1px solid var(--border-light);
        }
        
        .password-requirements h4 {
            color: var(--text-primary);
            font-size: 1rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .requirements-list {
            list-style: none;
            padding: 0;
        }
        
        .requirements-list li {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .requirements-list li i {
            color: var(--text-muted);
            font-size: 0.8rem;
        }
        
        .requirements-list li.valid i {
            color: var(--success);
        }
        
        .requirements-list li.valid {
            color: var(--success);
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid var(--border-light);
        }
        
        .btn-change {
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
        
        .btn-change:hover {
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
            .change-password-container {
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
            
            .password-form-card {
                padding: 25px;
            }
            
            .form-actions {
                flex-direction: column;
            }
        }
        
        @media (max-width: 480px) {
            .password-form-card {
                padding: 20px;
            }
            
            .password-requirements {
                padding: 15px;
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
                    <i class="fas fa-key"></i>
                    <span>Change Password</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <div class="change-password-container">
            <!-- Page Header -->
            <div class="page-header-section">
                <div class="page-header">
                    <div class="page-icon">
                        <i class="fas fa-key"></i>
                    </div>
                    <h1 class="page-title">Change Password</h1>
                </div>
                <p class="page-subtitle">Update your password to keep your account secure</p>
            </div>

            <!-- Success/Error Alerts -->
            <% if ("1".equals(successMsg)) { %>
                <div class="alert success fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Password Changed Successfully!</h4>
                        <p>Your password has been updated. Please use your new password for future logins.</p>
                    </div>
                </div>
            <% } %>
            
            <% if ("1".equals(errorMsg)) { %>
                <div class="alert danger fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Password Change Failed</h4>
                        <p>There was an error updating your password. Please try again.</p>
                    </div>
                </div>
            <% } %>
            
            <% if ("nomatch".equals(errorMsg)) { %>
                <div class="alert danger fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Passwords Don't Match</h4>
                        <p>New password and confirm password do not match. Please try again.</p>
                    </div>
                </div>
            <% } %>

            <!-- Password Form Card -->
            <div class="password-form-card">
                <div class="form-header">
                    <h3><i class="fas fa-user-shield"></i> Security Settings</h3>
                </div>

                <form action="<%= contextPath %>/employer/changePassword" 
                      method="post"
                      id="changePasswordForm">
                    
                    <!-- New Password Field -->
                    <div class="form-group">
                        <label for="new_password" class="form-label">
                            <i class="fas fa-lock"></i> New Password
                        </label>
                        <div class="input-with-icon">
                            <input type="password" 
                                   id="new_password" 
                                   name="new_password" 
                                   class="form-control" 
                                   placeholder="Enter your new password"
                                   required
                                   oninput="PasswordManager.checkStrength(this.value)">
                            <button type="button" class="password-toggle" onclick="PasswordManager.togglePassword('new_password', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="password-strength" id="passwordStrength">
                            <div class="strength-meter">
                                <div class="strength-fill"></div>
                            </div>
                            <div class="strength-text">
                                <span>Password Strength:</span>
                                <span id="strengthLabel">Weak</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Confirm Password Field -->
                    <div class="form-group">
                        <label for="confirm_password" class="form-label">
                            <i class="fas fa-lock"></i> Confirm Password
                        </label>
                        <div class="input-with-icon">
                            <input type="password" 
                                   id="confirm_password" 
                                   name="confirm_password" 
                                   class="form-control" 
                                   placeholder="Confirm your new password"
                                   required
                                   oninput="PasswordManager.checkMatch()">
                            <button type="button" class="password-toggle" onclick="PasswordManager.togglePassword('confirm_password', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div id="passwordMatch" style="margin-top: 8px; font-size: 0.9rem; display: none;">
                            <i class="fas fa-check-circle" style="color: var(--success);"></i>
                            <span style="color: var(--success);">Passwords match</span>
                        </div>
                        <div id="passwordMismatch" style="margin-top: 8px; font-size: 0.9rem; display: none;">
                            <i class="fas fa-times-circle" style="color: var(--danger);"></i>
                            <span style="color: var(--danger);">Passwords do not match</span>
                        </div>
                    </div>

                    <!-- Password Requirements -->
                    <div class="password-requirements">
                        <h4><i class="fas fa-info-circle"></i> Password Requirements</h4>
                        <ul class="requirements-list" id="requirementsList">
                            <li id="reqLength">
                                <i class="fas fa-circle"></i>
                                At least 8 characters
                            </li>
                            <li id="reqUppercase">
                                <i class="fas fa-circle"></i>
                                At least one uppercase letter
                            </li>
                            <li id="reqLowercase">
                                <i class="fas fa-circle"></i>
                                At least one lowercase letter
                            </li>
                            <li id="reqNumber">
                                <i class="fas fa-circle"></i>
                                At least one number
                            </li>
                            <li id="reqSpecial">
                                <i class="fas fa-circle"></i>
                                At least one special character
                            </li>
                        </ul>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <a href="<%= contextPath %>/employer/profile" class="btn-cancel">
                            <i class="fas fa-times"></i>
                            Cancel
                        </a>
                        <button type="submit" class="btn-change">
                            <i class="fas fa-key"></i>
                            Change Password
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - Change Password. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/employer/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span>•</span>
                <a href="<%= contextPath %>/employer/profile"><i class="fas fa-building"></i> Profile</a>
                <span>•</span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- JavaScript -->
    <script>
    var PasswordManager = {
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
        
        setupFormValidation: function() {
            var form = document.getElementById('changePasswordForm');
            if (!form) return;
            
            form.addEventListener('submit', function(e) {
                var newPassword = document.getElementById('new_password').value;
                var confirmPassword = document.getElementById('confirm_password').value;
                
                // Check if passwords match
                if (newPassword !== confirmPassword) {
                    e.preventDefault();
                    alert('New password and confirm password do not match.');
                    document.getElementById('confirm_password').focus();
                    return;
                }
                
                // Check password strength
                var strength = PasswordManager.checkStrength(newPassword, true);
                if (strength === 'weak') {
                    if (!confirm('Your password is weak. Are you sure you want to use this password?')) {
                        e.preventDefault();
                        return;
                    }
                }
                
                // Check all requirements
                var requirements = PasswordManager.checkRequirements(newPassword);
                var allValid = true;
                for (var key in requirements) {
                    if (!requirements[key]) {
                        allValid = false;
                        break;
                    }
                }
                
                if (!allValid) {
                    e.preventDefault();
                    alert('Please make sure your password meets all requirements.');
                    return;
                }
                
                // Show loading
                PasswordManager.showLoading();
            });
        },
        
        togglePassword: function(inputId, button) {
            var input = document.getElementById(inputId);
            var icon = button.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'fas fa-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'fas fa-eye';
            }
        },
        
        checkStrength: function(password, returnOnly) {
            var strengthDiv = document.getElementById('passwordStrength');
            var strengthLabel = document.getElementById('strengthLabel');
            var strengthFill = document.querySelector('.strength-fill');
            var strengthClass = 'strength-weak';
            var label = 'Weak';
            var score = 0;
            
            // Length check
            if (password.length >= 8) score++;
            if (password.length >= 12) score++;
            
            // Character variety checks
            if (/[A-Z]/.test(password)) score++;
            if (/[a-z]/.test(password)) score++;
            if (/[0-9]/.test(password)) score++;
            if (/[^A-Za-z0-9]/.test(password)) score++;
            
            // Determine strength
            if (score >= 5) {
                strengthClass = 'strength-strong';
                label = 'Strong';
            } else if (score >= 3) {
                strengthClass = 'strength-medium';
                label = 'Medium';
            } else {
                strengthClass = 'strength-weak';
                label = 'Weak';
            }
            
            if (password.length > 0) {
                strengthDiv.style.display = 'block';
                strengthDiv.className = 'password-strength ' + strengthClass;
                strengthLabel.textContent = label;
            } else {
                strengthDiv.style.display = 'none';
            }
            
            // Update requirements
            this.checkRequirements(password);
            
            if (returnOnly) {
                return strengthClass.replace('strength-', '');
            }
        },
        
        checkRequirements: function(password) {
            var requirements = {
                length: password.length >= 8,
                uppercase: /[A-Z]/.test(password),
                lowercase: /[a-z]/.test(password),
                number: /[0-9]/.test(password),
                special: /[^A-Za-z0-9]/.test(password)
            };
            
            // Update UI
            var reqIds = ['reqLength', 'reqUppercase', 'reqLowercase', 'reqNumber', 'reqSpecial'];
            var reqKeys = Object.keys(requirements);
            
            for (var i = 0; i < reqIds.length; i++) {
                var element = document.getElementById(reqIds[i]);
                if (element) {
                    element.className = requirements[reqKeys[i]] ? 'valid' : '';
                    var icon = element.querySelector('i');
                    if (icon) {
                        icon.className = requirements[reqKeys[i]] ? 'fas fa-check-circle' : 'fas fa-circle';
                    }
                }
            }
            
            return requirements;
        },
        
        checkMatch: function() {
            var newPassword = document.getElementById('new_password').value;
            var confirmPassword = document.getElementById('confirm_password').value;
            var matchDiv = document.getElementById('passwordMatch');
            var mismatchDiv = document.getElementById('passwordMismatch');
            
            if (confirmPassword.length === 0) {
                if (matchDiv) matchDiv.style.display = 'none';
                if (mismatchDiv) mismatchDiv.style.display = 'none';
                return;
            }
            
            if (newPassword === confirmPassword) {
                if (matchDiv) matchDiv.style.display = 'block';
                if (mismatchDiv) mismatchDiv.style.display = 'none';
            } else {
                if (matchDiv) matchDiv.style.display = 'none';
                if (mismatchDiv) mismatchDiv.style.display = 'block';
            }
        },
        
        showLoading: function() {
            var overlay = document.createElement('div');
            overlay.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); display: flex; align-items: center; justify-content: center; z-index: 1000;';
            overlay.innerHTML = '<div style="background: var(--bg-card); padding: 30px; border-radius: var(--radius-xl); text-align: center; border: 1px solid var(--border-light);"><i class="fas fa-spinner fa-spin" style="font-size: 2rem; color: #4f46e5;"></i><p style="margin-top: 15px; color: var(--text-primary);">Updating Password...</p></div>';
            overlay.id = 'loadingOverlay';
            document.body.appendChild(overlay);
            document.body.style.overflow = 'hidden';
        }
    };
    
    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            PasswordManager.init();
        });
    } else {
        PasswordManager.init();
    }
    </script>
</body>
</html>