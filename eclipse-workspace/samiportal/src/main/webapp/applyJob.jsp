<%@ page import="java.sql.*, util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Apply for Job</title>
</head>
<body>

<%
    int jobId = Integer.parseInt(request.getParameter("job_id"));
    Connection conn = DBConnection.getConnection();
    String sql = "SELECT * FROM jobs WHERE id=?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, jobId);
    ResultSet rs = ps.executeQuery();
%>

<h2>Apply for Job</h2>

<%
    if (rs.next()) {
%>
    <p><b>Title:</b> <%= rs.getString("title") %></p>
    <p><b>Company:</b> <%= rs.getString("company") %></p>
    <p><b>Location:</b> <%= rs.getString("location") %></p>
<%
    }
%>

<form action="applyJob" method="post">
    <input type="hidden" name="job_id" value="<%= jobId %>">

    Message:<br>
    <textarea name="message" rows="5" cols="40"></textarea><br><br>

    <button type="submit">Submit Application</button>
</form>

</body>
</html>
