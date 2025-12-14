<%@ page import="models.User" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.UserDAOImpl" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String contextPath = request.getContextPath();
    
    // Get user from session (for consistency)
    // ========== SECURITY CHECK ==========
// Verify this is a seeker
Integer seekerId = (Integer) session.getAttribute("seekerId");
if (seekerId == null) {
    // Not logged in as seeker - redirect to login
    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
    return;
}
// ========== END SECURITY CHECK ==========

// Get user from session - use seekerUser for seekers
User user = (User) session.getAttribute("seekerUser");

// If not in session, try generic user attribute
if (user == null) {
    user = (User) session.getAttribute("user"); // Fallback to generic user
}

// Optional: If still null, try to fetch using seekerId
if (user == null) {
    try {
        UserDAO userDAO = new UserDAOImpl();
        user = userDAO.getById(seekerId);
        // Verify this is a seeker
        if (user != null && "seeker".equalsIgnoreCase(user.getRole())) {
            session.setAttribute("seekerUser", user); // Store as seekerUser
            session.setAttribute("user", user); // Also store as generic user
        } else if (user != null) {
            // Wrong role - don't use
            user = null;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Job Alert - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    
    <style>
        /* Additional styles for Create Alert page */
        .create-alert-container {
            max-width: 1200px;
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
            max-width: 600px;
            margin: 0 auto;
        }
        
        .form-card {
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            padding: 40px;
            box-shadow: var(--shadow-xl);
            border: 1px solid var(--border-light);
            max-width: 800px;
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
            color: var(--primary);
        }
        
        .form-section {
            margin-bottom: 35px;
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
            color: var(--primary);
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
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            background: var(--bg-primary);
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
            color: var(--primary);
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
        
        .frequency-options {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-top: 10px;
        }
        
        .frequency-option {
            position: relative;
        }
        
        .frequency-option input {
            position: absolute;
            opacity: 0;
        }
        
        .frequency-label {
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
        
        .frequency-option input:checked + .frequency-label {
            background: var(--primary-light);
            border-color: var(--primary);
            color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .frequency-icon {
            width: 50px;
            height: 50px;
            background: var(--bg-tertiary);
            border-radius: var(--radius-full);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            color: var(--primary);
            margin-bottom: 10px;
            transition: all var(--transition-base);
        }
        
        .frequency-option input:checked + .frequency-label .frequency-icon {
            background: var(--primary);
            color: white;
        }
        
        .frequency-name {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .frequency-description {
            font-size: 0.85rem;
            color: var(--text-muted);
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
            background: linear-gradient(135deg, var(--primary), var(--secondary));
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
            background: linear-gradient(135deg, var(--primary-dark), var(--secondary));
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
        
        .character-count {
            text-align: right;
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-top: 5px;
        }
        
        @media (max-width: 992px) {
            .create-alert-container {
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
            
            .frequency-options {
                grid-template-columns: repeat(2, 1fr);
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
            
            .frequency-options {
                grid-template-columns: 1fr;
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
        }
    </style>
</head>
<body>
    <!-- Main Container -->
    <div class="dashboard-container">
        <!-- Header -->
        <header class="dashboard-header">
            <a href="<%= contextPath %>/seeker/jobAlerts" class="back-home">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Alerts</span>
            </a>
            
            <div class="header-controls">
                <div class="current-date">
                    <i class="fas fa-bell"></i>
                    <span>Create Alert</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <div class="create-alert-container">
            <!-- Page Header -->
            <div class="page-header-section">
                <div class="page-header">
                    <div class="page-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <h1 class="page-title">Create Job Alert</h1>
                </div>
                <p class="page-subtitle">Set up personalized alerts to get notified about new job opportunities</p>
            </div>

            <!-- Form Card -->
            <div class="form-card">
                <!-- EXACT SAME FORM ACTION AND FIELDS AS ORIGINAL -->
                <form action="<%= contextPath %>/seeker/addAlert" method="post" id="createAlertForm">
                    
                    <div class="form-header">
                        <h3>
                            <i class="fas fa-bell"></i>
                            Alert Settings
                        </h3>
                    </div>
                    
                    <!-- Keywords Section -->
                    <div class="form-section">
                        <div class="form-group">
                            <label for="keywords" class="form-label">
                                <i class="fas fa-key"></i>
                                Keywords
                            </label>
                            <div class="input-with-icon">
                                <i class="fas fa-search input-icon"></i>
                                <input type="text" 
                                       id="keywords" 
                                       name="keywords" 
                                       class="form-control" 
                                       placeholder="e.g., Java Developer, Remote, Entry Level"
                                       maxlength="200">
                            </div>
                            <div class="character-count" id="keywordsCount">
                                0 / 200 characters
                            </div>
                            <div class="form-hint">
                                <i class="fas fa-lightbulb"></i>
                                <span>Enter comma-separated keywords or job titles to search for</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Location Section -->
                    <div class="form-section">
                        <div class="form-group">
                            <label for="location" class="form-label">
                                <i class="fas fa-map-marker-alt"></i>
                                Location
                            </label>
                            <div class="input-with-icon">
                                <i class="fas fa-globe input-icon"></i>
                                <input type="text" 
                                       id="location" 
                                       name="location" 
                                       class="form-control" 
                                       placeholder="e.g., New York, Remote, Anywhere"
                                       maxlength="100">
                            </div>
                            <div class="character-count" id="locationCount">
                                0 / 100 characters
                            </div>
                            <div class="form-hint">
                                <i class="fas fa-lightbulb"></i>
                                <span>Leave empty to search jobs from any location</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Frequency Section -->
                    <div class="form-section">
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-clock"></i>
                                Frequency
                            </label>
                            
                            <!-- Visual Frequency Options -->
                            <div class="frequency-options">
                                <div class="frequency-option">
                                    <input type="radio" id="frequency-daily" name="frequency" value="daily" checked>
                                    <label for="frequency-daily" class="frequency-label">
                                        <div class="frequency-icon">
                                            <i class="fas fa-sun"></i>
                                        </div>
                                        <div class="frequency-name">Daily</div>
                                        <div class="frequency-description">Get alerts every day</div>
                                    </label>
                                </div>
                                
                                <div class="frequency-option">
                                    <input type="radio" id="frequency-weekly" name="frequency" value="weekly">
                                    <label for="frequency-weekly" class="frequency-label">
                                        <div class="frequency-icon">
                                            <i class="fas fa-calendar-week"></i>
                                        </div>
                                        <div class="frequency-name">Weekly</div>
                                        <div class="frequency-description">Get alerts every week</div>
                                    </label>
                                </div>
                                
                                <div class="frequency-option">
                                    <input type="radio" id="frequency-monthly" name="frequency" value="monthly">
                                    <label for="frequency-monthly" class="frequency-label">
                                        <div class="frequency-icon">
                                            <i class="fas fa-calendar-alt"></i>
                                        </div>
                                        <div class="frequency-name">Monthly</div>
                                        <div class="frequency-description">Get alerts every month</div>
                                    </label>
                                </div>
                            </div>
                            
                            <!-- Original select (hidden, for fallback) -->
                            <select name="frequency" class="form-control" style="display: none;">
                                <option value="daily" selected>Daily</option>
                                <option value="weekly">Weekly</option>
                                <option value="monthly">Monthly</option>
                            </select>
                            
                            <div class="form-hint">
                                <i class="fas fa-info-circle"></i>
                                <span>How often you want to receive email notifications</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Form Actions -->
                    <div class="form-actions">
                        <a href="<%= contextPath %>/seeker/jobAlerts" class="btn-cancel">
                            <i class="fas fa-times"></i>
                            Cancel
                        </a>
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-bell"></i>
                            Create Alert
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - Create Job Alert. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/seeker/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/jobAlerts"><i class="fas fa-bell"></i> My Alerts</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/jobs"><i class="fas fa-briefcase"></i> Browse Jobs</a>
                <span>•</span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <i class="fas fa-cog fa-spin"></i>
            <p>Creating Alert...</p>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
    /**
     * Create Alert JavaScript
     * ES5 Compatible for Eclipse
     */
    
    var CreateAlert = {
        init: function() {
            this.setupThemeToggle();
            this.setupFormValidation();
            this.setupCharacterCounters();
            this.setupFrequencySelection();
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
            var form = document.getElementById('createAlertForm');
            if (!form) return;
            
            form.addEventListener('submit', function(e) {
                var keywords = document.getElementById('keywords').value.trim();
                
                // Basic validation
                if (keywords.length === 0) {
                    e.preventDefault();
                    alert('Please enter at least one keyword for your job alert.');
                    document.getElementById('keywords').focus();
                    return;
                }
                
                // Show loading
                CreateAlert.showLoading();
            });
        },
        
        setupCharacterCounters: function() {
            var keywordsInput = document.getElementById('keywords');
            var locationInput = document.getElementById('location');
            
            if (keywordsInput) {
                keywordsInput.addEventListener('input', function() {
                    document.getElementById('keywordsCount').textContent = 
                        this.value.length + ' / 200 characters';
                });
                // Initialize count
                document.getElementById('keywordsCount').textContent = 
                    keywordsInput.value.length + ' / 200 characters';
            }
            
            if (locationInput) {
                locationInput.addEventListener('input', function() {
                    document.getElementById('locationCount').textContent = 
                        this.value.length + ' / 100 characters';
                });
                // Initialize count
                document.getElementById('locationCount').textContent = 
                    locationInput.value.length + ' / 100 characters';
            }
        },
        
        setupFrequencySelection: function() {
            var radioOptions = document.querySelectorAll('.frequency-option input[type="radio"]');
            var hiddenSelect = document.querySelector('select[name="frequency"]');
            
            if (radioOptions.length > 0 && hiddenSelect) {
                // Sync radio selection with hidden select
                for (var i = 0; i < radioOptions.length; i++) {
                    radioOptions[i].addEventListener('change', function() {
                        hiddenSelect.value = this.value;
                    });
                }
                
                // Set initial value
                var checkedRadio = document.querySelector('.frequency-option input[type="radio"]:checked');
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
                overlay.innerHTML = '<div class="loading-spinner"><i class="fas fa-cog fa-spin"></i><p>Creating Alert...</p></div>';
                document.body.appendChild(overlay);
            }
            overlay.style.display = 'flex';
            document.body.style.overflow = 'hidden';
        },
        
        escapeHtml: function(text) {
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
    };
    
    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            CreateAlert.init();
        });
    } else {
        CreateAlert.init();
    }
    </script>
</body>
</html>