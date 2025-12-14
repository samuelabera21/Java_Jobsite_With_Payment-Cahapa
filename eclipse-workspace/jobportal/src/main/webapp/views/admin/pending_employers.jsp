<%@ page import="models.User" %>
<%@ page import="java.util.List" %>
<%
    String contextPath = request.getContextPath();
    List<User> list = (List<User>) request.getAttribute("pendingEmployers");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Employers - JobPortal Admin</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/pending_employers.css">
    
    <!-- JavaScript -->
    <script src="<%= contextPath %>/assets/js/pending_employers.js" defer></script>
    
    <!-- Chart.js for statistics -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <!-- Floating Background Elements -->
    <div class="floating-element"></div>
    <div class="floating-element"></div>
    <div class="floating-element"></div>

    <!-- Hero Background -->
    <div class="hero-image"></div>
    <div class="hero-overlay"></div>

    <!-- Main Container -->
    <div class="admin-container">
        <!-- Header with Navigation -->
        <header class="admin-header">
            <a href="<%= contextPath %>/admin/dashboard" class="back-dashboard">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
            
            <div class="header-controls">
                <!-- Theme Toggle -->
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
                
                <!-- User Menu -->
                <div class="user-menu">
                    <div class="user-avatar">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <span>Admin</span>
                    <i class="fas fa-chevron-down"></i>
                </div>
            </div>
        </header>

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-title-section">
                <div class="title-icon">
                    <i class="fas fa-user-clock"></i>
                </div>
                <div>
                    <h1>Pending Employers</h1>
                    <p class="subtitle">Review and approve employer registration requests</p>
                </div>
            </div>
            
            <div class="header-stats">
                <div class="stat-card">
                    <div class="stat-icon pending-icon">
                        <i class="fas fa-hourglass-half"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= list.size() %></h3>
                        <p>Pending Approval</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon total-icon">
                        <i class="fas fa-building"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= list.size() %></h3>
                        <p>Total Requests</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon time-icon">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Today</h3>
                        <p><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(new java.util.Date()) %></p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Search and Filters -->
            <div class="filters-section">
                <div class="search-container">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" 
                           id="searchBox" 
                           class="search-input" 
                           placeholder="Search employers by name, email, or ID...">
                    <button class="clear-search" id="clearSearch">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                
                <div class="filter-buttons">
                    <button class="filter-btn active" data-filter="all">
                        <i class="fas fa-list"></i>
                        All (<%= list.size() %>)
                    </button>
                    <button class="filter-btn" data-filter="recent">
                        <i class="fas fa-clock"></i>
                        Recent
                    </button>
                    <button class="filter-btn" data-filter="pending">
                        <i class="fas fa-user-clock"></i>
                        Pending
                    </button>
                </div>
            </div>

            <!-- Employer Table -->
            <div class="table-container" data-aos="fade-up">
                <div class="table-header">
                    <h3>Employer Requests</h3>
                    <div class="table-actions">
                        <button class="action-btn refresh-btn" id="refreshTable">
                            <i class="fas fa-sync-alt"></i>
                            Refresh
                        </button>
                        <button class="action-btn export-btn" id="exportBtn">
                            <i class="fas fa-download"></i>
                            Export
                        </button>
                    </div>
                </div>
                
                <div class="table-responsive">
                    <table id="empTable">
                        <thead>
                            <tr>
                                <th>
                                    <div class="table-header-cell">
                                        <span>ID</span>
                                        <i class="fas fa-sort sort-icon" data-sort="id"></i>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-cell">
                                        <span>Employer Details</span>
                                        <i class="fas fa-sort sort-icon" data-sort="name"></i>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-cell">
                                        <span>Contact</span>
                                        <i class="fas fa-sort sort-icon" data-sort="email"></i>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-cell">
                                        <span>Registration Date</span>
                                        <i class="fas fa-sort sort-icon" data-sort="date"></i>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-cell">
                                        <span>Status</span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-header-cell">
                                        <span>Actions</span>
                                    </div>
                                </th>
                            </tr>
                        </thead>
                        
                        <tbody>
                            <% if (list.isEmpty()) { %>
                                <tr class="no-data-row">
                                    <td colspan="6">
                                        <div class="empty-state">
                                            <i class="fas fa-users-slash"></i>
                                            <h4>No Pending Employers</h4>
                                            <p>All employer requests have been processed.</p>
                                        </div>
                                    </td>
                                </tr>
                            <% } else { 
                                int index = 0;
                                for (User u : list) { 
                                    String phone = u.getPhone() == null ? "Not provided" : u.getPhone();
                                    String registrationDate = "Today"; // You can add registration date to User model
                                    String statusClass = "status-badge status-pending";
                            %>
                                <tr class="employer-row" data-index="<%= index %>">
                                    <td>
                                        <div class="employer-id">
                                            <span class="id-badge">#<%= u.getId() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="employer-info">
                                            <div class="employer-avatar">
                                                <i class="fas fa-building"></i>
                                            </div>
                                            <div class="employer-details">
                                                <h4><%= u.getName() %></h4>
                                                <p class="company-info">
                                                    <i class="fas fa-briefcase"></i>
                                                    <span>Company details pending</span>
                                                </p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="contact-info">
                                            <div class="contact-item">
                                                <i class="fas fa-envelope"></i>
                                                <span><%= u.getEmail() %></span>
                                            </div>
                                            <div class="contact-item">
                                                <i class="fas fa-phone"></i>
                                                <span><%= phone %></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="date-info">
                                            <i class="fas fa-calendar"></i>
                                            <span><%= registrationDate %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="<%= statusClass %>">
                                            <i class="fas fa-clock"></i>
                                            Pending Approval
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="<%= contextPath %>/admin/approveEmployer?id=<%= u.getId() %>&name=<%= u.getName() %>" 
                                               class="action-btn btn-approve" 
                                               data-id="<%= u.getId() %>"
                                               data-name="<%= u.getName() %>">
                                                <i class="fas fa-check-circle"></i>
                                                Approve
                                            </a>
                                            <button class="action-btn btn-view" data-id="<%= u.getId() %>">
                                                <i class="fas fa-eye"></i>
                                                View
                                            </button>
                                            <button class="action-btn btn-reject" data-id="<%= u.getId() %>">
                                                <i class="fas fa-times"></i>
                                                Reject
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            <% 
                                    index++;
                                }
                            } 
                            %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Table Footer -->
                <div class="table-footer">
                    <div class="table-summary">
                        <p>Showing <span id="visibleCount"><%= list.size() %></span> of <span id="totalCount"><%= list.size() %></span> employer requests</p>
                    </div>
                    
                    <div class="pagination">
                        <button class="page-btn" id="prevPage" disabled>
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <span class="page-info">Page <span id="currentPage">1</span> of <span id="totalPages">1</span></span>
                        <button class="page-btn" id="nextPage" disabled>
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Statistics Section -->
            <div class="stats-section">
                <div class="stats-card">
                    <h3><i class="fas fa-chart-line"></i> Approval Statistics</h3>
                    <div class="chart-container">
                        <canvas id="approvalChart"></canvas>
                    </div>
                    <div class="chart-legend">
                        <div class="legend-item">
                            <span class="legend-color pending-color"></span>
                            <span>Pending: <%= list.size() %></span>
                        </div>
                        <div class="legend-item">
                            <span class="legend-color approved-color"></span>
                            <span>Approved: 0</span>
                        </div>
                        <div class="legend-item">
                            <span class="legend-color rejected-color"></span>
                            <span>Rejected: 0</span>
                        </div>
                    </div>
                </div>
                
                <div class="quick-actions-card">
                    <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
                    <div class="quick-actions-grid">
                        <button class="quick-action-btn" id="approveAll">
                            <i class="fas fa-check-double"></i>
                            <span>Approve All</span>
                        </button>
                        <button class="quick-action-btn" id="exportData">
                            <i class="fas fa-file-export"></i>
                            <span>Export Data</span>
                        </button>
                        <button class="quick-action-btn" id="sendReminders">
                            <i class="fas fa-bell"></i>
                            <span>Send Reminders</span>
                        </button>
                        <button class="quick-action-btn" id="viewHistory">
                            <i class="fas fa-history"></i>
                            <span>View History</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="admin-footer">
            <p>&copy; 2025 JobPortal Admin. All rights reserved.</p>
            <div class="footer-links">
                <a href="#">Privacy Policy</a>
                <span>•</span>
                <a href="#">Terms of Service</a>
                <span>•</span>
                <a href="#">Help Center</a>
            </div>
        </footer>
    </div>

    <!-- Approval Modal -->
    <div class="modal-overlay" id="approvalModal">
        <div class="modal">
            <div class="modal-header">
                <div class="modal-icon success">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h3>Approve Employer</h3>
                <button class="modal-close" id="closeModal">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to approve <strong id="modalEmployerName"></strong>?</p>
                <div class="modal-info">
                    <p><i class="fas fa-info-circle"></i> This action will grant full access to the employer account.</p>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" id="cancelApprove">Cancel</button>
                <a href="#" class="btn btn-primary" id="confirmApprove">Confirm Approval</a>
            </div>
        </div>
    </div>

    <!-- Success Toast -->
    <div class="toast-container" id="toastContainer"></div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <i class="fas fa-spinner fa-spin"></i>
            <p>Loading...</p>
        </div>
    </div>
</body>
</html>