<%@ page import="java.util.List" %>
<%@ page import="models.CVTemplate" %>
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
    
    List<CVTemplate> list = (List<CVTemplate>) request.getAttribute("templates");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CV Templates - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    
    <style>
        /* Additional styles for CV Templates page */
        .templates-container {
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
        
        .templates-card {
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            padding: 40px;
            box-shadow: var(--shadow-xl);
            border: 1px solid var(--border-light);
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--border-light);
        }
        
        .section-title {
            font-size: 1.8rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }
        
        .section-title i {
            color: var(--primary);
        }
        
        .section-description {
            color: var(--text-secondary);
            font-size: 1rem;
            margin-top: 10px;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .no-templates-message {
            text-align: center;
            padding: 60px 40px;
            background: var(--bg-secondary);
            border-radius: var(--radius-xl);
            border: 2px dashed var(--border-light);
        }
        
        .no-templates-icon {
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
        
        .no-templates-title {
            font-size: 1.5rem;
            color: var(--text-primary);
            margin-bottom: 10px;
        }
        
        .no-templates-description {
            color: var(--text-secondary);
            margin-bottom: 25px;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .templates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
        }
        
        .template-card {
            background: var(--bg-primary);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border-light);
            overflow: hidden;
            transition: all var(--transition-base);
            display: flex;
            flex-direction: column;
        }
        
        .template-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-light);
        }
        
        .template-preview {
            height: 200px;
            background: linear-gradient(135deg, var(--primary-light), var(--secondary-light));
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        
        .template-preview-content {
            width: 80%;
            height: 150px;
            background: white;
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-md);
            padding: 20px;
            position: relative;
        }
        
        .preview-header {
            height: 15px;
            background: var(--primary);
            border-radius: var(--radius-sm);
            margin-bottom: 15px;
            width: 70%;
        }
        
        .preview-line {
            height: 8px;
            background: var(--bg-tertiary);
            border-radius: var(--radius-sm);
            margin-bottom: 8px;
        }
        
        .preview-line:nth-child(3) {
            width: 90%;
        }
        
        .preview-line:nth-child(4) {
            width: 80%;
        }
        
        .preview-line:nth-child(5) {
            width: 85%;
        }
        
        .template-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--primary);
            color: white;
            padding: 6px 12px;
            border-radius: var(--radius-full);
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .template-content {
            padding: 25px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        .template-name {
            font-size: 1.3rem;
            color: var(--text-primary);
            margin-bottom: 10px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .template-name i {
            color: var(--primary);
        }
        
        .template-description {
            color: var(--text-secondary);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 20px;
            flex: 1;
        }
        
        .template-actions {
            display: flex;
            gap: 10px;
            margin-top: auto;
        }
        
        .btn-download {
            flex: 1;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 12px;
            border: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-base);
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-align: center;
        }
        
        .btn-download:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            background: linear-gradient(135deg, var(--primary-dark), var(--secondary));
        }
        
        .btn-preview {
            padding: 12px 20px;
            background: var(--bg-tertiary);
            color: var(--text-primary);
            border: 1px solid var(--border-light);
            border-radius: var(--radius-lg);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-base);
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-preview:hover {
            background: var(--border-light);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        
        .back-section {
            text-align: center;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid var(--border-light);
        }
        
        .back-link {
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
        }
        
        .back-link:hover {
            background: var(--border-light);
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }
        
        /* Preview Modal Styles */
        .preview-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1002;
            padding: 20px;
            backdrop-filter: blur(8px);
        }
        
        .preview-modal.active {
            display: flex;
            animation: fadeIn 0.3s ease;
        }
        
        .preview-content {
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            width: 100%;
            max-width: 900px;
            max-height: 90vh;
            overflow: hidden;
            box-shadow: var(--shadow-2xl);
            border: 1px solid var(--border-light);
            animation: modalSlideIn 0.4s ease;
        }
        
        .preview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 25px 30px;
            border-bottom: 1px solid var(--border-light);
            background: var(--bg-secondary);
        }
        
        .preview-title {
            font-size: 1.5rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .preview-title i {
            color: var(--primary);
        }
        
        .preview-close {
            background: none;
            border: none;
            color: var(--text-secondary);
            font-size: 1.5rem;
            cursor: pointer;
            padding: 8px;
            border-radius: var(--radius-md);
            transition: all var(--transition-base);
        }
        
        .preview-close:hover {
            color: var(--danger);
            background: var(--bg-tertiary);
        }
        
        .preview-body {
            padding: 30px;
            overflow-y: auto;
            max-height: calc(90vh - 100px);
            text-align: center;
        }
        
        .template-preview-large {
            background: white;
            border-radius: var(--radius-xl);
            padding: 40px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-light);
            margin: 0 auto;
            max-width: 600px;
        }
        
        .preview-footer {
            text-align: center;
            padding: 20px;
            border-top: 1px solid var(--border-light);
            background: var(--bg-secondary);
            color: var(--text-secondary);
            font-size: 0.9rem;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes modalSlideIn {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        @media (max-width: 992px) {
            .templates-container {
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
            
            .templates-card {
                padding: 25px;
            }
            
            .templates-grid {
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 20px;
            }
            
            .preview-content {
                max-width: 95%;
            }
        }
        
        @media (max-width: 768px) {
            .templates-card {
                padding: 20px;
            }
            
            .templates-grid {
                grid-template-columns: 1fr;
            }
            
            .template-actions {
                flex-direction: column;
            }
            
            .btn-download, .btn-preview {
                width: 100%;
                justify-content: center;
            }
            
            .template-preview {
                height: 180px;
            }
        }
        
        @media (max-width: 576px) {
            .page-title {
                font-size: 1.8rem;
            }
            
            .section-title {
                font-size: 1.4rem;
            }
            
            .template-name {
                font-size: 1.1rem;
            }
            
            .template-content {
                padding: 20px;
            }
            
            .preview-body {
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
            <a href="<%= contextPath %>/seeker/dashboard" class="back-home">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Dashboard</span>
            </a>
            
            <div class="header-controls">
                <div class="current-date">
                    <i class="fas fa-file-pdf"></i>
                    <span>CV Templates</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <div class="templates-container">
            <!-- Page Header -->
            <div class="page-header-section">
                <div class="page-header">
                    <div class="page-icon">
                        <i class="fas fa-file-pdf"></i>
                    </div>
                    <h1 class="page-title">CV Templates</h1>
                </div>
                <p class="page-subtitle">Choose from professional CV templates to create an impressive resume</p>
            </div>

            <!-- Templates Card -->
            <div class="templates-card">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-download"></i>
                        Available Templates
                    </h2>
                    <p class="section-description">
                        Download professional CV templates to help you create a standout resume. Each template is designed to impress recruiters.
                    </p>
                </div>

                <% if (list == null || list.isEmpty()) { %>
                    <div class="no-templates-message">
                        <div class="no-templates-icon">
                            <i class="fas fa-file-slash"></i>
                        </div>
                        <h3 class="no-templates-title">No Templates Available</h3>
                        <p class="no-templates-description">
                            There are currently no CV templates available for download.
                        </p>
                    </div>
                <% } else { %>
                    <div class="templates-grid">
                        <% for (CVTemplate t : list) { 
                            // Determine template type for styling
                            String typeClass = "template-card";
                            String badgeText = "PDF";
                            String badgeColor = "var(--primary)";
                            
                            if (t.getFilePath() != null) {
                                if (t.getFilePath().toLowerCase().endsWith(".doc") || 
                                    t.getFilePath().toLowerCase().endsWith(".docx")) {
                                    badgeText = "DOC";
                                    badgeColor = "#2B579A"; // Word blue
                                } else if (t.getFilePath().toLowerCase().endsWith(".pages")) {
                                    badgeText = "PAGES";
                                    badgeColor = "#FC3C3C"; // Apple red
                                }
                            }
                        %>
                            <div class="<%= typeClass %>">
                                <div class="template-preview">
                                    <div class="template-preview-content">
                                        <div class="preview-header"></div>
                                        <div class="preview-line"></div>
                                        <div class="preview-line"></div>
                                        <div class="preview-line"></div>
                                        <div class="preview-line"></div>
                                    </div>
                                    <div class="template-badge" style="background: <%= badgeColor %>;">
                                        <%= badgeText %>
                                    </div>
                                </div>
                                
                                <div class="template-content">
                                    <h3 class="template-name">
                                        <i class="fas fa-file-alt"></i>
                                        <%= t.getName() %>
                                    </h3>
                                    
                                    <p class="template-description">
                                        <%= t.getDescription() %>
                                    </p>
                                    
                                    <div class="template-actions">
                                        <button type="button" class="btn-preview" onclick="CVTemplates.showPreview('<%= t.getName() %>', '<%= t.getDescription() %>', '<%= badgeText %>', '<%= badgeColor %>')">
                                            <i class="fas fa-eye"></i>
                                            Preview
                                        </button>
                                        <a href="<%= contextPath + "/" + t.getFilePath() %>" 
                                           class="btn-download" 
                                           download>
                                            <i class="fas fa-download"></i>
                                            Download
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>

            <!-- Back to Dashboard -->
            <div class="back-section">
                <a href="<%= contextPath %>/seeker/dashboard" class="back-link">
                    <i class="fas fa-arrow-left"></i>
                    Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - CV Templates. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/seeker/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/cvbuilder"><i class="fas fa-file-alt"></i> CV Builder</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/downloadCV"><i class="fas fa-download"></i> Download CV</a>
                <span>•</span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- Preview Modal -->
    <div class="preview-modal" id="previewModal">
        <div class="preview-content">
            <div class="preview-header">
                <div class="preview-title">
                    <i class="fas fa-eye"></i>
                    <span id="previewTemplateName">Template Preview</span>
                </div>
                <button class="preview-close" onclick="CVTemplates.hidePreview()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="preview-body">
                <div class="template-preview-large">
                    <div class="template-preview-content" style="width: 100%; height: 300px;">
                        <div class="preview-header"></div>
                        <div class="preview-line"></div>
                        <div class="preview-line"></div>
                        <div class="preview-line"></div>
                        <div class="preview-line"></div>
                        <div class="preview-line"></div>
                        <div class="preview-line"></div>
                        <div class="preview-line"></div>
                        <div class="preview-line"></div>
                    </div>
                    
                    <div style="text-align: left; margin-top: 30px;">
                        <h3 style="color: var(--text-primary); margin-bottom: 10px;">Template Details</h3>
                        <p id="previewTemplateDescription" style="color: var(--text-secondary); margin-bottom: 15px;"></p>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <div id="previewTemplateBadge" style="padding: 6px 12px; border-radius: var(--radius-full); font-size: 0.9rem; font-weight: 600; color: white;"></div>
                            <span style="color: var(--text-secondary); font-size: 0.9rem;">Format</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="preview-footer">
                <p>This is a preview of the template. Click Download to get the complete template file.</p>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
    /**
     * CV Templates JavaScript
     * ES5 Compatible for Eclipse
     */
    
    var CVTemplates = {
        init: function() {
            this.setupThemeToggle();
            this.setupPreviewModal();
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
        
        setupPreviewModal: function() {
            // Close modal when clicking outside
            var modal = document.getElementById('previewModal');
            if (modal) {
                modal.addEventListener('click', function(e) {
                    if (e.target === this) {
                        CVTemplates.hidePreview();
                    }
                });
            }
            
            // Close modal with Escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    CVTemplates.hidePreview();
                }
            });
        },
        
        showPreview: function(name, description, format, color) {
            // Set preview content
            document.getElementById('previewTemplateName').textContent = name;
            document.getElementById('previewTemplateDescription').textContent = description;
            
            var badge = document.getElementById('previewTemplateBadge');
            badge.textContent = format;
            badge.style.background = color;
            
            // Show modal
            document.getElementById('previewModal').classList.add('active');
            document.body.style.overflow = 'hidden';
        },
        
        hidePreview: function() {
            document.getElementById('previewModal').classList.remove('active');
            document.body.style.overflow = '';
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
            CVTemplates.init();
        });
    } else {
        CVTemplates.init();
    }
    </script>
</body>
</html>