<!DOCTYPE html>
<html>
<head>
    <title>My Applications</title>
</head>
<body>

<h2> My Job Applications</h2>

<table border="1" cellspacing="5" cellpadding="8">
    <tr>
        <th>ID</th>
        <th>Job Title</th>
        <th>Message</th>
        <th>Date</th>
        <th>Status</th>  
    </tr>

    <%
        java.sql.ResultSet apps = (java.sql.ResultSet) request.getAttribute("apps");
        if (apps != null) {
            while (apps.next()) {
    %>
    <tr>
        <td><%= apps.getInt("id") %></td>
        <td><%= apps.getString("title") %></td>
        <td><%= apps.getString("message") %></td>
        <td><%= apps.getString("applied_at") %></td>
        <td><%= apps.getString("status") %></td>   
    </tr>
    <%
            }
        }
    %>
</table>

<br>
<a href="userHome.jsp">Back</a>

</body>
</html>
