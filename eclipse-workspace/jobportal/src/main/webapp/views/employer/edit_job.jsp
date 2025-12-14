<%@ page import="dao.JobDAO, dao.JobDAOImpl, models.Job" %>

<%
    int jobId = Integer.parseInt(request.getParameter("id"));
    JobDAO jobDAO = new JobDAOImpl();
    Job job = jobDAO.getById(jobId);
%>

<html>
<body>

<h2>Edit Job</h2>

<form action="<%= request.getContextPath() %>/employer/updateJob" method="post">

    <input type="hidden" name="id" value="<%= job.getId() %>">

    Title:
    <input type="text" name="title" value="<%= job.getTitle() %>" required><br><br>

    Location:
    <input type="text" name="location" value="<%= job.getLocation() %>" required><br><br>

    Category:
    <input type="text" name="category" value="<%= job.getCategory() %>"><br><br>

    Salary:
    <input type="text" name="salary" value="<%= job.getSalary() %>"><br><br>

    Email To Apply:
    <input type="email" name="email" value="<%= job.getEmailToApply() %>"><br><br>

    Employment Type:
    <select name="type">
        <option value="full-time" <%= job.getType().equals("full-time") ? "selected" : "" %>>Full Time</option>
        <option value="part-time" <%= job.getType().equals("part-time") ? "selected" : "" %>>Part Time</option>
        <option value="contract"  <%= job.getType().equals("contract")  ? "selected" : "" %>>Contract</option>
        <option value="internship"<%= job.getType().equals("internship")? "selected" : "" %>>Internship</option>
        <option value="temporary" <%= job.getType().equals("temporary") ? "selected" : "" %>>Temporary</option>
    </select>
    <br><br>

    Description:<br>
    <textarea name="description" rows="6" cols="60"><%= job.getDescription() %></textarea>
    <br><br>

    <button type="submit">Update Job</button>

</form>

</body>
</html>
