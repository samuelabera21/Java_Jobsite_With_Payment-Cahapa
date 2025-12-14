<%@ page import="dao.UserDAO, dao.UserDAOImpl" %>
<%@ page import="models.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    UserDAO userDAO = new UserDAOImpl();
    List<User> allUsers = userDAO.getAll();
    String approvedMsg = request.getParameter("approved");
    String activatedMsg = request.getParameter("activated");
    String deactivatedMsg = request.getParameter("deactivated");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin Dashboard</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/manage_users.css">
    
    <!-- JavaScript -->
    <script src="<%= contextPath %>/assets/js/manage_users.js" defer></script>
    
    <!-- Hidden data container for JavaScript -->
    <script type="application/json" id="usersData">
        [
            <% for (int i = 0; i < allUsers.size(); i++) { 
                User u = allUsers.get(i); %>
            {
                "id": <%= u.getId() %>,
                "name": "<%= u.getName().replace("\"", "\\\"") %>",
                "email": "<%= u.getEmail().replace("\"", "\\\"") %>",
                "role": "<%= u.getRole() %>",
                "status": "<%= u.getStatus() %>",
                "phone": "<%= u.getPhone() != null ? u.getPhone().replace("\"", "\\\"") : "" %>"
            }<%= i < allUsers.size() - 1 ? "," : "" %>
            <% } %>
        ]
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

        <!-- Users Container -->
        <div class="users-container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-icon">
                    <i class="fas fa-users-cog"></i>
                </div>
                <h1 class="page-title">Manage Users</h1>
                <p class="page-subtitle">Manage user accounts, roles, and status</p>
            </div>

            <!-- Success Alerts -->
            <% if ("1".equals(approvedMsg)) { %>
                <div class="alert success fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>Employer Approved Successfully!</h4>
                        <p>The employer account has been approved.</p>
                    </div>
                </div>
            <% } %>
            
            <% if ("1".equals(activatedMsg)) { %>
                <div class="alert success fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>User Activated!</h4>
                        <p>The user account has been activated.</p>
                    </div>
                </div>
            <% } %>
            
            <% if ("1".equals(deactivatedMsg)) { %>
                <div class="alert danger fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>User Suspended!</h4>
                        <p>The user account has been suspended.</p>
                    </div>
                </div>
            <% } %>

            <!-- Users Table Container -->
            <div class="table-container fade-in">
                <div class="table-header">
                    <div class="table-info">
                        <i class="fas fa-users"></i>
                        <span>Total Users: <strong id="totalUsers"><%= allUsers.size() %></strong></span>
                        <span class="divider">|</span>
                        <span>Page: <strong id="currentPage">1</strong> of <strong id="totalPages">1</strong></span>
                        <span class="divider">|</span>
                        <span>Showing: <strong id="showingRange">1-10</strong></span>
                    </div>
                    <div class="table-actions">
                        <div class="pagination-controls" id="paginationControls">
                            <!-- Will be populated by JavaScript -->
                        </div>
                        <div class="search-container">
                            <input type="text" 
                                   id="searchInput" 
                                   class="form-control search-input" 
                                   placeholder="Search users...">
                        </div>
                    </div>
                </div>
                
                <div class="table-wrapper">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> ID</th>
                                <th><i class="fas fa-user"></i> Name</th>
                                <th><i class="fas fa-envelope"></i> Email</th>
                                <th><i class="fas fa-user-tag"></i> Role</th>
                                <th><i class="fas fa-circle"></i> Status</th>
                                <th><i class="fas fa-phone"></i> Phone</th>
                                <th><i class="fas fa-cogs"></i> Actions</th>
                            </tr>
                        </thead>
                        <tbody id="usersTableBody">
                            <!-- Will be populated by JavaScript -->
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination fade-in" id="paginationContainer">
                    <div class="pagination-info">
                        Showing <span id="showingInfo">1-10</span> of <span id="totalInfo"><%= allUsers.size() %></span> users
                    </div>
                    
                    <div class="pagination-links" id="pageLinks">
                        <!-- Will be populated by JavaScript -->
                    </div>
                    
                    <div class="pagination-jump">
                        <form id="jumpForm" class="jump-form">
                            <label for="jumpPage">Go to:</label>
                            <input type="number" 
                                   id="jumpPage" 
                                   name="page" 
                                   min="1" 
                                   max="10"
                                   value="1"
                                   class="jump-input">
                            <button type="submit" class="btn btn-primary btn-sm">
                                <i class="fas fa-arrow-right"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Edit Form -->
            <%
                String editId = request.getParameter("edit");
                if (editId != null) {
                    int id = Integer.parseInt(editId);
                    User u = userDAO.findById(id);
            %>
            <div class="edit-modal fade-in" id="editModal">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="modal-icon">
                            <i class="fas fa-user-edit"></i>
                        </div>
                        <h3>Edit User #<%= u.getId() %></h3>
                        <a href="<%= contextPath %>/admin/manageUsers" class="modal-close">
                            <i class="fas fa-times"></i>
                        </a>
                    </div>
                    
                    <form action="<%= contextPath %>/admin/updateUser" method="post" class="user-form">
                        <input type="hidden" name="id" value="<%= u.getId() %>">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-user"></i>
                                    Name
                                </label>
                                <input type="text" 
                                       name="name" 
                                       class="form-control"
                                       value="<%= u.getName() %>"
                                       placeholder="Enter user name"
                                       required>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-envelope"></i>
                                    Email
                                </label>
                                <input type="email" 
                                       name="email" 
                                       class="form-control"
                                       value="<%= u.getEmail() %>"
                                       placeholder="user@example.com"
                                       required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-phone"></i>
                                    Phone
                                </label>
                                <input type="text" 
                                       name="phone" 
                                       class="form-control"
                                       value="<%= u.getPhone() != null ? u.getPhone() : "" %>"
                                       placeholder="+1234567890">
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-user-tag"></i>
                                    Role
                                </label>
                                <select name="role" class="form-control form-select">
                                    <option value="seeker" <%= "seeker".equals(u.getRole()) ? "selected" : "" %>>Job Seeker</option>
                                    <option value="employer" <%= "employer".equals(u.getRole()) ? "selected" : "" %>>Employer</option>
                                    <option value="admin" <%= "admin".equals(u.getRole()) ? "selected" : "" %>>Administrator</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-circle"></i>
                                    Status
                                </label>
                                <select name="status" class="form-control form-select">
                                    <option value="active" <%= "active".equals(u.getStatus()) ? "selected" : "" %>>Active</option>
                                    <option value="pending" <%= "pending".equals(u.getStatus()) ? "selected" : "" %>>Pending</option>
                                    <option value="approved" <%= "approved".equals(u.getStatus()) ? "selected" : "" %>>Approved</option>
                                    <option value="suspended" <%= "suspended".equals(u.getStatus()) ? "selected" : "" %>>Suspended</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <a href="<%= contextPath %>/admin/manageUsers" class="btn btn-secondary">
                                <i class="fas fa-times"></i>
                                Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i>
                                Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <% } %>
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
                <button class="btn btn-primary" id="confirmOk">OK</button>
            </div>
        </div>
    </div>
</body>
</html>