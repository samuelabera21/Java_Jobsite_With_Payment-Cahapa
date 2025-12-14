<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%
    String contextPath = request.getContextPath();
    String updated = request.getParameter("updated");
    String siteName = (String) request.getAttribute("site_name");
    String adminEmail = (String) request.getAttribute("admin_email");
    String allowRegistration = (String) request.getAttribute("allow_registration");
    String employerStatus = (String) request.getAttribute("employer_default_status");
    
    // Default values if null
    if (siteName == null) siteName = "JobPortal";
    if (adminEmail == null) adminEmail = "admin@jobportal.com";
    if (allowRegistration == null) allowRegistration = "true";
    if (employerStatus == null) employerStatus = "pending";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Settings - Admin Dashboard</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/system_settings.css">
    
    <!-- JavaScript -->
    <script src="<%= contextPath %>/assets/js/system_settings.js" defer></script>
</head>
<body>
    <!-- Main Container -->
    <div class="admin-container">
        <!-- Header -->
        <header class="admin-header">
            <a href="<%= contextPath %>/admin/dashboard" class="back-dashboard">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Dashboard</span>
            </a>
            
            <div class="header-controls">
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <!-- Settings Container -->
        <div class="settings-container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-icon">
                    <i class="fas fa-cogs"></i>
                </div>
                <h1 class="page-title">System Settings</h1>
                <p class="page-subtitle">Configure and manage your job portal system preferences</p>
            </div>

            <!-- Success Alert -->
            <% if ("1".equals(updated)) { %>
                <div class="alert success">
                    <div class="alert-icon">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Settings Updated Successfully!</h4>
                        <p>Your changes have been saved and applied to the system.</p>
                    </div>
                </div>
            <% } %>

            <!-- Settings Form -->
            <form action="<%= contextPath %>/admin/updateSystemSettings" method="post" class="settings-form" id="settingsForm">
                
                <!-- General Settings -->
                <div class="settings-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-globe"></i>
                        </div>
                        <h3 class="card-title">General Settings</h3>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-sitemap"></i>
                            Site Name
                        </label>
                        <input type="text" 
                               name="site_name" 
                               class="form-control"
                               value="<%= siteName %>"
                               placeholder="Enter your site name"
                               required>
                        <span class="form-help">This name will appear in browser tabs and emails</span>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-envelope"></i>
                            Admin Email
                        </label>
                        <input type="email" 
                               name="admin_email" 
                               class="form-control"
                               value="<%= adminEmail %>"
                               placeholder="admin@example.com"
                               required>
                        <span class="form-help">System notifications will be sent to this email</span>
                    </div>
                </div>

                <!-- Registration Settings -->
                <div class="settings-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <h3 class="card-title">Registration Settings</h3>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-user-check"></i>
                            Allow New User Registrations
                        </label>
                        <select name="allow_registration" class="form-control form-select">
                            <option value="true" <%= "true".equals(allowRegistration) ? "selected" : "" %>>✅ Yes - Allow new registrations</option>
                            <option value="false" <%= "false".equals(allowRegistration) ? "selected" : "" %>>❌ No - Disable new registrations</option>
                        </select>
                        <span class="form-help">When disabled, new users cannot create accounts</span>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-building"></i>
                            Default Employer Account Status
                        </label>
                        <select name="employer_default_status" class="form-control form-select">
                            <option value="pending" <%= "pending".equals(employerStatus) ? "selected" : "" %>>⏳ Pending - Manual approval required</option>
                            <option value="approved" <%= "approved".equals(employerStatus) ? "selected" : "" %>>✅ Approved - Auto-approve new employers</option>
                            <option value="active" <%= "active".equals(employerStatus) ? "selected" : "" %>>🚀 Active - Auto-activate new employers</option>
                        </select>
                        <span class="form-help">Determines the initial status for new employer registrations</span>
                    </div>
                </div>

                <!-- Advanced Settings (Example placeholder) -->
                <div class="settings-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-sliders-h"></i>
                        </div>
                        <h3 class="card-title">Advanced Settings</h3>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-clock"></i>
                            Session Timeout (Minutes)
                        </label>
                        <input type="number" 
                               name="session_timeout" 
                               class="form-control"
                               value="30"
                               min="5"
                               max="240"
                               placeholder="30">
                        <span class="form-help">User session timeout in minutes (5-240)</span>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-file-alt"></i>
                            Items Per Page
                        </label>
                        <select name="items_per_page" class="form-control form-select">
                            <option value="10">10 items</option>
                            <option value="25" selected>25 items</option>
                            <option value="50">50 items</option>
                            <option value="100">100 items</option>
                        </select>
                        <span class="form-help">Number of items displayed per page in lists</span>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <div>
                        <a href="<%= contextPath %>/admin/dashboard" class="btn btn-secondary">
                            <i class="fas fa-times"></i>
                            Cancel
                        </a>
                    </div>
                    
                    <div style="display: flex; gap: 15px;">
                        <button type="button" class="btn btn-secondary" id="resetBtn">
                            <i class="fas fa-redo"></i>
                            Reset
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Save Settings
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Footer -->
        <footer class="admin-footer">
            <p>&copy; 2025 JobPortal Admin System. All rights reserved.</p>
            <div class="footer-links">
                <a href="#"><i class="fas fa-shield-alt"></i> Privacy</a>
                <span>•</span>
                <a href="#"><i class="fas fa-file-contract"></i> Terms</a>
                <span>•</span>
                <a href="#"><i class="fas fa-question-circle"></i> Help</a>
                <span>•</span>
                <a href="#"><i class="fas fa-envelope"></i> Contact</a>
            </div>
        </footer>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <i class="fas fa-cog fa-spin"></i>
            <p>Saving Settings...</p>
        </div>
    </div>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>

    <script>
        // Additional inline script for form reset
        document.addEventListener('DOMContentLoaded', function() {
            const resetBtn = document.getElementById('resetBtn');
            if (resetBtn) {
                resetBtn.addEventListener('click', function() {
                    if (confirm('Are you sure you want to reset all settings to their default values?')) {
                        // This would reset to server defaults
                        // For now, just show a toast
                        if (window.systemSettingsApp) {
                            window.systemSettingsApp.showToast('Reset functionality would reload defaults from server', 'info');
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>