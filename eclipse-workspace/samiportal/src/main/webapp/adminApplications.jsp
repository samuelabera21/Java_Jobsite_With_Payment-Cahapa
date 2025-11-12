<!DOCTYPE html>
<html>
<head>
    <title>All Applications</title>
</head>
<body>

<h2>All Job Applications</h2>

<table border="1" cellspacing="5" cellpadding="8">
    <tr>
        <th>ID</th>
        <th>Job Title</th>
        <th>User Email</th>
        <th>Message</th>
        <th>Applied Date</th>
        <th>Action</th>
    </tr>

    <%
        java.sql.ResultSet apps = (java.sql.ResultSet) request.getAttribute("apps");
        if (apps != null) {
            while (apps.next()) {
    %>

    <tr>
        <td><%= apps.getInt("id") %></td>
        <td><%= apps.getString("title") %></td>
        <td><%= apps.getString("user_email") %></td>
        <td><%= apps.getString("message") %></td>
        <td><%= apps.getString("applied_at") %></td>

        <td>
            <a href="approve?id=<%= apps.getInt("id") %>">Approve</a> |
            <a href="reject?id=<%= apps.getInt("id") %>">Reject</a>
        </td>
    </tr>

    <%
            }
        }
    %>
</table>


<br>
<a href="adminHome.jsp">Back to Admin Home</a>

</body>
</html>
