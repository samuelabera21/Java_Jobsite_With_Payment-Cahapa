<!DOCTYPE html>
<html>
<head>
    <title>User Home</title>
</head>
<body>

<h2> Welcome User Dashboard</h2>



<h2> Welcome User Dashboard</h2>

<p>Hello, <%= session.getAttribute("user") %>!</p>

<a href="viewJobs.jsp">View Jobs</a><br>
<a href="viewApplications">My Applications</a><br>
<a href="logout">Logout</a>


</body>
</html>
