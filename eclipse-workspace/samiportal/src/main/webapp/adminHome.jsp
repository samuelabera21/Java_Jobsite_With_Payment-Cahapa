<!DOCTYPE html>
<html>
<head>
    <title>Admin Home</title>
</head>
<body>

<h2>Welcome Admin Dashboard</h2>
<p>Hello, <%= session.getAttribute("user") %>!</p>

<a href="addJob.jsp">Post Job</a>

<a href="adminViewApps">View All Applications</a><br>
<a href="logout">Logout</a>
<a href="viewUsers">View Users (Static)</a>  <!-- Optional -->
<br>
<a href="viewUsers">Manage Users</a>  



</body>
</html>
