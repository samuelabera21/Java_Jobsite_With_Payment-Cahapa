<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, models.Job" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.sql.Timestamp" %>

<%
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    String contextPath = request.getContextPath();
    
    // Get filter parameters
    String statusFilter = request.getParameter("status");
    String searchTerm = request.getParameter("search");
    String categoryFilter = request.getParameter("category");
    
    // Get statistics
    int totalJobs = jobs != null ? jobs.size() : 0;
    int activeJobs = jobs != null ? (int) jobs.stream().filter(j -> j.isActive()).count() : 0;
    int expiredJobs = jobs != null ? (int) jobs.stream().filter(j -> !j.isActive()).count() : 0;
    
    // Get unique categories for filter
    List<String> categories = jobs != null ? 
        jobs.stream()
            .map(Job::getCategory)
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
    <title>Jobs - Admin Dashboard</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/view_seekers.css">
    
    <!-- JavaScript -->
    <script src="<%= contextPath %>/assets/js/view_jobs.js" defer></script>
    <script>
        // Update page-specific variables
        document.addEventListener('DOMContentLoaded', function() {
            // Override page-specific configurations
            window.isJobsPage = true;
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

        <!-- Jobs Container -->
        <div class="seekers-container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-icon">
                    <i class="fas fa-briefcase"></i>
                </div>
                <h1 class="page-title">Jobs</h1>
                <p class="page-subtitle">Manage and view all job postings in the system</p>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-container fade-in">
                <div class="stats-card">
                    <div class="stats-icon primary">
                        <i class="fas fa-briefcase"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="totalJobs"><%= totalJobs %></h3>
                        <p>Total Jobs</p>
                    </div>
                    <div class="stats-trend">
                        <i class="fas fa-chart-line"></i>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon success">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="activeJobs"><%= activeJobs %></h3>
                        <p>Active Jobs</p>
                    </div>
                    <div class="stats-trend">
                        <span class="trend-up"><i class="fas fa-arrow-up"></i> 15%</span>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon warning">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="expiringJobs">0</h3>
                        <p>Expiring Soon</p>
                    </div>
                    <div class="stats-trend">
                        <span class="trend-down"><i class="fas fa-arrow-down"></i> 5%</span>
                    </div>
                </div>
                
                <div class="stats-card">
                    <div class="stats-icon danger">
                        <i class="fas fa-ban"></i>
                    </div>
                    <div class="stats-content">
                        <h3 id="expiredJobs"><%= expiredJobs %></h3>
                        <p>Expired Jobs</p>
                    </div>
                    <div class="stats-trend">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                </div>
            </div>

            <!-- Jobs Table Container -->
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
                                    <option value="expired" <%= "expired".equals(statusFilter) ? "selected" : "" %>>Expired</option>
                                </select>
                            </div>
                            
                            <div class="filter-group">
                                <select id="categoryFilter" class="form-control filter-select">
                                    <option value="">All Categories</option>
                                    <% if (categories != null) { 
                                        for (String category : categories) { 
                                    %>
                                        <option value="<%= category %>" 
                                            <%= category.equals(categoryFilter) ? "selected" : "" %>>
                                            <%= category %>
                                        </option>
                                    <% } } %>
                                </select>
                            </div>
                            
                            <div class="filter-group search-group">
                                <input type="text" 
                                       id="searchInput" 
                                       class="form-control search-input" 
                                       placeholder="Search jobs..."
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
                                        <i class="fas fa-building"></i>
                                        Employer
                                        <button class="sort-btn" data-sort="employer">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-content">
                                        <i class="fas fa-briefcase"></i>
                                        Title
                                        <button class="sort-btn" data-sort="title">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-content">
                                        <i class="fas fa-map-marker-alt"></i>
                                        Location
                                        <button class="sort-btn" data-sort="location">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-content">
                                        <i class="fas fa-tag"></i>
                                        Category
                                        <button class="sort-btn" data-sort="category">
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
                                        Posted Date
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
                           <% if (jobs != null && !jobs.isEmpty()) { 
    for (int i = 0; i < jobs.size(); i++) { 
        Job j = jobs.get(i); 
        LocalDateTime createdAt = null;
        long timestampValue = 0;
        
        if (j.getCreatedAt() != null) {
            String createdStr = j.getCreatedAt().toString();
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
                        createdAt = LocalDateTime.parse(createdStr, formatter);
                        break;
                    } catch (Exception e) {
                        // Try next format
                    }
                }
                
                if (createdAt == null) {
                    // If parsing fails, use current time
                    createdAt = LocalDateTime.now();
                }
                
                timestampValue = createdAt.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
            } catch (Exception e) {
                createdAt = LocalDateTime.now();
                timestampValue = System.currentTimeMillis();
            }
        } else {
            createdAt = LocalDateTime.now();
            timestampValue = System.currentTimeMillis();
        }
        
        // Get status text and class
        boolean isActive = j.isActive();
        String statusText = isActive ? "Active" : "Expired";
        String statusClass = isActive ? "active" : "suspended";
%>
                                <tr class="seeker-row fade-in" data-job-id="<%= j.getId() %>" 
                                    data-status="<%= statusClass %>"
                                    data-category="<%= j.getCategory() %>"
                                    data-created="<%= timestampValue %>">
                                    <td class="seeker-id">
                                        <span class="id-badge">#<%= j.getId() %></span>
                                    </td>
                                    <td class="seeker-name">
                                        <div class="seeker-info">
                                            <div class="avatar">
                                                <i class="fas fa-building"></i>
                                            </div>
                                            <div class="seeker-details">
                                                <strong>Employer #<%= j.getEmployerId() %></strong>
                                                <span class="seeker-meta">
                                                    <i class="fas fa-user-tie"></i>
                                                    Employer ID
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="seeker-email">
                                        <div class="email-content">
                                            <i class="fas fa-briefcase"></i>
                                            <span class="email-link">
                                                <%= j.getTitle() %>
                                            </span>
                                        </div>
                                    </td>
                                    <td class="seeker-email">
                                        <div class="email-content">
                                            <i class="fas fa-map-marker-alt"></i>
                                            <span class="email-link">
                                                <%= j.getLocation() != null ? j.getLocation() : "Not specified" %>
                                            </span>
                                        </div>
                                    </td>
                                    <td class="seeker-email">
                                        <div class="email-content">
                                            <i class="fas fa-tag"></i>
                                            <span class="email-link">
                                                <%= j.getCategory() != null ? j.getCategory() : "Uncategorized" %>
                                            </span>
                                        </div>
                                    </td>
                                    <td class="seeker-status">
                                        <span class="status-badge <%= statusClass %>">
                                            <i class="fas <%= 
                                                isActive ? "fa-check-circle" : "fa-ban" 
                                            %>"></i>
                                            <%= statusText %>
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
                                        <a href="<%= contextPath %>/admin/manageJob?edit=<%= j.getId() %>" 
                                           class="btn-action btn-edit"
                                           data-tooltip="Edit Job">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        
                                        <a href="<%= contextPath %>/admin/jobDetails?id=<%= j.getId() %>" 
                                           class="btn-action btn-view"
                                           data-tooltip="View Details">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        
                                        <% if (isActive) { %>
                                            <a href="<%= contextPath %>/admin/deactivateJob?id=<%= j.getId() %>&redirect=jobs" 
                                               class="btn-action btn-suspend"
                                               data-tooltip="Deactivate Job"
                                               data-confirm="deactivate">
                                                <i class="fas fa-ban"></i>
                                            </a>
                                        <% } else { %>
                                            <a href="<%= contextPath %>/admin/activateJob?id=<%= j.getId() %>&redirect=jobs" 
                                               class="btn-action btn-activate"
                                               data-tooltip="Activate Job"
                                               data-confirm="activate">
                                                <i class="fas fa-play"></i>
                                            </a>
                                        <% } %>
                                        
                                        <a href="<%= contextPath %>/admin/deleteJob?id=<%= j.getId() %>&redirect=jobs" 
                                           class="btn-action btn-delete"
                                           data-tooltip="Delete Job"
                                           data-confirm="delete">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr class="empty-row fade-in">
                                    <td colspan="8" class="empty-state">
                                        <i class="fas fa-briefcase"></i>
                                        <h4>No Jobs Found</h4>
                                        <p>There are no job postings in the system yet.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination -->
                <% if (jobs != null && jobs.size() > 0) { %>
                <div class="pagination fade-in">
                    <div class="pagination-info">
                        Showing <strong>1</strong> to <strong><%= jobs.size() %></strong> of <strong><%= jobs.size() %></strong> jobs
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
                    <h3><i class="fas fa-chart-pie"></i> Job Status Distribution</h3>
                    <button class="btn btn-secondary btn-sm" id="viewAnalytics">
                        <i class="fas fa-chart-bar"></i>
                        View Analytics
                    </button>
                </div>
                <div class="summary-content">
                    <div class="progress-container">
                        <div class="progress-label">
                            <span>Active Jobs</span>
                            <span><%= activeJobs %> (<%= totalJobs > 0 ? Math.round((activeJobs * 100.0) / totalJobs) : 0 %>%)</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill success" 
                                 style="width: <%= totalJobs > 0 ? (activeJobs * 100) / totalJobs : 0 %>%"></div>
                        </div>
                    </div>
                    
                    <div class="progress-container">
                        <div class="progress-label">
                            <span>Expired Jobs</span>
                            <span><%= expiredJobs %> (<%= totalJobs > 0 ? Math.round((expiredJobs * 100.0) / totalJobs) : 0 %>%)</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill danger" 
                                 style="width: <%= totalJobs > 0 ? (expiredJobs * 100) / totalJobs : 0 %>%"></div>
                        </div>
                    </div>
                    
                    <div class="progress-container">
                        <div class="progress-label">
                            <span>New This Week</span>
                            <span>0 (0%)</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill warning" 
                                 style="width: 0%"></div>
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
                <h3><i class="fas fa-chart-bar"></i> Jobs Analytics</h3>
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
                        <li>Job posting trends over time</li>
                        <li>Category distribution analysis</li>
                        <li>Application statistics</li>
                        <li>Geographic job distribution</li>
                        <li>Popular job titles analysis</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</body>
</html>