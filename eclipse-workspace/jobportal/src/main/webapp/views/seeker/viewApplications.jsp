<%@ page import="java.util.List, java.util.Map, models.Application, models.Job" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String contextPath = request.getContextPath();
    List<Application> apps = (List<Application>) request.getAttribute("applications");
    Map<Integer, Job> jobs = (Map<Integer, Job>) request.getAttribute("jobs");
    String statusFilter = request.getParameter("status");
    String searchQuery = request.getParameter("search");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    <style>
        /* Additional styles for applications page */
        .applications-container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-title-section {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }
        
        .page-title i {
            color: var(--primary);
        }
        
        .page-subtitle {
            color: var(--text-secondary);
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .controls-section {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .stats-summary {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }
        
        .stat-badge {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: var(--bg-secondary);
            border: 1px solid var(--border-light);
            border-radius: var(--radius-lg);
            color: var(--text-secondary);
            font-size: 0.95rem;
        }
        
        .stat-badge .count {
            font-weight: 700;
            color: var(--text-primary);
        }
        
        .filter-controls {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .filter-select {
            padding: 10px 15px;
            border: 1px solid var(--border-light);
            border-radius: var(--radius-lg);
            background: var(--bg-secondary);
            color: var(--text-primary);
            font-size: 0.95rem;
            cursor: pointer;
            transition: all var(--transition-base);
        }
        
        .filter-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        .search-box {
            padding: 10px 15px;
            border: 1px solid var(--border-light);
            border-radius: var(--radius-lg);
            background: var(--bg-secondary);
            color: var(--text-primary);
            font-size: 0.95rem;
            width: 250px;
            transition: all var(--transition-base);
        }
        
        .search-box:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        .btn-refresh {
            padding: 10px 15px;
            background: var(--bg-tertiary);
            border: 1px solid var(--border-light);
            border-radius: var(--radius-lg);
            color: var(--text-primary);
            cursor: pointer;
            transition: all var(--transition-base);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-refresh:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }
        
        .applications-table-container {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            padding: 30px;
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-light);
            overflow-x: auto;
        }
        
        .applications-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            font-size: 0.95rem;
        }
        
        .applications-table thead {
            background: var(--bg-secondary);
        }
        
        .applications-table th {
            padding: 18px 15px;
            text-align: left;
            color: var(--text-primary);
            font-weight: 600;
            border-bottom: 2px solid var(--border-light);
            white-space: nowrap;
        }
        
        .applications-table td {
            padding: 18px 15px;
            color: var(--text-secondary);
            border-bottom: 1px solid var(--border-light);
            vertical-align: top;
        }
        
        .applications-table tbody tr {
            transition: all var(--transition-base);
        }
        
        .applications-table tbody tr:hover {
            background: var(--bg-secondary);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        
        .job-title-cell {
            color: var(--text-primary);
            font-weight: 500;
            min-width: 200px;
        }
        
        .job-title-cell a {
            color: inherit;
            text-decoration: none;
            transition: color var(--transition-base);
        }
        
        .job-title-cell a:hover {
            color: var(--primary);
        }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: var(--radius-full);
            font-size: 0.85rem;
            font-weight: 500;
            white-space: nowrap;
        }
        
        .status-pending {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
            border: 1px solid rgba(245, 158, 11, 0.2);
        }
        
        .status-reviewed {
            background: rgba(59, 130, 246, 0.1);
            color: var(--info);
            border: 1px solid rgba(59, 130, 246, 0.2);
        }
        
        .status-shortlisted {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
        
        .status-rejected {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }
        
        .status-accepted {
            background: rgba(16, 185, 129, 0.2);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.3);
            font-weight: 600;
        }
        
        .message-cell {
            max-width: 300px;
            word-wrap: break-word;
        }
        
        .message-preview {
            color: var(--text-secondary);
            line-height: 1.5;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-secondary);
        }
        
        .empty-state i {
            font-size: 3rem;
            color: var(--text-muted);
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            color: var(--text-primary);
            margin-bottom: 10px;
            font-size: 1.5rem;
        }
        
        .empty-state p {
            margin-bottom: 30px;
            font-size: 1rem;
        }
        
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 40px;
        }
        
        .btn-primary {
            padding: 12px 24px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
            border-radius: var(--radius-lg);
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition-base);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, var(--primary-dark), var(--secondary));
        }
        
        .btn-secondary {
            padding: 12px 24px;
            background: var(--bg-tertiary);
            color: var(--text-primary);
            border: 1px solid var(--border-light);
            border-radius: var(--radius-lg);
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition-base);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-secondary:hover {
            background: var(--border-light);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .date-cell {
            white-space: nowrap;
            font-size: 0.9rem;
        }
        
        @media (max-width: 1200px) {
            .controls-section {
                flex-direction: column;
                align-items: stretch;
            }
            
            .filter-controls {
                justify-content: center;
            }
        }
        
        @media (max-width: 768px) {
            .applications-container {
                padding: 0 15px;
                margin: 20px auto;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .applications-table-container {
                padding: 15px;
            }
            
            .applications-table {
                font-size: 0.85rem;
            }
            
            .applications-table th,
            .applications-table td {
                padding: 12px 8px;
            }
            
            .search-box {
                width: 100%;
            }
            
            .filter-controls {
                flex-direction: column;
                align-items: stretch;
            }
        }
        
        @media (max-width: 576px) {
            .stats-summary {
                justify-content: center;
            }
            
            .action-buttons {
                flex-direction: column;
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
                    <i class="fas fa-file-alt"></i>
                    <span>My Applications</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <div class="applications-container">
            <!-- Page Title -->
            <div class="page-title-section">
                <h1 class="page-title">
                    <i class="fas fa-file-alt"></i>
                    My Applications
                </h1>
                <p class="page-subtitle">Track and manage all your job applications in one place</p>
            </div>

            <!-- Controls Section -->
            <div class="controls-section">
                <div class="stats-summary">
                    <div class="stat-badge">
                        <i class="fas fa-layer-group"></i>
                        <span>Total: <span class="count" id="totalCount">
                            <%= apps != null ? apps.size() : 0 %>
                        </span></span>
                    </div>
                    <div class="stat-badge">
                        <i class="fas fa-clock"></i>
                        <span>Pending: <span class="count" id="pendingCount">0</span></span>
                    </div>
                    <div class="stat-badge">
                        <i class="fas fa-check-circle"></i>
                        <span>approved: <span class="count" id="acceptedCount">0</span></span>
                    </div>
                    
                    
                           <div class="stat-badge">
                        <i class="fas fa-check-circle"></i>
                        <span>rejected: <span class="count" id="rejectedcount">0</span></span>
                    </div>
                    
                    
                    
                </div>
                
                <div class="filter-controls">
                    <select class="filter-select" id="statusFilter">
                        <option value="">All Status</option>
                        <option value="pending" <%= "pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                        <option value="reviewed" <%= "reviewed".equals(statusFilter) ? "selected" : "" %>>Reviewed</option>
                        <option value="shortlisted" <%= "shortlisted".equals(statusFilter) ? "selected" : "" %>>Shortlisted</option>
                        <option value="approved" <%= "accepted".equals(statusFilter) ? "selected" : "" %>>approved</option>
                        <option value="rejected" <%= "rejected".equals(statusFilter) ? "selected" : "" %>>Rejected</option>
                    </select>
                    
                    <input type="text" 
                           class="search-box" 
                           id="searchInput" 
                           placeholder="Search jobs..." 
                           value="<%= searchQuery != null ? searchQuery : "" %>">
                    
                    <button class="btn-refresh" id="refreshBtn">
                        <i class="fas fa-sync-alt"></i>
                        Refresh
                    </button>
                </div>
            </div>

            <!-- Applications Table -->
            <div class="applications-table-container">
                <% if (apps != null && !apps.isEmpty()) { %>
                    <table class="applications-table" id="applicationsTable">
                        <thead>
                            <tr>
                                <th>Job Title</th>
                                <th>Location</th>
                                <th>Status</th>
                                <th>Applied At</th>
                                <th>Message</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int pendingCount = 0;
                                int acceptedCount = 0;
                                
                                for (Application app : apps) {
                                    Job job = jobs != null ? jobs.get(app.getJobId()) : null;
                                    String status = app.getStatus() != null ? app.getStatus().toLowerCase() : "";
                                    
                                    if ("pending".equals(status)) pendingCount++;
                                    if ("accepted".equals(status)) acceptedCount++;
                            %>
                            <tr class="application-row" 
                                data-status="<%= status %>"
                                data-job-title="<%= job != null ? job.getTitle().toLowerCase() : "" %>"
                                data-job-location="<%= job != null ? job.getLocation().toLowerCase() : "" %>">
                                <td class="job-title-cell">
                                    <%= job != null ? job.getTitle() : "Unknown Job" %>
                                </td>
                                <td>
                                    <%= job != null ? job.getLocation() : "-" %>
                                </td>
                                <td>
                                    <span class="status-badge <%= getStatusClass(status) %>">
                                        <i class="<%= getStatusIcon(status) %>"></i>
                                        <%= app.getStatus() != null ? app.getStatus() : "Unknown" %>
                                    </span>
                                </td>
                                <td class="date-cell">
                                    <%= app.getAppliedAt() != null ? app.getAppliedAt() : "-" %>
                                </td>
                                <td class="message-cell">
                                    <div class="message-preview">
                                        <%= app.getMessage() != null && !app.getMessage().isEmpty() 
                                            ? app.getMessage().replace("\n"," ") 
                                            : "No message" %>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    
                    <!-- Store counts in hidden elements for JS -->
                    <input type="hidden" id="hiddenPendingCount" value="<%= pendingCount %>">
                    <input type="hidden" id="hiddenAcceptedCount" value="<%= acceptedCount %>">
                    
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-file-alt"></i>
                        <h3>No Applications Found</h3>
                        <p>You haven't applied for any jobs yet. Start your job search today!</p>
                        <div class="action-buttons">
                            <a href="<%= contextPath %>/seeker/viewJobs" class="btn-primary">
                                <i class="fas fa-search"></i>
                                Browse Jobs
                            </a>
                            <a href="<%= contextPath %>/seeker/dashboard" class="btn-secondary">
                                <i class="fas fa-home"></i>
                                Back to Dashboard
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
            
            <% if (apps != null && !apps.isEmpty()) { %>
                <div class="action-buttons" style="margin-top: 30px;">
                    <a href="<%= contextPath %>/seeker/viewJobs" class="btn-secondary">
                        <i class="fas fa-briefcase"></i>
                        Back to Jobs
                    </a>
                </div>
            <% } %>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - My Applications. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/seeker/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/viewJobs"><i class="fas fa-briefcase"></i> View Jobs</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/profile"><i class="fas fa-user"></i> Profile</a>
                <span>•</span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- JavaScript -->
    <script>
    /**
     * My Applications Page JavaScript
     * ES5 Compatible for Eclipse
     */
    
    var ApplicationsPage = {
        init: function() {
            this.setupThemeToggle();
            this.setupFilters();
            this.setupSearch();
            this.setupRefresh();
            this.updateStats();
            this.setupRowClick();
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
        
        setupFilters: function() {
            var statusFilter = document.getElementById('statusFilter');
            if (!statusFilter) return;
            
            statusFilter.addEventListener('change', function() {
                ApplicationsPage.filterApplications();
            });
        },
        
        setupSearch: function() {
            var searchInput = document.getElementById('searchInput');
            if (!searchInput) return;
            
            var searchTimeout;
            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(function() {
                    ApplicationsPage.filterApplications();
                }, 300);
            });
        },
        
        setupRefresh: function() {
            var refreshBtn = document.getElementById('refreshBtn');
            if (!refreshBtn) return;
            
            refreshBtn.addEventListener('click', function() {
                location.reload();
            });
        },
        
        filterApplications: function() {
            var statusFilter = document.getElementById('statusFilter');
            var searchInput = document.getElementById('searchInput');
            var rows = document.querySelectorAll('.application-row');
            
            if (!rows.length) return;
            
            var statusValue = statusFilter ? statusFilter.value.toLowerCase() : '';
            var searchValue = searchInput ? searchInput.value.toLowerCase() : '';
            
            rows.forEach(function(row) {
                var rowStatus = row.getAttribute('data-status') || '';
                var jobTitle = row.getAttribute('data-job-title') || '';
                var jobLocation = row.getAttribute('data-job-location') || '';
                
                var statusMatch = !statusValue || rowStatus.includes(statusValue);
                var searchMatch = !searchValue || 
                                 jobTitle.includes(searchValue) || 
                                 jobLocation.includes(searchValue);
                
                if (statusMatch && searchMatch) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
            
            this.updateVisibleStats();
        },
        
        updateStats: function() {
            var pendingCountElem = document.getElementById('pendingCount');
            var acceptedCountElem = document.getElementById('acceptedCount');
            var rejectedCountElem = document.getElementById('rejectedcount');
            
            
            if (pendingCountElem) {
                var hiddenPending = document.getElementById('hiddenPendingCount');
                pendingCountElem.textContent = hiddenPending ? hiddenPending.value : '0';
            }
            
            if (acceptedCountElem) {
                var hiddenAccepted = document.getElementById('hiddenAcceptedCount');
                acceptedCountElem.textContent = hiddenAccepted ? hiddenAccepted.value : '0';
            }
            
            if (rejectedCountElem) {
                var hiddenrejected = document.getElementById('hiddenrejectedCount');
                rejectedCountElem.textContent = hiddenrejected ? hiddenrejected.value : '0';
            }
        },
        
        updateVisibleStats: function() {
            var rows = document.querySelectorAll('.application-row');
            var visibleRows = Array.from(rows).filter(function(row) {
                return row.style.display !== 'none';
            });
            
            document.getElementById('totalCount').textContent = visibleRows.length;
            
            var pendingCount = 0;
            var acceptedCount = 0;
            var rejectedcount = 0;
            
            visibleRows.forEach(function(row) {
                var status = row.getAttribute('data-status') || '';
                if (status.includes('pending')) pendingCount++;
                if (status.includes('approved')) acceptedCount++;
                if (status.includes('rejected')) rejectedcount++;
                
            });
            
            document.getElementById('pendingCount').textContent = pendingCount;
            document.getElementById('acceptedCount').textContent = acceptedCount;
            document.getElementById('rejectedcount').textContent = rejectedcount;
        },
        
        setupRowClick: function() {
            var rows = document.querySelectorAll('.application-row');
            rows.forEach(function(row) {
                row.addEventListener('click', function(e) {
                    // Don't trigger if clicking on links or buttons
                    if (e.target.tagName === 'A' || e.target.tagName === 'BUTTON') {
                        return;
                    }
                    
                    // Add visual feedback
                    this.style.backgroundColor = 'var(--bg-tertiary)';
                    setTimeout(function() {
                        row.style.backgroundColor = '';
                    }, 300);
                });
            });
        }
    };
    
    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            ApplicationsPage.init();
        });
    } else {
        ApplicationsPage.init();
    }
    </script>
</body>
</html>

<%!
    // Helper methods for status styling
    private String getStatusClass(String status) {
        if (status == null) return "status-pending";
        
        switch (status.toLowerCase()) {
            case "pending": return "status-pending";
            case "reviewed": return "status-reviewed";
            case "shortlisted": return "status-shortlisted";
            case "accepted": return "status-accepted";
            case "rejected": return "status-rejected";
            default: return "status-pending";
        }
    }
    
    private String getStatusIcon(String status) {
        if (status == null) return "fas fa-clock";
        
        switch (status.toLowerCase()) {
            case "pending": return "fas fa-clock";
            case "reviewed": return "fas fa-eye";
            case "shortlisted": return "fas fa-list";
            case "accepted": return "fas fa-check-circle";
            case "rejected": return "fas fa-times-circle";
            default: return "fas fa-clock";
        }
    }
%>