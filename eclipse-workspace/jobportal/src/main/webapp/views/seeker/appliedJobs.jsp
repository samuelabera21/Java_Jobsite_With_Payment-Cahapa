<%@ page import="java.util.*, models.Application, models.Job" %>

<%
    List<Application> apps = (List<Application>) request.getAttribute("applications");
    Map<Integer, Job> jobs = (Map<Integer, Job>) request.getAttribute("jobs");
%>

<html>
<body>

<h2>Your Applied Jobs</h2>

<table border="1" cellpadding="8">
<tr>
    <th>Job Title</th>
    <th>Company</th>
    <th>Status</th>
    <th>Applied On</th>
    <th>Action</th>
</tr>

<%
if (apps != null && !apps.isEmpty()) {
    for (Application ap : apps) {
        Job j = jobs.get(ap.getJobId());
%>
<tr>
    <td><%= j != null ? j.getTitle() : "Unknown Job" %></td>
    <td><%= j != null ? j.getEmployerId() : "N/A" %></td>
    <td><%= ap.getStatus() %></td>
    <td><%= ap.getAppliedAt() %></td>
    <td>
        <a href="<%= request.getContextPath() %>/applyJob?job_id=<%= ap.getJobId() %>">
            View Job
        </a>
    </td>
</tr>
<%
    }
} else {
%>
<tr>
    <td colspan="5" style="text-align:center; color:red;">No applications found.</td>
</tr>
<% } %>

</table>

</body>
</html>
