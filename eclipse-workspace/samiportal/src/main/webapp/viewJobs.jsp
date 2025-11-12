<%@ page import="java.sql.*, util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Job Listings</title>
</head>
<body>

<h2>Available Jobs</h2>

<table border="1" cellpadding="10">
    <tr>
        <th>Title</th>
        <th>Description</th>
        <th>Company</th>
        <th>Location</th>
    </tr>

<%
    try {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM jobs";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
%>

  <tr>
    <td><%= rs.getString("title") %></td>
    <td><%= rs.getString("description") %></td>
    <td><%= rs.getString("company") %></td>
    <td><%= rs.getString("location") %></td>
    <td>
        <a href="applyJob.jsp?job_id=<%= rs.getInt("id") %>">Apply</a>
    </td>
</tr>


<%
        }
    } catch(Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    }
%>

</table>

</body>
</html>
