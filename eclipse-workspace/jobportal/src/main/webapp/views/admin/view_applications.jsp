<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, models.Application" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.ZoneId" %>

<%
    List<Application> apps = (List<Application>) request.getAttribute("apps");
    String contextPath = request.getContextPath();
    
    // Get filter parameters
    String statusFilter = request.getParameter("status");
    String searchTerm = request.getParameter("search");
    String jobFilter = request.getParameter("jobId");
    
    // Get statistics
    int totalApps = apps != null ? apps.size() : 0;
    int pendingApps = apps != null ? (int) apps.stream().filter(a -> "pending".equals(a.getStatus())).count() : 0;
    int reviewedApps = apps != null ? (int) apps.stream().filter(a -> "reviewed".equals(a.getStatus())).count() : 0;
    int rejectedApps = apps != null ? (int) apps.stream().filter(a -> "rejected".equals(a.getStatus())).count() : 0;
    int acceptedApps = apps != null ? (int) apps.stream().filter(a -> "accepted".equals(a.getStatus())).count() : 0;
    
    // Get unique job IDs for filter
    List<Integer> jobIds = apps != null ? 
        apps.stream()
            .map(Application::getJobId)
            .distinct()
            .sorted()
            .collect(java.util.stream.Collectors.toList()) : 
        new java.util.ArrayList<>();
    
    // Format date formatter
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Applications - Admin Dashboard</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/view_seekers.css">
    
    <!-- JavaScript -->
    <script src="<%= contextPath %>/assets/js/view_applications.js" defer></script>
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

        <!-- Applications Container -->
        <div class="seekers-container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <h1 class="page-title">Job Applications</h1>
                <p class="page-subtitle">Manage and review all job applications in the system</p>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-container fade-in">
                <div class="stats-card">
                    <div class="stats-icon primary">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="totalApplications"><%= totalApps %></h3>
                        <p>Total Applications</p>
                    </div>
                    <div class="stats-trend">
                        <i class="fas fa-chart-line"></i>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon warning">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="pendingApplications"><%= pendingApps %></h3>
                        <p>Pending Review</p>
                    </div>
                    <div class="stats-trend">
                        <span class="trend-up"><i class="fas fa-arrow-up"></i> 18%</span>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon info">
                        <i class="fas fa-eye"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="reviewedApplications"><%= reviewedApps %></h3>
                        <p>Reviewed</p>
                    </div>
                    <div class="stats-trend">
                        <span class="trend-up"><i class="fas fa-arrow-up"></i> 8%</span>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon success">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="acceptedApplications"><%= acceptedApps %></h3>
                        <p>Accepted</p>
                    </div>
                    <div class="stats-trend">
                        <span class="trend-up"><i class="fas fa-arrow-up"></i> 5%</span>
                    </div>
                </div>
            </div>

            <!-- Applications Table Container -->
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
                                    <option value="pending" <%= "pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                                    <option value="reviewed" <%= "reviewed".equals(statusFilter) ? "selected" : "" %>>Reviewed</option>
                                    <option value="accepted" <%= "accepted".equals(statusFilter) ? "selected" : "" %>>Accepted</option>
                                    <option value="rejected" <%= "rejected".equals(statusFilter) ? "selected" : "" %>>Rejected</option>
                                </select>
                            </div>
                            
                            <div class="filter-group">
                                <select id="jobFilter" class="form-control filter-select">
                                    <option value="">All Jobs</option>
                                    <% if (jobIds != null) { 
                                        for (Integer jobId : jobIds) { 
                                    %>
                                        <option value="<%= jobId %>" 
                                            <%= String.valueOf(jobId).equals(jobFilter) ? "selected" : "" %>>
                                            Job #<%= jobId %>
                                        </option>
                                    <% } } %>
                                </select>
                            </div>
                            
                            <div class="filter-group search-group">
                                <input type="text" 
                                       id="searchInput" 
                                       class="form-control search-input" 
                                       placeholder="Search applications..."
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
                                        <i class="fas fa-briefcase"></i>
                                        Job
                                        <button class="sort-btn" data-sort="job">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-content">
                                        <i class="fas fa-user"></i>
                                        Applicant
                                        <button class="sort-btn" data-sort="applicant">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-content">
                                        <i class="fas fa-comment"></i>
                                        Message
                                        <button class="sort-btn" data-sort="message">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-content">
                                        <i class="fas fa-file"></i>
                                        CV
                                        <button class="sort-btn" data-sort="cv">
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
                                        Applied Date
                                        <button class="sort-btn" data-sort="applied">
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
                           <% if (apps != null && !apps.isEmpty()) { 
    for (int i = 0; i < apps.size(); i++) { 
        Application a = apps.get(i); 
        LocalDateTime appliedAt = null;
        long timestampValue = 0;
        
        if (a.getAppliedAt() != null) {
            String appliedStr = a.getAppliedAt().toString();
            try {
                // Try to parse the date string
                DateTimeFormatter[] formatters = {
                    DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"),
                    DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss"),
                    DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"),
                    DateTimeFormatter.ISO_LOCAL_DATE_TIME
                };
                
                for (DateTimeFormatter formatter : formatters) {
                    try {
                        appliedAt = LocalDateTime.parse(appliedStr, formatter);
                        break;
                    } catch (Exception e) {
                        // Try next format
                    }
                }
                
                if (appliedAt == null) {
                    // If parsing fails, use current time
                    appliedAt = LocalDateTime.now();
                }
                
                timestampValue = appliedAt.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
            } catch (Exception e) {
                appliedAt = LocalDateTime.now();
                timestampValue = System.currentTimeMillis();
            }
        } else {
            appliedAt = LocalDateTime.now();
            timestampValue = System.currentTimeMillis();
        }
        
        // Get status class and icon
        String status = a.getStatus();
        String statusClass = status;
        String statusIcon = "fa-clock";
        
        if ("pending".equals(status)) {
            statusIcon = "fa-clock";
        } else if ("reviewed".equals(status)) {
            statusIcon = "fa-eye";
        } else if ("accepted".equals(status)) {
            statusIcon = "fa-check-circle";
        } else if ("rejected".equals(status)) {
            statusIcon = "fa-times-circle";
        }
        
        // Truncate message if too long
        String message = a.getMessage();
        String shortMessage = message != null && message.length() > 50 ? 
            message.substring(0, 50) + "..." : message;
%>
                                <tr class="seeker-row fade-in" data-application-id="<%= a.getId() %>" 
                                    data-status="<%= status %>"
                                    data-job-id="<%= a.getJobId() %>"
                                    data-applicant-id="<%= a.getSeekerId() %>"
                                    data-applied="<%= timestampValue %>">
                                    <td class="seeker-id">
                                        <span class="id-badge">#<%= a.getId() %></span>
                                    </td>
                                    <td class="seeker-name">
                                        <div class="seeker-info">
                                            <div class="avatar">
                                                <i class="fas fa-briefcase"></i>
                                            </div>
                                            <div class="seeker-details">
                                                <strong>Job #<%= a.getJobId() %></strong>
                                                <span class="seeker-meta">
                                                    <i class="fas fa-hashtag"></i>
                                                    Job ID
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="seeker-email">
                                        <div class="email-content">
                                            <i class="fas fa-user"></i>
                                            <span class="email-link">
                                                Seeker #<%= a.getSeekerId() %>
                                            </span>
                                        </div>
                                    </td>
                                    <td class="seeker-email">
                                        <div class="email-content">
                                            <i class="fas fa-comment"></i>
                                            <span class="email-link" title="<%= message != null ? message : "No message" %>">
                                                <%= shortMessage != null ? shortMessage : "No message" %>
                                            </span>
                                        </div>
                                    </td>
                                    <td class="seeker-email">
                                        <div class="email-content">
                                            <i class="fas fa-file"></i>
                                            <% if (a.getCvPath() != null) { %>
                                                <a href="<%= contextPath + "/" + a.getCvPath() %>" 
                                                   class="email-link"
                                                   download
                                                   title="Download CV">
                                                    Download CV
                                                </a>
                                            <% } else { %>
                                                <span class="email-link" style="color: var(--text-muted);">
                                                    No CV
                                                </span>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td class="seeker-status">
                                        <span class="status-badge <%= statusClass %>">
                                            <i class="fas <%= statusIcon %>"></i>
                                            <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
                                        </span>
                                    </td>
                                    <td class="seeker-created">
                                        <div class="date-content">
                                            <div class="date-primary">
                                                <i class="fas fa-calendar-day"></i>
                                                <%= dateFormatter.format(appliedAt) %>
                                            </div>
                                            <div class="date-secondary">
                                                <i class="fas fa-clock"></i>
                                                <%= timeFormatter.format(appliedAt) %>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="seeker-actions">
                                        <a href="<%= contextPath %>/admin/applicationDetails?id=<%= a.getId() %>" 
                                           class="btn-action btn-view"
                                           data-tooltip="View Details">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        
                                        <a href="<%= contextPath %>/admin/reviewApplication?id=<%= a.getId() %>" 
                                           class="btn-action btn-edit"
                                           data-tooltip="Review Application">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        
                                        <% if ("pending".equals(status) || "reviewed".equals(status)) { %>
                                            <a href="<%= contextPath %>/admin/acceptApplication?id=<%= a.getId() %>&redirect=applications" 
                                               class="btn-action btn-activate"
                                               data-tooltip="Accept Application"
                                               data-confirm="accept">
                                                <i class="fas fa-check"></i>
                                            </a>
                                            
                                            <a href="<%= contextPath %>/admin/rejectApplication?id=<%= a.getId() %>&redirect=applications" 
                                               class="btn-action btn-suspend"
                                               data-tooltip="Reject Application"
                                               data-confirm="reject">
                                                <i class="fas fa-times"></i>
                                            </a>
                                        <% } %>
                                        
                                        <a href="<%= contextPath %>/admin/deleteApplication?id=<%= a.getId() %>&redirect=applications" 
                                           class="btn-action btn-delete"
                                           data-tooltip="Delete Application"
                                           data-confirm="delete">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr class="empty-row fade-in">
                                    <td colspan="8" class="empty-state">
                                        <i class="fas fa-file-alt"></i>
                                        <h4>No Applications Found</h4>
                                        <p>There are no job applications in the system yet.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination -->
                <% if (apps != null && apps.size() > 0) { %>
                <div class="pagination fade-in">
                    <div class="pagination-info">
                        Showing <strong>1</strong> to <strong><%= apps.size() %></strong> of <strong><%= apps.size() %></strong> applications
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
                    <h3><i class="fas fa-chart-pie"></i> Application Status Distribution</h3>
                    <button class="btn btn-secondary btn-sm" id="viewAnalytics">
                        <i class="fas fa-chart-bar"></i>
                        View Analytics
                    </button>
                </div>
                <div class="summary-content">
                    <div class="progress-container">
                        <div class="progress-label">
                            <span>Pending Review</span>
                            <span><%= pendingApps %> (<%= totalApps > 0 ? Math.round((pendingApps * 100.0) / totalApps) : 0 %>%)</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill warning" 
                                 style="width: <%= totalApps > 0 ? (pendingApps * 100) / totalApps : 0 %>%"></div>
                        </div>
                    </div>
                    
                    <div class="progress-container">
                        <div class="progress-label">
                            <span>Reviewed</span>
                            <span><%= reviewedApps %> (<%= totalApps > 0 ? Math.round((reviewedApps * 100.0) / totalApps) : 0 %>%)</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill info" 
                                 style="width: <%= totalApps > 0 ? (reviewedApps * 100) / totalApps : 0 %>%"></div>
                        </div>
                    </div>
                    
                    <div class="progress-container">
                        <div class="progress-label">
                            <span>Accepted</span>
                            <span><%= acceptedApps %> (<%= totalApps > 0 ? Math.round((acceptedApps * 100.0) / totalApps) : 0 %>%)</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill success" 
                                 style="width: <%= totalApps > 0 ? (acceptedApps * 100) / totalApps : 0 %>%"></div>
                        </div>
                    </div>
                    
                    <div class="progress-container">
                        <div class="progress-label">
                            <span>Rejected</span>
                            <span><%= rejectedApps %> (<%= totalApps > 0 ? Math.round((rejectedApps * 100.0) / totalApps) : 0 %>%)</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill danger" 
                                 style="width: <%= totalApps > 0 ? (rejectedApps * 100) / totalApps : 0 %>%"></div>
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
                <h3><i class="fas fa-chart-bar"></i> Applications Analytics</h3>
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
                        <li>Application trends over time</li>
                        <li>Status distribution analysis</li>
                        <li>Job-wise application statistics</li>
                        <li>Applicant success rates</li>
                        <li>Review timeline analysis</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</body>
</html>