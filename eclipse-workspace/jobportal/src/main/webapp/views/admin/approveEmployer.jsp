<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // get employer id passed from URL
    String id = request.getParameter("id");
%>

<html>
<head>
    <title>Approve Employer</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .box {
            max-width: 400px;
            margin: auto;
            padding: 25px;
            border: 1px solid #ccc;
            border-radius: 8px;
            background: #fafafa;
        }
        .btn-confirm {
            background: #43A047;
            padding: 10px 18px;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .btn-cancel {
            background: #E53935;
            padding: 10px 18px;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-left: 10px;
        }
        h2 { margin-top: 0; }
    </style>
</head>

<body>

<div class="box">
    <h2>Approve Employer</h2>

    <p>Are you sure you want to approve this employer?</p>

    <p><b>User ID:</b> <%= id %></p>

    <br>

    <!-- Approve button (goes to servlet) -->
    <a class="btn-confirm"
       href="<%= request.getContextPath() %>/admin/approveEmployer?id=<%= id %>">
       Yes, Approve
    </a>

    <!-- Cancel button -->
    <a class="btn-cancel"
       href="<%= request.getContextPath() %>/admin/manageUsers">
       Cancel
    </a>
</div>

</body>
</html>
