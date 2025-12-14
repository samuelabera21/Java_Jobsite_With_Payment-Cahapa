<%@ page import="models.SeekerCV" %>
<%@ page import="models.User" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.UserDAOImpl" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
    // ---- Helper function: convert JSON array to multiline text ----
    public String jsonToLines(String json) {
        if (json == null || json.trim().equals("[]")) return "";

        String s = json.trim();
        if (s.startsWith("[") && s.endsWith("]")) {
            s = s.substring(1, s.length() - 1); // remove [ ]
        }

        java.util.List<String> items = new java.util.ArrayList<>();
        StringBuilder cur = new StringBuilder();
        boolean inQuote = false;

        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '"') inQuote = !inQuote;
            else if (c == ',' && !inQuote) {
                items.add(cur.toString());
                cur.setLength(0);
                continue;
            }
            cur.append(c);
        }
        if (cur.length() > 0) items.add(cur.toString());

        StringBuilder out = new StringBuilder();
        for (String it : items) {
            String trimmed = it.trim();
            if (trimmed.startsWith("\"")) trimmed = trimmed.substring(1);
            if (trimmed.endsWith("\"")) trimmed = trimmed.substring(0, trimmed.length() - 1);

            trimmed = trimmed
                .replace("\\n", "\n")
                .replace("\\r", "")
                .replace("\\\"", "\"")
                .replace("\\\\", "\\");

            if (!trimmed.isEmpty()) out.append(trimmed).append("\n");
        }

        return out.toString().trim();
    }
%>

<%
    String contextPath = request.getContextPath();
    
    // Get user from session
   // ========== SECURITY CHECK ==========
// Verify this is a seeker
Integer seekerId = (Integer) session.getAttribute("seekerId");
if (seekerId == null) {
    // Not logged in as seeker - redirect to login
    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
    return;
}
// ========== END SECURITY CHECK ==========

// Get user from session - use seekerUser for seekers
User user = (User) session.getAttribute("seekerUser");

// If not in session, try generic user attribute
if (user == null) {
    user = (User) session.getAttribute("user"); // Fallback to generic user
}

