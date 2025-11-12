<!DOCTYPE html>
<html>
<head>
    <title>All Users</title>
</head>
<body>

<h2>All Registered Users</h2>

<table border="1" cellpadding="8" cellspacing="5">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Role</th>
        <th>Action</th>
    </tr>

    <%
        java.sql.ResultSet users = (java.sql.ResultSet) request.getAttribute("users");
        if (users != null) {
            while (users.next()) {
    %>

    <tr>
        <td><%= users.getInt("id") %></td>
        <td><%= users.getString("name") %></td>
        <td><%= users.getString("email") %></td>
        <td><%= users.getString("role") %></td>
        <td>
            <a href="deleteUser?id=<%= users.getInt("id") %>">Delete</a>
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
