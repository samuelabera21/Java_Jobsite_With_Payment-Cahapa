<%@ page import="dao.JobDAO, dao.JobDAOImpl, dao.JobAlertDAO, dao.JobAlertDAOImpl" %>
<%@ page import="java.util.*, models.Job, models.JobAlert, models.User, dao.UserDAO, dao.UserDAOImpl" %>

<%
    String contextPath = request.getContextPath();
    
    // ========== SECURITY CHECK ==========
    // Verify this is a seeker
    Integer seekerId = (Integer) session.getAttribute("seekerId");
    if (seekerId == null) {
        // Not logged in as seeker - redirect to login
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    // ========== END SECURITY CHECK ==========
    
    int userId = seekerId; // Use seekerId
    
    JobDAO jobDAO = new JobDAOImpl();
    JobAlertDAO alertDAO = new JobAlertDAOImpl();

    // Load user alerts
    List<JobAlert> alerts = alertDAO.getByUser(userId);

    // Load job list (filtered or full)
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    if (jobs == null) jobs = jobDAO.getAll();

    // Get filter parameters from request
    String searchQuery = request.getParameter("q") != null ? request.getParameter("q") : "";
    String locationFilter = request.getParameter("location") != null ? request.getParameter("location") : "";
    String categoryFilter = request.getParameter("category") != null ? request.getParameter("category") : "";
    String typeFilter = request.getParameter("type") != null ? request.getParameter("type") : "";
    String salaryFilter = request.getParameter("salary") != null ? request.getParameter("salary") : "";

    // ============================
    // BUILD RECOMMENDED JOB LIST
    // ============================
    List<Job> recommended = new ArrayList<>();

    for (JobAlert alert : alerts) {
        for (Job job : jobs) {
            boolean matchKeyword = alert.getKeywords() != null && !alert.getKeywords().isEmpty()
                    && job.getTitle().toLowerCase().contains(alert.getKeywords().toLowerCase());

            boolean matchLocation = alert.getLocation() != null && !alert.getLocation().isEmpty()
                    && job.getLocation().toLowerCase().contains(alert.getLocation().toLowerCase());

            if (matchKeyword || matchLocation) {
                if (!recommended.contains(job)) {
                    recommended.add(job);
                }
            }
        }
    }
    
    // Calculate stats
    int totalJobs = jobs.size();
    int recommendedCount = recommended.size();
    int savedCount = 0; // Will be updated by JavaScript
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Jobs - Job Seeker</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/view_jobs.css">
    
    <!-- JavaScript -->
    <script src="<%= contextPath %>/assets/js/seeker_dashboard.js" defer></script>
    <script src="<%= contextPath %>/assets/js/view_jobs_seeker.js" defer></script>
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
                    <i class="fas fa-briefcase"></i>
                    <span>Available Jobs</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <!-- Jobs Container -->
        <div class="jobs-container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-icon">
                    <i class="fas fa-search"></i>
                </div>
                <h1 class="page-title">Available Jobs</h1>
                <p class="page-subtitle">Browse and apply for job opportunities that match your skills</p>
            </div>

            <!-- Stats Bar -->
            <div class="stats-bar fade-in">
                <div class="stat-item">
                    <div class="stat-icon">
                        <i class="fas fa-briefcase"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number"><%= totalJobs %></h3>
                        <p class="stat-label">Total Jobs</p>
                    </div>
                </div>
                
                <div class="stat-item">
                    <div class="stat-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number"><%= recommendedCount %></h3>
                        <p class="stat-label">Recommended</p>
                    </div>
                </div>
                
                <div class="stat-item">
                    <div class="stat-icon">
                        <i class="fas fa-bookmark"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" id="savedCount">0</h3>
                        <p class="stat-label">Saved</p>
                    </div>
                </div>
            </div>

            <!-- Recommended Jobs Section -->
            <% if (!recommended.isEmpty()) { %>
                <div class="recommended-section fade-in">
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="section-content">
                            <h3>Recommended Jobs Based on Your Alerts</h3>
                            <p>These jobs match your saved job alert criteria</p>
                        </div>
                        <div class="section-actions">
                            <button class="btn-toggle" id="toggleRecommended">
                                <i class="fas fa-eye"></i>
                                <span>Show/Hide</span>
                            </button>
                        </div>
                    </div>
                    
                    <div class="recommended-content" id="recommendedContent">
                        <div class="jobs-table-container">
                            <table class="recommended-jobs-table">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-briefcase"></i> Title</th>
                                        <th><i class="fas fa-map-marker-alt"></i> Location</th>
                                        <th><i class="fas fa-tag"></i> Category</th>
                                        <th><i class="fas fa-clock"></i> Type</th>
                                        <th><i class="fas fa-money-bill-wave"></i> Salary</th>
                                        <th><i class="fas fa-cogs"></i> Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Job job : recommended) { %>
                                        <tr class="recommended-job-row" data-job-id="<%= job.getId() %>">
                                            <td class="job-title-cell">
                                                <div class="job-title-wrapper">
                                                    <strong><%= job.getTitle() %></strong>
                                                    <span class="recommended-badge">
                                                        <i class="fas fa-star"></i> Recommended
                                                    </span>
                                                </div>
                                            </td>
                                            <td><%= job.getLocation() %></td>
                                            <td>
                                                <span class="category-badge">
                                                    <%= job.getCategory() %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="type-badge">
                                                    <%= job.getType() %>
                                                </span>
                                            </td>
                                            <td class="salary-cell">
                                                <% if (job.getSalary() != null && !job.getSalary().isEmpty()) { %>
                                                    <span class="salary-badge">
                                                        <i class="fas fa-money-bill-wave"></i>
                                                        <%= job.getSalary() %>
                                                    </span>
                                                <% } else { %>
                                                    <span class="not-specified">Not specified</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn-icon btn-save" data-job-id="<%= job.getId() %>" 
                                                            data-tooltip="Save Job">
                                                        <i class="far fa-bookmark"></i>
                                                    </button>
                                                    <a href="<%= request.getContextPath() %>/seeker/applyJob?job_id=<%= job.getId() %>" 
                                                       class="btn btn-primary btn-sm btn-apply">
                                                        <i class="fas fa-paper-plane"></i>
                                                        Apply
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            <% } %>

            <!-- Search and Filter Section -->
            <div class="search-filter-section fade-in">
                <div class="section-header">
                    <h3><i class="fas fa-filter"></i> Search & Filter Jobs</h3>
                    <button class="btn-toggle" id="toggleFilters">
                        <i class="fas fa-sliders-h"></i>
                        <span>Show Filters</span>
                    </button>
                </div>
                
                <!-- Quick Search -->
                <form action="<%= contextPath %>/seeker/searchJobs" method="get" class="search-form" id="searchForm">
                    <div class="search-container">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" 
                               name="q" 
                               placeholder="Search by title, description, location"
                               value="<%= searchQuery %>"
                               class="search-input"
                               id="searchInput"
                               required>
                        <button type="submit" class="btn btn-primary search-btn">
                            <i class="fas fa-search"></i>
                            Search
                        </button>
                    </div>
                </form>
                
                <!-- Advanced Filters -->
                <div class="advanced-filters" id="advancedFilters" style="display: none;">
                    <form action="<%= contextPath %>/seeker/filterJobs" method="get" class="filter-form" id="filterForm">
                        <div class="filter-grid">
                            <div class="filter-group">
                                <label class="filter-label">
                                    <i class="fas fa-map-marker-alt"></i>
                                    Location
                                </label>
                                <div class="filter-input-group">
                                    <input type="text" 
                                           name="location" 
                                           placeholder="City, State, or Remote"
                                           value="<%= locationFilter %>"
                                           class="form-control filter-input"
                                           id="locationInput">
                                    <button type="button" class="btn-icon btn-clear" data-target="locationInput">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="filter-group">
                                <label class="filter-label">
                                    <i class="fas fa-tag"></i>
                                    Category
                                </label>
                                <div class="filter-input-group">
                                    <select name="category" class="form-control filter-select" id="categorySelect">
                                        <option value="">All Categories</option>
                                        <option value="IT" <%= "IT".equals(categoryFilter) ? "selected" : "" %>>IT & Software</option>
                                        <option value="Marketing" <%= "Marketing".equals(categoryFilter) ? "selected" : "" %>>Marketing</option>
                                        <option value="Finance" <%= "Finance".equals(categoryFilter) ? "selected" : "" %>>Finance</option>
                                        <option value="Healthcare" <%= "Healthcare".equals(categoryFilter) ? "selected" : "" %>>Healthcare</option>
                                        <option value="Education" <%= "Education".equals(categoryFilter) ? "selected" : "" %>>Education</option>
                                        <option value="Sales" <%= "Sales".equals(categoryFilter) ? "selected" : "" %>>Sales</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="filter-group">
                                <label class="filter-label">
                                    <i class="fas fa-clock"></i>
                                    Job Type
                                </label>
                                <div class="filter-options">
                                    <label class="filter-option">
                                        <input type="checkbox" name="type" value="full-time" 
                                               <%= "full-time".equals(typeFilter) ? "checked" : "" %>>
                                        <span class="filter-option-label">
                                            <i class="fas fa-briefcase"></i>
                                            Full Time
                                        </span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox" name="type" value="part-time"
                                               <%= "part-time".equals(typeFilter) ? "checked" : "" %>>
                                        <span class="filter-option-label">
                                            <i class="fas fa-clock"></i>
                                            Part Time
                                        </span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox" name="type" value="contract"
                                               <%= "contract".equals(typeFilter) ? "checked" : "" %>>
                                        <span class="filter-option-label">
                                            <i class="fas fa-file-contract"></i>
                                            Contract
                                        </span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox" name="type" value="internship"
                                               <%= "internship".equals(typeFilter) ? "checked" : "" %>>
                                        <span class="filter-option-label">
                                            <i class="fas fa-graduation-cap"></i>
                                            Internship
                                        </span>
                                    </label>
                                </div>
                            </div>
                            
                            <div class="filter-group">
                                <label class="filter-label">
                                    <i class="fas fa-money-bill-wave"></i>
                                    Salary Range
                                </label>
                                <div class="salary-range">
                                    <div class="range-inputs">
                                        <input type="number" 
                                               name="min_salary" 
                                               placeholder="Min"
                                               class="form-control range-input"
                                               id="minSalary">
                                        <span class="range-separator">to</span>
                                        <input type="number" 
                                               name="max_salary" 
                                               placeholder="Max"
                                               class="form-control range-input"
                                               id="maxSalary">
                                    </div>
                                    <div class="salary-presets">
                                        <button type="button" class="btn-preset" data-min="30000" data-max="50000">
                                            $30k-50k
                                        </button>
                                        <button type="button" class="btn-preset" data-min="50000" data-max="80000">
                                            $50k-80k
                                        </button>
                                        <button type="button" class="btn-preset" data-min="80000" data-max="120000">
                                            $80k-120k
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="filter-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter"></i>
                                Apply Filters
                            </button>
                            <button type="button" class="btn btn-secondary" id="clearFilters">
                                <i class="fas fa-times"></i>
                                Clear All
                            </button>
                            <a href="<%= contextPath %>/seeker/viewJobs" class="btn btn-secondary">
                                <i class="fas fa-redo"></i>
                                Reset
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- All Jobs Section -->
            <div class="all-jobs-section fade-in">
                <div class="section-header">
                    <div class="section-content">
                        <h3>All Available Jobs</h3>
                        <div class="job-counts">
                            <span class="job-count"><%= jobs.size() %></span> jobs found
                            <span class="job-filters-applied" id="filtersApplied" style="display: none;">
                                <i class="fas fa-filter"></i> Filters active
                            </span>
                        </div>
                    </div>
                    
                    <div class="view-controls">
                        <div class="sort-controls">
                            <label class="sort-label">
                                <i class="fas fa-sort-amount-down"></i>
                                Sort by:
                            </label>
                            <select class="form-control sort-select" id="sortSelect">
                                <option value="recent">Most Recent</option>
                                <option value="title_asc">Title (A-Z)</option>
                                <option value="title_desc">Title (Z-A)</option>
                                <option value="salary_high">Salary (High to Low)</option>
                                <option value="salary_low">Salary (Low to High)</option>
                            </select>
                        </div>
                        
                        <div class="display-controls">
                            <button class="btn-icon btn-display active" data-view="table" data-tooltip="Table View">
                                <i class="fas fa-table"></i>
                            </button>
                            <button class="btn-icon btn-display" data-view="grid" data-tooltip="Grid View">
                                <i class="fas fa-th-large"></i>
                            </button>
                        </div>
                    </div>
                </div>
                
                <% if (!jobs.isEmpty()) { %>
                    <div class="jobs-display" id="jobsDisplay">
                        <!-- Table View -->
                        <div class="jobs-table-container table-view active">
                            <table class="jobs-table">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-briefcase"></i> Title</th>
                                        <th><i class="fas fa-map-marker-alt"></i> Location</th>
                                        <th><i class="fas fa-tag"></i> Category</th>
                                        <th><i class="fas fa-clock"></i> Type</th>
                                        <th><i class="fas fa-money-bill-wave"></i> Salary</th>
                                        <th><i class="fas fa-cogs"></i> Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="jobsTableBody">
                                    <% for (Job job : jobs) { 
                                        boolean isRecommended = recommended.contains(job);
                                    %>
                                        <tr class="job-row <%= isRecommended ? "recommended" : "" %>" data-job-id="<%= job.getId() %>">
                                            <td class="job-title-cell">
                                                <div class="job-title-wrapper">
                                                    <strong><%= job.getTitle() %></strong>
                                                    <% if (isRecommended) { %>
                                                        <span class="recommended-badge">
                                                            <i class="fas fa-star"></i> Recommended
                                                        </span>
                                                    <% } %>
                                                </div>
                                            </td>
                                            <td><%= job.getLocation() %></td>
                                            <td>
                                                <span class="category-badge">
                                                    <%= job.getCategory() %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="type-badge">
                                                    <%= job.getType() %>
                                                </span>
                                            </td>
                                            <td class="salary-cell">
                                                <% if (job.getSalary() != null && !job.getSalary().isEmpty()) { %>
                                                    <span class="salary-badge">
                                                        <i class="fas fa-money-bill-wave"></i>
                                                        <%= job.getSalary() %>
                                                    </span>
                                                <% } else { %>
                                                    <span class="not-specified">Not specified</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn-icon btn-save" data-job-id="<%= job.getId() %>" 
                                                            data-tooltip="Save Job">
                                                        <i class="far fa-bookmark"></i>
                                                    </button>
                                                    <a href="<%= request.getContextPath() %>/seeker/applyJob?job_id=<%= job.getId() %>" 
                                                       class="btn btn-primary btn-sm btn-apply">
                                                        <i class="fas fa-paper-plane"></i>
                                                        Apply
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Grid View -->
                        <div class="jobs-grid-container grid-view">
                            <div class="jobs-grid" id="jobsGrid">
                                <% for (Job job : jobs) { 
                                    boolean isRecommended = recommended.contains(job);
                                %>
                                    <div class="job-card <%= isRecommended ? "recommended" : "" %>" data-job-id="<%= job.getId() %>">
                                        <% if (isRecommended) { %>
                                            <div class="job-card-badge">
                                                <i class="fas fa-star"></i>
                                                Recommended
                                            </div>
                                        <% } %>
                                        
                                        <div class="job-card-header">
                                            <h4 class="job-card-title"><%= job.getTitle() %></h4>
                                            <button class="btn-icon btn-card-save" data-job-id="<%= job.getId() %>" 
                                                    data-tooltip="Save Job">
                                                <i class="far fa-bookmark"></i>
                                            </button>
                                        </div>
                                        
                                        <div class="job-card-body">
                                            <div class="job-card-details">
                                                <div class="job-card-detail">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                    <span><%= job.getLocation() %></span>
                                                </div>
                                                <div class="job-card-detail">
                                                    <i class="fas fa-tag"></i>
                                                    <span><%= job.getCategory() %></span>
                                                </div>
                                                <div class="job-card-detail">
                                                    <i class="fas fa-clock"></i>
                                                    <span><%= job.getType() %></span>
                                                </div>
                                                <% if (job.getSalary() != null && !job.getSalary().isEmpty()) { %>
                                                    <div class="job-card-detail salary">
                                                        <i class="fas fa-money-bill-wave"></i>
                                                        <span><%= job.getSalary() %></span>
                                                    </div>
                                                <% } %>
                                            </div>
                                        </div>
                                        
                                        <div class="job-card-footer">
                                            <a href="<%= request.getContextPath() %>/seeker/applyJob?job_id=<%= job.getId() %>" 
                                               class="btn btn-primary btn-block btn-apply">
                                                <i class="fas fa-paper-plane"></i>
                                                Apply Now
                                            </a>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Pagination -->
                    <div class="pagination">
                        <div class="pagination-info">
                            Showing <span id="showingStart">1</span>-<span id="showingEnd"><%= Math.min(10, jobs.size()) %></span> of <span id="totalJobs"><%= jobs.size() %></span> jobs
                        </div>
                        <div class="pagination-controls">
                            <button class="page-btn prev" disabled>
                                <i class="fas fa-chevron-left"></i>
                                Previous
                            </button>
                            <div class="page-numbers">
                                <button class="page-number active">1</button>
                                <% if (jobs.size() > 10) { %>
                                    <button class="page-number">2</button>
                                    <% if (jobs.size() > 20) { %>
                                        <span class="page-ellipsis">...</span>
                                        <button class="page-number"><%= (int) Math.ceil(jobs.size() / 10.0) %></button>
                                    <% } %>
                                <% } %>
                            </div>
                            <button class="page-btn next <%= jobs.size() <= 10 ? "disabled" : "" %>"
                                    <%= jobs.size() <= 10 ? "disabled" : "" %>>
                                Next
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <h4>No Jobs Found</h4>
                        <p>Try adjusting your search criteria or check back later for new opportunities.</p>
                        <a href="<%= contextPath %>/seeker/viewJobs" class="btn btn-primary">
                            <i class="fas fa-redo"></i>
                            View All Jobs
                        </a>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - Available Jobs. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/seeker/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/applications"><i class="fas fa-file-alt"></i> My Applications</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/jobAlerts"><i class="fas fa-bell"></i> Job Alerts</a>
                <span>•</span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <i class="fas fa-cog fa-spin"></i>
            <p>Loading Jobs...</p>
        </div>
    </div>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>

    <!-- Save Confirmation Modal -->
    <div class="modal" id="saveConfirmModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Save Job</h3>
                <button class="modal-close" id="modalClose">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <p id="modalMessage">Are you sure you want to save this job?</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" id="modalCancel">Cancel</button>
                <button class="btn btn-primary" id="modalConfirm">Save Job</button>
            </div>
        </div>
    </div>
</body>
</html>