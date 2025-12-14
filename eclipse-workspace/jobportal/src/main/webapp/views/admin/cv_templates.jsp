<%@ page import="java.util.List" %>
<%@ page import="models.CVTemplate" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    List<CVTemplate> list = (List<CVTemplate>) request.getAttribute("templates");
    String contextPath = request.getContextPath();
    String successMsg = request.getParameter("success");
    String deleteMsg = request.getParameter("deleted");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage CV Templates - Admin Dashboard</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/cv_templates.css">
    
    <!-- JavaScript -->
    <script src="<%= contextPath %>/assets/js/cv_templates.js" defer></script>
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

        <!-- Templates Container -->
        <div class="templates-container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <h1 class="page-title">CV Templates</h1>
                <p class="page-subtitle">Manage professional CV templates for job seekers</p>
            </div>

            <!-- Success Alerts -->
            <% if ("1".equals(successMsg)) { %>
                <div class="alert success fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Template Added Successfully!</h4>
                        <p>The new CV template has been uploaded successfully.</p>
                    </div>
                </div>
            <% } %>
            
            <% if ("1".equals(deleteMsg)) { %>
                <div class="alert success fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Template Deleted!</h4>
                        <p>The CV template has been deleted successfully.</p>
                    </div>
                </div>
            <% } %>

            <!-- Templates Table Container -->
            <div class="table-container fade-in">
                <div class="table-header">
                    <div class="table-info">
                        <i class="fas fa-files"></i>
                        <span>Total Templates: <strong id="totalTemplates"><%= list != null ? list.size() : 0 %></strong></span>
                    </div>
                    <div class="table-actions">
                        <a href="<%= contextPath %>/admin/addCVTemplate" class="btn btn-primary">
                            <i class="fas fa-plus-circle"></i>
                            Add New Template
                        </a>
                    </div>
                </div>
                
                <div class="table-wrapper">
                    <table class="templates-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> ID</th>
                                <th><i class="fas fa-file-signature"></i> Name</th>
                                <th><i class="fas fa-align-left"></i> Description</th>
                                <th><i class="fas fa-download"></i> Download</th>
                                <th><i class="fas fa-cogs"></i> Actions</th>
                            </tr>
                        </thead>
                        <tbody id="templatesTableBody">
                            <% if (list != null && !list.isEmpty()) { 
                                for (int i = 0; i < list.size(); i++) { 
                                    CVTemplate t = list.get(i); %>
                                <tr class="template-row fade-in" data-template-id="<%= t.getId() %>">
                                    <td class="template-id"><%= t.getId() %></td>
                                    <td class="template-name">
                                        <div class="template-name-content">
                                            <i class="fas fa-file-word"></i>
                                            <div>
                                                <strong><%= t.getName() %></strong>
                                                <span class="file-info">
                                                    <i class="fas <%= 
                                                        t.getFilePath().endsWith(".docx") ? "fa-file-word" :
                                                        t.getFilePath().endsWith(".pdf") ? "fa-file-pdf" :
                                                        t.getFilePath().endsWith(".doc") ? "fa-file-word" : "fa-file"
                                                    %>"></i>
                                                    <%= t.getFilePath().substring(t.getFilePath().lastIndexOf('.') + 1).toUpperCase() %>
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="template-description">
                                        <%= t.getDescription() != null ? t.getDescription() : "No description" %>
                                    </td>
                                    <td class="template-download">
                                        <a href="<%= contextPath + "/" + t.getFilePath() %>" 
                                           class="btn-action btn-download"
                                           data-tooltip="Download Template"
                                           download>
                                            <i class="fas fa-download"></i>
                                            Download
                                        </a>
                                    </td>
                                    <td class="template-actions">
                                        <a class="btn-action btn-preview"
                                           href="<%= contextPath + "/" + t.getFilePath() %>"
                                           target="_blank"
                                           data-tooltip="Preview Template">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a class="btn-action btn-delete"
                                           href="<%= contextPath %>/admin/deleteCVTemplate?id=<%= t.getId() %>"
                                           data-tooltip="Delete Template"
                                           data-confirm="delete">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr class="empty-row fade-in">
                                    <td colspan="5" class="empty-state">
                                        <i class="fas fa-file-excel"></i>
                                        <h4>No Templates Found</h4>
                                        <p>No CV templates available. Start by adding a new template.</p>
                                        <a href="<%= contextPath %>/admin/addCVTemplate" class="btn btn-primary">
                                            <i class="fas fa-plus-circle"></i>
                                            Add First Template
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="stats-container fade-in">
                <div class="stats-card">
                    <div class="stats-icon primary">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="stats-content">
                        <h3><%= list != null ? list.size() : 0 %></h3>
                        <p>Total Templates</p>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon success">
                        <i class="fas fa-file-word"></i>
                    </div>
                    <div class="stats-content">
                        <h3>
                            <%= list != null ? list.stream().filter(t -> t.getFilePath().endsWith(".docx") || t.getFilePath().endsWith(".doc")).count() : 0 %>
                        </h3>
                        <p>Word Documents</p>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon warning">
                        <i class="fas fa-file-pdf"></i>
                    </div>
                    <div class="stats-content">
                        <h3>
                            <%= list != null ? list.stream().filter(t -> t.getFilePath().endsWith(".pdf")).count() : 0 %>
                        </h3>
                        <p>PDF Documents</p>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon info">
                        <i class="fas fa-download"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="downloadCount">0</h3>
                        <p>Total Downloads</p>
                    </div>
                </div>
            </div>
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
            <p>Loading...</p>
        </div>
    </div>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>

    <!-- Confirmation Modal -->
    <div class="confirmation-modal" id="confirmationModal">
        <div class="confirmation-content">
            <div class="confirmation-icon">
                <i class="fas fa-trash"></i>
            </div>
            <h3 class="confirmation-title">Delete Template</h3>
            <p class="confirmation-message">Are you sure you want to delete this CV template? This action cannot be undone.</p>
            <div class="confirmation-actions">
                <button class="btn btn-secondary" id="confirmCancel">Cancel</button>
                <a class="btn btn-danger" id="confirmDelete">Delete</a>
            </div>
        </div>
    </div>
</body>
</html>