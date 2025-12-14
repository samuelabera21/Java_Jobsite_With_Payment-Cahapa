<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, models.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.sql.Timestamp" %>

<%
    List<User> employers = (List<User>) request.getAttribute("employers");
    String contextPath = request.getContextPath();
    
    // Get filter parameters
    String statusFilter = request.getParameter("status");
    String searchTerm = request.getParameter("search");
    
    // Get statistics
    int totalEmployers = employers != null ? employers.size() : 0;
    int activeEmployers = employers != null ? (int) employers.stream().filter(u -> "active".equals(u.getStatus())).count() : 0;
    int pendingEmployers = employers != null ? (int) employers.stream().filter(u -> "pending".equals(u.getStatus())).count() : 0;
    int suspendedEmployers = employers != null ? (int) employers.stream().filter(u -> "suspended".equals(u.getStatus())).count() : 0;
    
    // Format date formatter
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employers - Admin Dashboard</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/view_seekers.css">
    
    <!-- JavaScript -->
    <script src="<%= contextPath %>/assets/js/view_seekers.js" defer></script>
    <script>
        // Update page-specific variables
        document.addEventListener('DOMContentLoaded', function() {
            // Override page-specific configurations
            window.isEmployersPage = true;
        });
    </script>
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

        <!-- Employers Container -->
        <div class="seekers-container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-icon">
                    <i class="fas fa-briefcase"></i>
                </div>
                <h1 class="page-title">Employers</h1>
                <p class="page-subtitle">Manage and view all registered employers in the system</p>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-container fade-in">
                <div class="stats-card">
                    <div class="stats-icon primary">
                        <i class="fas fa-building"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="totalEmployers"><%= totalEmployers %></h3>
                        <p>Total Employers</p>
                    </div>
                    <div class="stats-trend">
                        <i class="fas fa-chart-line"></i>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon success">
                        <i class="fas fa-user-check"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="activeEmployers"><%= activeEmployers %></h3>
                        <p>Active Employers</p>
                    </div>
                    <div class="stats-trend">
                        <span class="trend-up"><i class="fas fa-arrow-up"></i> 8%</span>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon warning">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="pendingEmployers"><%= pendingEmployers %></h3>
                        <p>Pending Approval</p>
                    </div>
                    <div class="stats-trend">
                        <span class="trend-down"><i class="fas fa-arrow-down"></i> 3%</span>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon danger">
                        <i class="fas fa-user-slash"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="suspendedEmployers"><%= suspendedEmployers %></h3>
                        <p>Suspended</p>
                    </div>
                    <div class="stats-trend">
                        <i class="fas fa-ban"></i>
                    </div>
                </div>
            </div>

            <!-- Employers Table Container -->
            <div class="table-container fade-in">
                <div class="table-header">
                    <div class="table-info">
                        <i class="fas fa-filter"></i>
                        <span>Filters</span>
                    </div>
                    <div class="table-actions">
                        <div class="filters-container">
                            <div class="filter-group">
                                <select id="statusFilter" class="form-control filter-select">
                                    <option value="">All Status</option>
                                    <option value="active" <%= "active".equals(statusFilter) ? "selected" : "" %>>Active</option>
                                    <option value="pending" <%= "pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                                    <option value="suspended" <%= "suspended".equals(statusFilter) ? "selected" : "" %>>Suspended</option>
                                </select>
                            </div>
                            
                            <div class="filter-group search-group">
                                <input type="text" 
                                       id="searchInput" 
                                       class="form-control search-input" 
                                       placeholder="Search employers..."
                                       value="<%= searchTerm != null ? searchTerm : "" %>">
                                <button class="search-btn" id="searchBtn">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                            
                            <button class="btn btn-secondary btn-sm" id="clearFilters">
                                <i class="fas fa-times"></i>
                                Clear
                            </button>
                        </div>
                        
                        <div class="export-actions">
                            <button class="btn btn-secondary btn-sm" id="exportBtn">
                                <i class="fas fa-download"></i>
                                Export
                            </button>
                            <button class="btn btn-secondary btn-sm" id="refreshBtn">
                                <i class="fas fa-sync-alt"></i>
                                Refresh
                            </button>
                        </div>
                    </div>
                </div>
                
                <div class="table-wrapper">
                    <table class="seekers-table">
                        <thead>
                            <tr>
                                <th>
                                    <div class="table-header-content">
                                        <i class="fas fa-hashtag"></i>
                                        ID
                                        <button class="sort-btn" data-sort="id">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-content">
                                        <i class="fas fa-user"></i>
                                        Name
                                        <button class="sort-btn" data-sort="name">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-content">
                                        <i class="fas fa-envelope"></i>
                                        Email
                                        <button class="sort-btn" data-sort="email">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-content">
                                        <i class="fas fa-circle"></i>
                                        Status
                                        <button class="sort-btn" data-sort="status">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-content">
                                        <i class="fas fa-calendar"></i>
                                        Created Date
                                        <button class="sort-btn" data-sort="created">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </th>
                                <th>
                                    <i class="fas fa-cogs"></i>
                                    Actions
                                </th>
                            </tr>
                        </thead>
                        <tbody id="seekersTableBody">
                           <% if (employers != null && !employers.isEmpty()) { 
    for (int i = 0; i < employers.size(); i++) { 
        User u = employers.get(i); 
        LocalDateTime createdAt = null;
        long timestampValue = 0;
        
        if (u.getCreatedAt() != null) {
            String createdStr = u.getCreatedAt();
            // Parse string to LocalDateTime (adjust pattern as needed)
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            createdAt = LocalDateTime.parse(createdStr, formatter);
            timestampValue = createdAt.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
        } else {
            createdAt = LocalDateTime.now();
            timestampValue = System.currentTimeMillis();
        }
%>
                                <tr class="seeker-row fade-in" data-seeker-id="<%= u.getId() %>" 
                                    data-status="<%= u.getStatus() %>"
                                    data-created="<%= timestampValue %>">
                                    <td class="seeker-id">
                                        <span class="id-badge">#<%= u.getId() %></span>
                                    </td>
                                    <td class="seeker-name">
                                        <div class="seeker-info">
                                            <div class="avatar">
                                                <i class="fas fa-user-tie"></i>
                                            </div>
                                            <div class="seeker-details">
                                                <strong><%= u.getName() %></strong>
                                                <span class="seeker-meta">
                                                    <i class="fas fa-briefcase"></i>
                                                    Employer
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="seeker-email">
                                        <div class="email-content">
                                            <i class="fas fa-envelope"></i>
                                            <a href="mailto:<%= u.getEmail() %>" class="email-link">
                                                <%= u.getEmail() %>
                                            </a>
                                        </div>
                                    </td>
                                    <td class="seeker-status">
                                        <span class="status-badge <%= u.getStatus() %>">
                                            <i class="fas <%= 
                                                "active".equals(u.getStatus()) ? "fa-check-circle" : 
                                                "pending".equals(u.getStatus()) ? "fa-clock" : "fa-ban" 
                                            %>"></i>
                                            <%= u.getStatus().substring(0, 1).toUpperCase() + u.getStatus().substring(1) %>
                                        </span>
                                    </td>
                                    <td class="seeker-created">
                                        <div class="date-content">
                                            <div class="date-primary">
                                                <i class="fas fa-calendar-day"></i>
                                                <%= dateFormatter.format(createdAt) %>
                                            </div>
                                            <div class="date-secondary">
                                                <i class="fas fa-clock"></i>
                                                <%= timeFormatter.format(createdAt) %>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="seeker-actions">
                                        <a href="<%= contextPath %>/admin/manageUsers?edit=<%= u.getId() %>" 
                                           class="btn-action btn-edit"
                                           data-tooltip="Edit Employer">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        
                                        <a href="<%= contextPath %>/admin/employerDetails?id=<%= u.getId() %>" 
                                           class="btn-action btn-view"
                                           data-tooltip="View Details">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        
                                        <% if ("active".equals(u.getStatus())) { %>
                                            <a href="<%= contextPath %>/admin/deactivateUser?id=<%= u.getId() %>&redirect=employers" 
                                               class="btn-action btn-suspend"
                                               data-tooltip="Suspend Employer"
                                               data-confirm="suspend">
                                                <i class="fas fa-ban"></i>
                                            </a>
                                        <% } else if ("suspended".equals(u.getStatus())) { %>
                                            <a href="<%= contextPath %>/admin/activateUser?id=<%= u.getId() %>&redirect=employers" 
                                               class="btn-action btn-activate"
                                               data-tooltip="Activate Employer"
                                               data-confirm="activate">
                                                <i class="fas fa-play"></i>
                                            </a>
                                        <% } else if ("pending".equals(u.getStatus())) { %>
                                            <a href="<%= contextPath %>/admin/approveEmployer?id=<%= u.getId() %>" 
                                               class="btn-action btn-approve"
                                               data-tooltip="Approve Employer"
                                               data-confirm="approve">
                                                <i class="fas fa-check"></i>
                                            </a>
                                        <% } %>
                                        
                                        <a href="<%= contextPath %>/admin/deleteUser?id=<%= u.getId() %>&redirect=employers" 
                                           class="btn-action btn-delete"
                                           data-tooltip="Delete Employer"
                                           data-confirm="delete">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr class="empty-row fade-in">
                                    <td colspan="6" class="empty-state">
                                        <i class="fas fa-building"></i>
                                        <h4>No Employers Found</h4>
                                        <p>There are no employers registered in the system yet.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination -->
                <% if (employers != null && employers.size() > 0) { %>
                <div class="pagination fade-in">
                    <div class="pagination-info">
                        Showing <strong>1</strong> to <strong><%= employers.size() %></strong> of <strong><%= employers.size() %></strong> employers
                    </div>
                    <div class="pagination-controls">
                        <button class="btn btn-secondary btn-sm" disabled>
                            <i class="fas fa-chevron-left"></i>
                            Previous
                        </button>
                        <span class="page-numbers">Page 1 of 1</span>
                        <button class="btn btn-secondary btn-sm" disabled>
                            Next
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Quick Stats Summary -->
            <div class="summary-container fade-in">
                <div class="summary-header">
                    <h3><i class="fas fa-chart-pie"></i> Status Distribution</h3>
                    <button class="btn btn-secondary btn-sm" id="viewAnalytics">
                        <i class="fas fa-chart-bar"></i>
                        View Analytics
                    </button>
                </div>
                <div class="summary-content">
                    <div class="progress-container">
                        <div class="progress-label">
                            <span>Active Employers</span>
                            <span><%= activeEmployers %> (<%= totalEmployers > 0 ? Math.round((activeEmployers * 100.0) / totalEmployers) : 0 %>%)</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill success" 
                                 style="width: <%= totalEmployers > 0 ? (activeEmployers * 100) / totalEmployers : 0 %>%"></div>
                        </div>
                    </div>
                    
                    <div class="progress-container">
                        <div class="progress-label">
                            <span>Pending Approval</span>
                            <span><%= pendingEmployers %> (<%= totalEmployers > 0 ? Math.round((pendingEmployers * 100.0) / totalEmployers) : 0 %>%)</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill warning" 
                                 style="width: <%= totalEmployers > 0 ? (pendingEmployers * 100) / totalEmployers : 0 %>%"></div>
                        </div>
                    </div>
                    
                    <div class="progress-container">
                        <div class="progress-label">
                            <span>Suspended</span>
                            <span><%= suspendedEmployers %> (<%= totalEmployers > 0 ? Math.round((suspendedEmployers * 100.0) / totalEmployers) : 0 %>%)</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill danger" 
                                 style="width: <%= totalEmployers > 0 ? (suspendedEmployers * 100) / totalEmployers : 0 %>%"></div>
                        </div>
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
                <i class="fas fa-question-circle"></i>
            </div>
            <h3 class="confirmation-title" id="confirmTitle"></h3>
            <p class="confirmation-message" id="confirmMessage"></p>
            <div class="confirmation-actions">
                <button class="btn btn-secondary" id="confirmCancel">Cancel</button>
                <a class="btn btn-primary" id="confirmOk">Confirm</a>
            </div>
        </div>
    </div>

    <!-- Analytics Modal -->
    <div class="analytics-modal" id="analyticsModal">
        <div class="analytics-content">
            <div class="analytics-header">
                <h3><i class="fas fa-chart-bar"></i> Employers Analytics</h3>
                <button class="analytics-close" id="analyticsClose">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="analytics-body">
                <div class="analytics-placeholder">
                    <i class="fas fa-chart-line"></i>
                    <h4>Detailed Analytics</h4>
                    <p>Advanced analytics and charts would be displayed here.</p>
                    <p>Features could include:</p>
                    <ul>
                        <li>Employer registration trends</li>
                        <li>Company size distribution</li>
                        <li>Job posting statistics</li>
                        <li>Industry breakdown</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</body>
</html>