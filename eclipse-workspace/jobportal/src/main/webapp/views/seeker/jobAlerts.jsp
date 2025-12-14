<%@ page import="java.util.List" %>
<%@ page import="models.JobAlert" %>
<%@ page import="models.User" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.UserDAOImpl" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String contextPath = request.getContextPath();


    
//Get user from session
User user = (User) session.getAttribute("seekerUser"); // ← CHANGE: Use seekerUser
 
//If not in session, try generic user attribute
if (user == null) {
 user = (User) session.getAttribute("user"); // Fallback to generic user
}

//Optional: If still null, try to fetch using seekerId
if (user == null) {
 Integer seekerId = (Integer) session.getAttribute("seekerId"); // ← CHANGE: Use seekerId
 if (seekerId != null) {
     try {
         UserDAO userDAO = new UserDAOImpl();
         user = userDAO.getById(seekerId);
         // Verify this is a seeker
         if (user != null && "seeker".equalsIgnoreCase(user.getRole())) {
             session.setAttribute("seekerUser", user); // ← Store as seekerUser
             session.setAttribute("user", user); // Also store as generic user
         } else if (user != null) {
             // Wrong role - don't use
             user = null;
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
 }
}
    
    List<JobAlert> alerts = (List<JobAlert>) request.getAttribute("alerts");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Job Alerts - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    
    <style>
        /* Additional styles for Job Alerts page */
        .job-alerts-container {
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
        
        .alerts-card {
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            padding: 40px;
            box-shadow: var(--shadow-xl);
            border: 1px solid var(--border-light);
            margin-bottom: 30px;
        }
        
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--border-light);
        }
        
        .section-title {
            font-size: 1.8rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .section-title i {
            color: var(--primary);
        }
        
        .create-alert-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 24px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            text-decoration: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            transition: all var(--transition-base);
        }
        
        .create-alert-btn:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, var(--primary-dark), var(--secondary));
        }
        
        .no-alerts-message {
            text-align: center;
            padding: 60px 40px;
            background: var(--bg-secondary);
            border-radius: var(--radius-xl);
            border: 2px dashed var(--border-light);
        }
        
        .no-alerts-icon {
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
        
        .no-alerts-title {
            font-size: 1.5rem;
            color: var(--text-primary);
            margin-bottom: 10px;
        }
        
        .no-alerts-description {
            color: var(--text-secondary);
            margin-bottom: 25px;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .alerts-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: var(--radius-lg);
            overflow: hidden;
            background: var(--bg-secondary);
            border: 1px solid var(--border-light);
        }
        
        .alerts-table thead {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
        }
        
        .alerts-table th {
            padding: 20px;
            text-align: left;
            color: white;
            font-weight: 600;
            font-size: 1rem;
            border-right: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .alerts-table th:last-child {
            border-right: none;
        }
        
        .alerts-table tbody tr {
            transition: all var(--transition-base);
            border-bottom: 1px solid var(--border-light);
        }
        
        .alerts-table tbody tr:last-child {
            border-bottom: none;
        }
        
        .alerts-table tbody tr:hover {
            background: var(--bg-primary);
        }
        
        .alerts-table td {
            padding: 18px 20px;
            color: var(--text-primary);
            border-right: 1px solid var(--border-light);
        }
        
        .alerts-table td:last-child {
            border-right: none;
        }
        
        .keyword-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            max-width: 300px;
        }
        
        .keyword-tag {
            background: var(--primary-light);
            color: var(--primary-dark);
            padding: 6px 12px;
            border-radius: var(--radius-full);
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .location-cell {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-primary);
        }
        
        .location-cell i {
            color: var(--secondary);
        }
        
        .frequency-cell {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .frequency-icon {
            width: 36px;
            height: 36px;
            background: var(--bg-tertiary);
            border-radius: var(--radius-full);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
        }
        
        .status-cell {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: var(--radius-full);
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-active {
            background: #d1fae5;
            color: #065f46;
        }
        
        .status-inactive {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .actions-cell {
            display: flex;
            gap: 10px;
        }
        
        .action-btn {
            padding: 8px 16px;
            border-radius: var(--radius-md);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all var(--transition-base);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        
        .action-delete {
            background: var(--danger-light);
            color: var(--danger);
            border: 1px solid var(--danger);
        }
        
        .action-delete:hover {
            background: var(--danger);
            color: white;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
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
        
        @media (max-width: 992px) {
            .job-alerts-container {
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
            
            .alerts-card {
                padding: 25px;
            }
            
            .header-section {
                flex-direction: column;
                align-items: flex-start;
                gap: 20px;
            }
            
            .alerts-table {
                display: block;
                overflow-x: auto;
            }
            
            .keyword-tags {
                max-width: 200px;
            }
        }
        
        @media (max-width: 768px) {
            .alerts-card {
                padding: 20px;
            }
            
            .alerts-table th,
            .alerts-table td {
                padding: 12px 15px;
            }
            
            .actions-cell {
                flex-direction: column;
                gap: 8px;
            }
            
            .action-btn {
                justify-content: center;
                padding: 10px;
            }
        }
        
        @media (max-width: 576px) {
            .page-title {
                font-size: 1.8rem;
            }
            
            .section-title {
                font-size: 1.4rem;
            }
            
            .no-alerts-message {
                padding: 40px 20px;
            }
            
            .keyword-tags {
                max-width: 150px;
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
                    <i class="fas fa-bell"></i>
                    <span>Job Alerts</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <div class="job-alerts-container">
            <!-- Page Header -->
            <div class="page-header-section">
                <div class="page-header">
                    <div class="page-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <h1 class="page-title">My Job Alerts</h1>
                </div>
                <p class="page-subtitle">Manage your job search alerts to stay updated on new opportunities</p>
            </div>

            <!-- Alerts Card -->
            <div class="alerts-card">
                <div class="header-section">
                    <h2 class="section-title">
                        <i class="fas fa-bell"></i>
                        Your Job Alerts
                    </h2>
                    <a href="<%= contextPath %>/views/seeker/createAlert.jsp" class="create-alert-btn">
                        <i class="fas fa-plus-circle"></i>
                        Create New Alert
                    </a>
                </div>

                <% if (alerts == null || alerts.isEmpty()) { %>
                    <div class="no-alerts-message">
                        <div class="no-alerts-icon">
                            <i class="fas fa-bell-slash"></i>
                        </div>
                        <h3 class="no-alerts-title">No Job Alerts Created</h3>
                        <p class="no-alerts-description">
                            You haven't created any job alerts yet. Create your first alert to get notified about new job opportunities.
                        </p>
                        <a href="<%= contextPath %>/views/seeker/createAlert.jsp" class="create-alert-btn">
                            <i class="fas fa-plus-circle"></i>
                            Create Your First Alert
                        </a>
                    </div>
                <% } else { %>
                    <table class="alerts-table">
                        <thead>
                            <tr>
                                <th>Keywords</th>
                                <th>Location</th>
                                <th>Frequency</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (JobAlert a : alerts) { 
                                // Parse keywords (assuming comma-separated)
                                String[] keywords = a.getKeywords() != null ? a.getKeywords().split(",") : new String[0];
                            %>
                                <tr>
                                    <td>
                                        <div class="keyword-tags">
                                            <% for (String keyword : keywords) { 
                                                String trimmedKeyword = keyword.trim();
                                                if (!trimmedKeyword.isEmpty()) { %>
                                                    <span class="keyword-tag"><%= trimmedKeyword %></span>
                                                <% }
                                            } %>
                                            <% if (keywords.length == 0) { %>
                                                <span class="keyword-tag">No keywords</span>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="location-cell">
                                            <i class="fas fa-map-marker-alt"></i>
                                            <%= a.getLocation() != null && !a.getLocation().isEmpty() ? a.getLocation() : "Anywhere" %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="frequency-cell">
                                            <div class="frequency-icon">
                                                <% if (a.getFrequency().equalsIgnoreCase("daily")) { %>
                                                    <i class="fas fa-sun"></i>
                                                <% } else if (a.getFrequency().equalsIgnoreCase("weekly")) { %>
                                                    <i class="fas fa-calendar-week"></i>
                                                <% } else if (a.getFrequency().equalsIgnoreCase("instant")) { %>
                                                    <i class="fas fa-bolt"></i>
                                                <% } else { %>
                                                    <i class="fas fa-clock"></i>
                                                <% } %>
                                            </div>
                                            <span><%= a.getFrequency() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="status-cell">
                                            <% if (a.isActive()) { %>
                                                <span class="status-badge status-active">
                                                    <i class="fas fa-check-circle"></i>
                                                    Active
                                                </span>
                                            <% } else { %>
                                                <span class="status-badge status-inactive">
                                                    <i class="fas fa-pause-circle"></i>
                                                    Inactive
                                                </span>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <a href="<%= contextPath %>/seeker/deleteAlert?id=<%= a.getId() %>" 
                                               class="action-btn action-delete"
                                               onclick="return confirm('Are you sure you want to delete this job alert?')">
                                                <i class="fas fa-trash"></i>
                                                Delete
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
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
            <p>&copy; 2025 JobPortal - Job Alerts. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/seeker/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span>•</span>
                <a href="<%= contextPath %>/views/seeker/createAlert.jsp"><i class="fas fa-plus-circle"></i> Create Alert</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/jobs"><i class="fas fa-briefcase"></i> Browse Jobs</a>
                <span>•</span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- JavaScript -->
    <script>
    /**
     * Job Alerts JavaScript
     * ES5 Compatible for Eclipse
     */
     
     
 
    
    var JobAlerts = {
        init: function() {
            this.setupThemeToggle();
            this.setupConfirmations();
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
        
        setupConfirmations: function() {
            var deleteLinks = document.querySelectorAll('.action-delete');
            for (var i = 0; i < deleteLinks.length; i++) {
                deleteLinks[i].addEventListener('click', function(e) {
                    if (!confirm('Are you sure you want to delete this job alert?')) {
                        e.preventDefault();
                    }
                });
            }
        }
    };
    
    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            JobAlerts.init();
        });
    } else {
        JobAlerts.init();
    }

    </script>
</body>
</html>