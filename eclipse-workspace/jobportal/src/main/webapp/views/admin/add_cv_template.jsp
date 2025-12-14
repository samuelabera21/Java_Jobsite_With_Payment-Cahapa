<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String contextPath = request.getContextPath();
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add CV Template - Admin Dashboard</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/add_cv_template.css">
    
    <!-- JavaScript -->
    <script src="<%= contextPath %>/assets/js/add_cv_template.js" defer></script>
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

        <!-- Form Container -->
        <div class="form-container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-icon">
                    <i class="fas fa-file-upload"></i>
                </div>
                <h1 class="page-title">Add CV Template</h1>
                <p class="page-subtitle">Upload a new professional CV template for job seekers</p>
            </div>

            <!-- Error Alert -->
            <% if (error != null) { %>
                <div class="alert danger fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Upload Failed!</h4>
                        <p><%= error %></p>
                    </div>
                </div>
            <% } %>

            <!-- Upload Form -->
            <form action="<%= contextPath %>/admin/addCVTemplate" 
                  method="post" 
                  enctype="multipart/form-data"
                  class="upload-form"
                  id="uploadForm">
                
                <div class="form-section">
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        <h3>Template Information</h3>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="templateName">
                            <i class="fas fa-file-signature"></i>
                            Template Name
                            <span class="required">*</span>
                        </label>
                        <input type="text" 
                               id="templateName" 
                               name="name" 
                               class="form-control"
                               placeholder="e.g., Modern Professional CV"
                               required
                               maxlength="100">
                        <div class="form-help">
                            Choose a descriptive name for the template (max 100 characters)
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="templateDescription">
                            <i class="fas fa-align-left"></i>
                            Description
                        </label>
                        <textarea id="templateDescription" 
                                  name="description" 
                                  class="form-control"
                                  rows="4"
                                  placeholder="Describe the template features, target audience, and key highlights..."
                                  maxlength="500"></textarea>
                        <div class="form-help">
                            Optional description for the template (max 500 characters)
                            <span id="charCount">0/500</span>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-file-upload"></i>
                        </div>
                        <h3>File Upload</h3>
                    </div>
                    
                    <div class="file-upload-area" id="fileUploadArea">
                        <div class="upload-icon">
                            <i class="fas fa-cloud-upload-alt"></i>
                        </div>
                        <h4>Drag & Drop or Click to Upload</h4>
                        <p class="upload-subtitle">
                            Supported formats: PDF, DOC, DOCX, HTML
                            <br>
                            Maximum file size: 10MB
                        </p>
                        
                        <input type="file" 
                               id="templateFile" 
                               name="file" 
                               class="file-input"
                               accept=".pdf,.doc,.docx,.html,.txt,.rtf"
                               required>
                        
                        <label for="templateFile" class="btn btn-secondary btn-choose">
                            <i class="fas fa-folder-open"></i>
                            Choose File
                        </label>
                        
                        <div class="file-preview" id="filePreview">
                            <!-- File preview will be displayed here -->
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="form-help">
                            <i class="fas fa-info-circle"></i>
                            Accepted file types: PDF (.pdf), Word (.doc, .docx), HTML (.html), Text (.txt), Rich Text (.rtf)
                        </div>
                    </div>
                </div>

                <!-- Supported Features -->
                <div class="features-section">
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-star"></i>
                        </div>
                        <h3>Template Features</h3>
                    </div>
                    
                    <div class="features-grid">
                        <div class="feature-card">
                            <div class="feature-icon success">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="feature-content">
                                <h5>Professional Design</h5>
                                <p>Clean, modern layouts that impress employers</p>
                            </div>
                        </div>
                        
                        <div class="feature-card">
                            <div class="feature-icon primary">
                                <i class="fas fa-mobile-alt"></i>
                            </div>
                            <div class="feature-content">
                                <h5>Mobile Responsive</h5>
                                <p>Optimized for viewing on all devices</p>
                            </div>
                        </div>
                        
                        <div class="feature-card">
                            <div class="feature-icon warning">
                                <i class="fas fa-edit"></i>
                            </div>
                            <div class="feature-content">
                                <h5>Easy to Customize</h5>
                                <p>Simple text replacement and formatting</p>
                            </div>
                        </div>
                        
                        <div class="feature-card">
                            <div class="feature-icon info">
                                <i class="fas fa-print"></i>
                            </div>
                            <div class="feature-content">
                                <h5>Print Ready</h5>
                                <p>High-quality printing with proper margins</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <a href="<%= contextPath %>/admin/cvTemplates" class="btn btn-secondary">
                        <i class="fas fa-times"></i>
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        <i class="fas fa-upload"></i>
                        Upload Template
                    </button>
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
            <p>Uploading Template...</p>
        </div>
    </div>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>

    <!-- Preview Modal -->
    <div class="preview-modal" id="previewModal">
        <div class="preview-content">
            <div class="preview-header">
                <h3><i class="fas fa-eye"></i> File Preview</h3>
                <button class="preview-close" id="previewClose">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="preview-body" id="previewBody">
                <!-- Preview content will be displayed here -->
            </div>
        </div>
    </div>
</body>
</html>