// Optional: If still null, try to fetch using seekerId
if (user == null) {
    try {
        UserDAO userDAO = new UserDAOImpl();
        user = userDAO.getById(seekerId);
        // Verify this is a seeker
        if (user != null && "seeker".equalsIgnoreCase(user.getRole())) {
            session.setAttribute("seekerUser", user); // Store as seekerUser
            session.setAttribute("user", user); // Also store as generic user
        } else if (user != null) {
            // Wrong role - don't use
            user = null;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}
    
    SeekerCV cv = (SeekerCV) request.getAttribute("cv");
    String successMsg = request.getParameter("msg");

    String headline = cv != null ? cv.getHeadline() : "";
    String about = cv != null ? cv.getAbout() : "";
    String educationJson = cv != null ? cv.getEducation() : "[]";
    String experienceJson = cv != null ? cv.getExperience() : "[]";
    String skillsJson = cv != null ? cv.getSkills() : "[]";
    String attachmentsJson = cv != null ? cv.getAttachments() : "[]";

    String educationLines = jsonToLines(educationJson);
    String experienceLines = jsonToLines(experienceJson);

    String skillsComma = "";
    if (skillsJson != null && !skillsJson.equals("[]")) {
        String tmp = skillsJson.substring(1, skillsJson.length() - 1);
        tmp = tmp.replace("\\\"", "\"").replace("\"", "");
        skillsComma = tmp;
    }

    java.util.List<String> attachments = new java.util.ArrayList<>();
    if (attachmentsJson != null && attachmentsJson.length() > 2) {
        String tmp = attachmentsJson.substring(1, attachmentsJson.length() - 1);
        String[] parts = tmp.split(",");
        for (String p : parts) {
            String t = p.trim();
            if (t.startsWith("\"")) t = t.substring(1);
            if (t.endsWith("\"")) t = t.substring(0, t.length() - 1);
            t = t.replace("\\\"", "\"").replace("\\\\", "\\");
            if (!t.isEmpty()) attachments.add(t);
        }
    }
    
    // Get user details for preview
    String userFullName = "Your Name";
    String userEmail = "your.email@example.com";
    String userPhone = "Not provided";
    
    if (user != null) {
        // Check what methods are available in your User class
        // Common getter methods might be: getFirstName(), getLastName(), getName(), getUsername()
        // Let's try to construct the full name based on available methods
        try {
            // Try to get first name and last name
            String firstName = "";
            String lastName = "";
            
            // Check available methods
            java.lang.reflect.Method[] methods = user.getClass().getMethods();
            boolean hasFirstName = false;
            boolean hasLastName = false;
            boolean hasName = false;
            
            for (java.lang.reflect.Method method : methods) {
                if (method.getName().equals("getFirstName")) {
                    firstName = (String) method.invoke(user);
                    hasFirstName = true;
                }
                if (method.getName().equals("getLastName")) {
                    lastName = (String) method.invoke(user);
                    hasLastName = true;
                }
                if (method.getName().equals("getName")) {
                    userFullName = (String) method.invoke(user);
                    hasName = true;
                }
            }
            
            // Construct full name if we have first and last name
            if (hasFirstName && hasLastName) {
                userFullName = firstName + " " + lastName;
            } else if (hasName) {
                // Already set above
            } else {
                // Try getUsername as fallback
                java.lang.reflect.Method getUsername = user.getClass().getMethod("getUsername");
                if (getUsername != null) {
                    userFullName = (String) getUsername.invoke(user);
                }
            }
            
            // Get email
            java.lang.reflect.Method getEmail = user.getClass().getMethod("getEmail");
            if (getEmail != null) {
                userEmail = (String) getEmail.invoke(user);
            }
            
            // Get phone
            java.lang.reflect.Method getPhone = user.getClass().getMethod("getPhone");
            if (getPhone != null) {
                Object phoneObj = getPhone.invoke(user);
                if (phoneObj != null) {
                    userPhone = phoneObj.toString();
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Use fallback values if reflection fails
            userFullName = "Your Name";
            userEmail = user != null ? "user@example.com" : "your.email@example.com";
            userPhone = "Not provided";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CV Builder - JobPortal</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/seeker_dashboard.css">
    
    <style>
        /* All the CSS styles remain exactly the same as before */
        .cv-builder-container {
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
        
        .cv-form-card {
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            padding: 40px;
            box-shadow: var(--shadow-xl);
            border: 1px solid var(--border-light);
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--border-light);
        }
        
        .form-header h3 {
            font-size: 1.8rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .form-header h3 i {
            color: var(--primary);
        }
        
        .form-section {
            margin-bottom: 35px;
            padding-bottom: 35px;
            border-bottom: 1px solid var(--border-light);
        }
        
        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 25px;
        }
        
        .section-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        
        .section-title {
            font-size: 1.4rem;
            color: var(--text-primary);
            font-weight: 600;
        }
        
        .section-description {
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin-top: 5px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            color: var(--text-primary);
            font-weight: 600;
            margin-bottom: 12px;
            font-size: 1rem;
        }
        
        .form-label i {
            color: var(--primary);
            margin-right: 8px;
        }
        
        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 1px solid var(--border-light);
            border-radius: var(--radius-lg);
            background: var(--bg-secondary);
            color: var(--text-primary);
            font-size: 1rem;
            transition: all var(--transition-base);
            font-family: inherit;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            background: var(--bg-primary);
        }
        
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
            line-height: 1.6;
        }
        
        .form-hint {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .attachments-section {
            background: var(--bg-secondary);
            border-radius: var(--radius-xl);
            padding: 25px;
            margin-top: 15px;
        }
        
        .file-input-wrapper {
            position: relative;
            margin-bottom: 15px;
        }
        
        .file-input-wrapper input[type="file"] {
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }
        
        .file-input-label {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 24px;
            background: var(--primary);
            color: white;
            border-radius: var(--radius-lg);
            cursor: pointer;
            font-weight: 500;
            transition: all var(--transition-base);
        }
        
        .file-input-label:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .file-requirements {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-top: 10px;
        }
        
        .attachments-list {
            margin-top: 25px;
        }
        
        .attachments-title {
            font-size: 1.1rem;
            color: var(--text-primary);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .attachment-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            background: var(--bg-primary);
            border-radius: var(--radius-lg);
            margin-bottom: 10px;
            border: 1px solid var(--border-light);
            transition: all var(--transition-base);
        }
        
        .attachment-item:hover {
            background: var(--bg-secondary);
            border-color: var(--primary-light);
        }
        
        .attachment-icon {
            color: var(--primary);
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        
        .attachment-name {
            color: var(--text-primary);
            flex: 1;
            word-break: break-all;
        }
        
        .attachment-link {
            color: var(--primary);
            text-decoration: none;
            padding: 6px 12px;
            border-radius: var(--radius-md);
            transition: all var(--transition-base);
        }
        
        .attachment-link:hover {
            background: var(--primary);
            color: white;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 50px;
            padding-top: 30px;
            border-top: 1px solid var(--border-light);
        }
        
        .btn-save {
            flex: 2;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 18px;
            border: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all var(--transition-base);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }
        
        .btn-save:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, var(--primary-dark), var(--secondary));
        }
        
        .btn-preview {
            flex: 1;
            background: var(--secondary);
            color: white;
            padding: 18px;
            border: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all var(--transition-base);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }
        
        .btn-preview:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            background: var(--secondary-dark);
        }
        
        .btn-cancel {
            flex: 1;
            background: var(--bg-tertiary);
            color: var(--text-primary);
            padding: 18px;
            border: 1px solid var(--border-light);
            border-radius: var(--radius-lg);
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all var(--transition-base);
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            text-align: center;
        }
        
        .btn-cancel:hover {
            background: var(--border-light);
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }
        
        .character-count {
            text-align: right;
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-top: 5px;
        }
        
        /* Preview Modal Styles */
        .preview-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1002;
            padding: 20px;
            backdrop-filter: blur(8px);
        }
        
        .preview-modal.active {
            display: flex;
            animation: fadeIn 0.3s ease;
        }
        
        .preview-content {
            background: var(--bg-card);
            border-radius: var(--radius-2xl);
            width: 100%;
            max-width: 900px;
            max-height: 90vh;
            overflow: hidden;
            box-shadow: var(--shadow-2xl);
            border: 1px solid var(--border-light);
            animation: modalSlideIn 0.4s ease;
        }
        
        .preview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 25px 30px;
            border-bottom: 1px solid var(--border-light);
            background: var(--bg-secondary);
        }
        
        .preview-title {
            font-size: 1.5rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .preview-title i {
            color: var(--primary);
        }
        
        .preview-close {
            background: none;
            border: none;
            color: var(--text-secondary);
            font-size: 1.5rem;
            cursor: pointer;
            padding: 8px;
            border-radius: var(--radius-md);
            transition: all var(--transition-base);
        }
        
        .preview-close:hover {
            color: var(--danger);
            background: var(--bg-tertiary);
        }
        
        .preview-body {
            padding: 30px;
            overflow-y: auto;
            max-height: calc(90vh - 100px);
        }
        
        .cv-preview {
            background: white;
            border-radius: var(--radius-xl);
            padding: 40px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-light);
        }
        
        .cv-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--primary);
        }
        
        .cv-name {
            font-size: 2.2rem;
            color: #1e293b;
            margin-bottom: 5px;
            font-weight: 700;
        }
        
        .cv-headline {
            font-size: 1.3rem;
            color: #3b82f6;
            margin-bottom: 15px;
            font-weight: 500;
        }
        
        .cv-contact {
            display: flex;
            justify-content: center;
            gap: 20px;
            color: #64748b;
            font-size: 0.95rem;
            flex-wrap: wrap;
        }
        
        .cv-contact-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .cv-section {
            margin-bottom: 30px;
        }
        
        .cv-section-title {
            font-size: 1.4rem;
            color: #1e293b;
            margin-bottom: 15px;
            padding-bottom: 8px;
            border-bottom: 1px solid #e2e8f0;
            font-weight: 600;
        }
        
        .cv-section-content {
            color: #475569;
            line-height: 1.6;
        }
        
        .cv-about {
            white-space: pre-line;
            line-height: 1.8;
        }
        
        .cv-list {
            list-style: none;
            padding: 0;
        }
        
        .cv-list-item {
            margin-bottom: 12px;
            padding-left: 20px;
            position: relative;
        }
        
        .cv-list-item:before {
            content: "•";
            color: #3b82f6;
            font-size: 1.5rem;
            position: absolute;
            left: 0;
            top: -2px;
        }
        
        .cv-skills {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .skill-tag {
            background: #e0f2fe;
            color: #0369a1;
            padding: 6px 12px;
            border-radius: var(--radius-full);
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .cv-attachments {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 10px;
        }
        
        .attachment-badge {
            background: #f0f9ff;
            border: 1px solid #bae6fd;
            padding: 8px 15px;
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
        }
        
        .attachment-badge i {
            color: #3b82f6;
        }
        
        .preview-footer {
            text-align: center;
            padding: 20px;
            border-top: 1px solid var(--border-light);
            background: var(--bg-secondary);
            color: var(--text-secondary);
            font-size: 0.9rem;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes modalSlideIn {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        @media (max-width: 992px) {
            .cv-builder-container {
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
            
            .cv-form-card {
                padding: 25px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn-save, .btn-preview, .btn-cancel {
                flex: 1;
                width: 100%;
            }
            
            .preview-content {
                max-width: 95%;
                max-height: 85vh;
            }
            
            .cv-preview {
                padding: 25px;
            }
        }
        
        @media (max-width: 768px) {
            .section-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .cv-form-card {
                padding: 20px;
            }
            
            .attachments-section {
                padding: 20px;
            }
            
            .cv-name {
                font-size: 1.8rem;
            }
            
            .cv-headline {
                font-size: 1.1rem;
            }
            
            .cv-contact {
                flex-direction: column;
                align-items: center;
                gap: 10px;
            }
        }
        
        @media (max-width: 576px) {
            .page-title {
                font-size: 1.8rem;
            }
            
            .section-title {
                font-size: 1.2rem;
            }
            
            .form-control {
                padding: 14px 16px;
            }
            
            .preview-body {
                padding: 15px;
            }
            
            .cv-preview {
                padding: 20px;
            }
            
            .cv-name {
                font-size: 1.5rem;
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
                    <span>CV Builder</span>
                </div>
                <button id="themeToggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span>Dark Mode</span>
                </button>
            </div>
        </header>

        <div class="cv-builder-container">
            <!-- Page Header -->
            <div class="page-header-section">
                <div class="page-header">
                    <div class="page-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <h1 class="page-title">CV Builder</h1>
                </div>
                <p class="page-subtitle">Create or update your professional CV to impress employers</p>
            </div>

            <!-- Success Message -->
            <% if (successMsg != null) { %>
                <div class="alert success fade-in">
                    <div class="alert-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="alert-content">
                        <h4>CV Saved Successfully!</h4>
                        <p>Your CV has been updated and saved.</p>
                    </div>
                </div>
            <% } %>

            <!-- CV Form Card -->
            <div class="cv-form-card">
                <!-- EXACT SAME FORM ACTION AND FIELDS AS ORIGINAL -->
                <form action="<%= contextPath %>/seeker/cvbuilder"
                      method="post" 
                      enctype="multipart/form-data"
                      id="cvBuilderForm">
                    
                    <!-- Headline Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-heading"></i>
                            </div>
                            <div>
                                <div class="section-title">Professional Headline</div>
                                <div class="section-description">A brief title that describes your professional identity</div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="headline" class="form-label">
                                <i class="fas fa-bullhorn"></i> Headline
                            </label>
                            <input type="text" 
                                   id="headline" 
                                   name="headline" 
                                   class="form-control" 
                                   value="<%= headline %>" 
                                   placeholder="e.g., Senior Software Developer | Full Stack Engineer"
                                   maxlength="100">
                            <div class="character-count" id="headlineCount">
                                <%= headline.length() %> / 100 characters
                            </div>
                        </div>
                    </div>
                    
                    <!-- About Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <div>
                                <div class="section-title">About Me</div>
                                <div class="section-description">Write a summary about yourself, your experience, and career goals</div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="about" class="form-label">
                                <i class="fas fa-info-circle"></i> About
                            </label>
                            <textarea id="about" 
                                      name="about" 
                                      class="form-control" 
                                      rows="8"
                                      placeholder="Describe your professional background, skills, and career objectives..."><%= about %></textarea>
                            <div class="character-count" id="aboutCount">
                                <%= about.length() %> / 2000 characters
                            </div>
                        </div>
                    </div>
                    
                    <!-- Education Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-graduation-cap"></i>
                            </div>
                            <div>
                                <div class="section-title">Education</div>
                                <div class="section-description">List your educational qualifications (one per line)</div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="education" class="form-label">
                                <i class="fas fa-university"></i> Education
                            </label>
                            <textarea id="education" 
                                      name="education" 
                                      class="form-control" 
                                      rows="6"
                                      placeholder="Example:&#10;BSc Computer Science - University of Example (2018-2022)&#10;High School Diploma - Example High School (2016-2018)"><%= educationLines %></textarea>
                            <div class="form-hint">
                                <i class="fas fa-lightbulb"></i>
                                <span>Enter one education entry per line</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Experience Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-briefcase"></i>
                            </div>
                            <div>
                                <div class="section-title">Work Experience</div>
                                <div class="section-description">List your professional work experience (one per line)</div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="experience" class="form-label">
                                <i class="fas fa-history"></i> Experience
                            </label>
                            <textarea id="experience" 
                                      name="experience" 
                                      class="form-control" 
                                      rows="6"
                                      placeholder="Example:&#10;Software Developer - ABC Company (2022-Present)&#10;Junior Developer - XYZ Corp (2020-2022)"><%= experienceLines %></textarea>
                            <div class="form-hint">
                                <i class="fas fa-lightbulb"></i>
                                <span>Enter one work experience entry per line</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Skills Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-tools"></i>
                            </div>
                            <div>
                                <div class="section-title">Skills</div>
                                <div class="section-description">List your professional skills separated by commas</div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="skills" class="form-label">
                                <i class="fas fa-cogs"></i> Skills
                            </label>
                            <input type="text" 
                                   id="skills" 
                                   name="skills" 
                                   class="form-control" 
                                   value="<%= skillsComma %>" 
                                   placeholder="e.g., Java, Spring Boot, MySQL, React, Project Management"
                                   maxlength="500">
                            <div class="character-count" id="skillsCount">
                                <%= skillsComma.length() %> / 500 characters
                            </div>
                            <div class="form-hint">
                                <i class="fas fa-lightbulb"></i>
                                <span>Separate skills with commas (e.g., Java, Spring Boot, MySQL)</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Attachments Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-paperclip"></i>
                            </div>
                            <div>
                                <div class="section-title">Attachments</div>
                                <div class="section-description">Upload supporting documents like certificates, portfolio, etc.</div>
                            </div>
                        </div>
                        
                        <div class="attachments-section">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-upload"></i> Upload Files
                                </label>
                                
                                <div class="file-input-wrapper">
                                    <input type="file" 
                                           id="attachments" 
                                           name="attachments" 
                                           multiple
                                           onchange="CVBuilder.updateFileList(this)">
                                    <label for="attachments" class="file-input-label">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                        Choose Files
                                    </label>
                                </div>
                                
                                <div class="file-requirements">
                                    <i class="fas fa-info-circle"></i>
                                    <span>Accepted formats: PDF, JPG, PNG, DOC, DOCX (Max 10MB per file)</span>
                                </div>
                                
                                <div id="fileList" class="attachments-list" style="display: none;">
                                    <div class="attachments-title">
                                        <i class="fas fa-files"></i>
                                        <span>Selected Files:</span>
                                    </div>
                                    <div id="selectedFiles"></div>
                                </div>
                            </div>
                            
                            <% if (!attachments.isEmpty()) { %>
                                <div class="attachments-list">
                                    <div class="attachments-title">
                                        <i class="fas fa-folder-open"></i>
                                        <span>Your Uploaded Files:</span>
                                    </div>
                                    <% for (String a : attachments) { %>
                                        <div class="attachment-item">
                                            <div class="attachment-icon">
                                                <% if (a.toLowerCase().endsWith(".pdf")) { %>
                                                    <i class="fas fa-file-pdf"></i>
                                                <% } else if (a.toLowerCase().endsWith(".jpg") || a.toLowerCase().endsWith(".jpeg") || a.toLowerCase().endsWith(".png")) { %>
                                                    <i class="fas fa-file-image"></i>
                                                <% } else if (a.toLowerCase().endsWith(".doc") || a.toLowerCase().endsWith(".docx")) { %>
                                                    <i class="fas fa-file-word"></i>
                                                <% } else { %>
                                                    <i class="fas fa-file"></i>
                                                <% } %>
                                            </div>
                                            <div class="attachment-name">
                                                <%= a.substring(a.lastIndexOf("/") + 1) %>
                                            </div>
                                            <a href="<%= contextPath + "/" + a %>" 
                                               target="_blank" 
                                               class="attachment-link">
                                                <i class="fas fa-eye"></i>
                                                View
                                            </a>
                                        </div>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    
                    <!-- Form Actions -->
                    <div class="form-actions">
                        <a href="<%= contextPath %>/seeker/dashboard" class="btn-cancel">
                            <i class="fas fa-times"></i>
                            Cancel
                        </a>
                        <button type="button" class="btn-preview" onclick="CVBuilder.showPreview()">
                            <i class="fas fa-eye"></i>
                            Preview CV
                        </button>
                        <button type="submit" class="btn-save">
                            <i class="fas fa-save"></i>
                            Save CV
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2025 JobPortal - CV Builder. All rights reserved.</p>
            <div class="footer-links">
                <a href="<%= contextPath %>/seeker/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/cvTemplates"><i class="fas fa-file-pdf"></i> CV Templates</a>
                <span>•</span>
                <a href="<%= contextPath %>/seeker/downloadCV"><i class="fas fa-download"></i> Download CV</a>
                <span>•</span>
                <a href="<%= contextPath %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </footer>
    </div>

    <!-- Preview Modal -->
    <div class="preview-modal" id="previewModal">
        <div class="preview-content">
            <div class="preview-header">
                <div class="preview-title">
                    <i class="fas fa-file-alt"></i>
                    CV Preview
                </div>
                <button class="preview-close" onclick="CVBuilder.hidePreview()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="preview-body">
                <div class="cv-preview" id="cvPreview">
                    <!-- Preview content will be generated by JavaScript -->
                </div>
            </div>
            
            <div class="preview-footer">
                <p>This is a preview of how your CV will look. Make sure all information is correct before saving.</p>
            </div>
        </div>
    </div>

    <!-- Loading Overlay (from dashboard) -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <i class="fas fa-cog fa-spin"></i>
            <p>Saving CV...</p>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
    /**
     * CV Builder JavaScript with Preview Feature
     * ES5 Compatible for Eclipse
     */
    
    var CVBuilder = {
        init: function() {
            this.setupThemeToggle();
            this.setupFormValidation();
            this.setupCharacterCounters();
            this.setupFileUpload();
            this.setupPreviewModal();
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
        
        setupFormValidation: function() {
            var form = document.getElementById('cvBuilderForm');
            if (!form) return;
            
            form.addEventListener('submit', function(e) {
                var headline = document.getElementById('headline').value.trim();
                var about = document.getElementById('about').value.trim();
                
                // Basic validation
                if (headline.length === 0) {
                    e.preventDefault();
                    alert('Please enter a professional headline.');
                    document.getElementById('headline').focus();
                    return;
                }
                
                if (about.length === 0) {
                    e.preventDefault();
                    alert('Please write something about yourself.');
                    document.getElementById('about').focus();
                    return;
                }
                
                // File validation
                var fileInput = document.getElementById('attachments');
                if (fileInput.files.length > 0) {
                    var maxSize = 10 * 1024 * 1024; // 10MB
                    var allowedTypes = [
                        'application/pdf',
                        'image/jpeg',
                        'image/jpg',
                        'image/png',
                        'application/msword',
                        'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                    ];
                    
                    for (var i = 0; i < fileInput.files.length; i++) {
                        var file = fileInput.files[i];
                        
                        if (!allowedTypes.includes(file.type)) {
                            e.preventDefault();
                            alert('Please upload only PDF, JPG, PNG, DOC, or DOCX files.');
                            return;
                        }
                        
                        if (file.size > maxSize) {
                            e.preventDefault();
                            alert('File "' + file.name + '" exceeds 10MB limit.');
                            return;
                        }
                    }
                }
                
                // Show loading
                CVBuilder.showLoading();
            });
        },
        
        setupCharacterCounters: function() {
            var headlineInput = document.getElementById('headline');
            var aboutInput = document.getElementById('about');
            var skillsInput = document.getElementById('skills');
            
            if (headlineInput) {
                headlineInput.addEventListener('input', function() {
                    document.getElementById('headlineCount').textContent = 
                        this.value.length + ' / 100 characters';
                });
            }
            
            if (aboutInput) {
                aboutInput.addEventListener('input', function() {
                    document.getElementById('aboutCount').textContent = 
                        this.value.length + ' / 2000 characters';
                });
            }
            
            if (skillsInput) {
                skillsInput.addEventListener('input', function() {
                    document.getElementById('skillsCount').textContent = 
                        this.value.length + ' / 500 characters';
                });
            }
        },
        
        setupFileUpload: function() {
            // Initialized by onchange attribute
        },
        
        updateFileList: function(input) {
            var fileListDiv = document.getElementById('fileList');
            var selectedFilesDiv = document.getElementById('selectedFiles');
            
            if (input.files.length === 0) {
                fileListDiv.style.display = 'none';
                return;
            }
            
            selectedFilesDiv.innerHTML = '';
            
            for (var i = 0; i < input.files.length; i++) {
                var file = input.files[i];
                var fileSize = (file.size / (1024 * 1024)).toFixed(2); // MB
                
                var fileItem = document.createElement('div');
                fileItem.className = 'attachment-item';
                
                // Determine icon based on file type
                var icon = 'file';
                if (file.type.includes('pdf')) icon = 'file-pdf';
                else if (file.type.includes('image')) icon = 'file-image';
                else if (file.type.includes('word') || file.type.includes('document')) icon = 'file-word';
                
                fileItem.innerHTML = [
                    '<div class="attachment-icon">',
                    '    <i class="fas fa-' + icon + '"></i>',
                    '</div>',
                    '<div class="attachment-name">',
                    '    ' + this.escapeHtml(file.name),
                    '</div>',
                    '<div style="color: var(--text-secondary); font-size: 0.9rem;">',
                    '    ' + fileSize + ' MB',
                    '</div>'
                ].join('');
                
                selectedFilesDiv.appendChild(fileItem);
            }
            
            fileListDiv.style.display = 'block';
        },
        
        setupPreviewModal: function() {
            // Close modal when clicking outside
            var modal = document.getElementById('previewModal');
            if (modal) {
                modal.addEventListener('click', function(e) {
                    if (e.target === this) {
                        CVBuilder.hidePreview();
                    }
                });
            }
            
            // Close modal with Escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    CVBuilder.hidePreview();
                }
            });
        },
        
        showPreview: function() {
            // Get form values
            var headline = document.getElementById('headline').value.trim() || '[No headline provided]';
            var about = document.getElementById('about').value.trim() || '[No about information provided]';
            var education = document.getElementById('education').value.trim() || '[No education information provided]';
            var experience = document.getElementById('experience').value.trim() || '[No experience information provided]';
            var skills = document.getElementById('skills').value.trim() || '[No skills provided]';
            
            // Get user info from JSP variables
            var userFullName = '<%= userFullName %>';
            var userEmail = '<%= userEmail %>';
            var userPhone = '<%= userPhone %>';
            
            // Split multi-line fields into arrays
            var educationLines = education.split('\n').filter(function(line) {
                return line.trim().length > 0;
            });
            
            var experienceLines = experience.split('\n').filter(function(line) {
                return line.trim().length > 0;
            });
            
            // Split skills by comma and clean up
            var skillItems = skills.split(',').map(function(skill) {
                return skill.trim();
            }).filter(function(skill) {
                return skill.length > 0;
            });
            
            // Build preview HTML
            var previewHTML = [
                '<div class="cv-header">',
                '    <div class="cv-name">' + this.escapeHtml(userFullName) + '</div>',
                '    <div class="cv-headline">' + this.escapeHtml(headline) + '</div>',
                '    <div class="cv-contact">',
                '        <div class="cv-contact-item"><i class="fas fa-envelope"></i> ' + this.escapeHtml(userEmail) + '</div>',
                '        <div class="cv-contact-item"><i class="fas fa-phone"></i> ' + this.escapeHtml(userPhone) + '</div>',
                '    </div>',
                '</div>',
                '',
                '<div class="cv-section">',
                '    <div class="cv-section-title">About Me</div>',
                '    <div class="cv-section-content cv-about">' + this.escapeHtml(about).replace(/\n/g, '<br>') + '</div>',
                '</div>',
                '',
                educationLines.length > 0 ? [
                    '<div class="cv-section">',
                    '    <div class="cv-section-title">Education</div>',
                    '    <ul class="cv-list">'
                ].join('') : '',
                
                educationLines.map(function(edu) {
                    return '<li class="cv-list-item">' + CVBuilder.escapeHtml(edu) + '</li>';
                }).join(''),
                
                educationLines.length > 0 ? [
                    '</ul>',
                    '</div>',
                    ''
                ].join('') : '',
                
                experienceLines.length > 0 ? [
                    '<div class="cv-section">',
                    '    <div class="cv-section-title">Work Experience</div>',
                    '    <ul class="cv-list">'
                ].join('') : '',
                
                experienceLines.map(function(exp) {
                    return '<li class="cv-list-item">' + CVBuilder.escapeHtml(exp) + '</li>';
                }).join(''),
                
                experienceLines.length > 0 ? [
                    '</ul>',
                    '</div>',
                    ''
                ].join('') : '',
                
                skillItems.length > 0 ? [
                    '<div class="cv-section">',
                    '    <div class="cv-section-title">Skills</div>',
                    '    <div class="cv-section-content">',
                    '        <div class="cv-skills">'
                ].join('') : '',
                
                skillItems.map(function(skill) {
                    return '<span class="skill-tag">' + CVBuilder.escapeHtml(skill) + '</span>';
                }).join(''),
                
                skillItems.length > 0 ? [
                    '        </div>',
                    '    </div>',
                    '</div>'
                ].join('') : ''
            ].join('');
            
            // Show modal
            document.getElementById('cvPreview').innerHTML = previewHTML;
            document.getElementById('previewModal').classList.add('active');
            document.body.style.overflow = 'hidden';
        },
        
        hidePreview: function() {
            document.getElementById('previewModal').classList.remove('active');
            document.body.style.overflow = '';
        },
        
        showLoading: function() {
            var overlay = document.getElementById('loadingOverlay');
            if (!overlay) {
                overlay = document.createElement('div');
                overlay.id = 'loadingOverlay';
                overlay.className = 'loading-overlay';
                overlay.innerHTML = '<div class="loading-spinner"><i class="fas fa-cog fa-spin"></i><p>Saving CV...</p></div>';
                document.body.appendChild(overlay);
            }
            overlay.style.display = 'flex';
            document.body.style.overflow = 'hidden';
        },
        
        escapeHtml: function(text) {
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
    };
    
    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            CVBuilder.init();
        });
    } else {
        CVBuilder.init();
    }
    </script>
</body>
</html>