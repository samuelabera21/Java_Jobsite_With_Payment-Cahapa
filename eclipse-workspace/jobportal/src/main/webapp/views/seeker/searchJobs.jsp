<%@ page import="java.util.*, models.Job" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<h2>Search Results for: "<%= request.getAttribute("keyword") %>"</h2>

<a href="<%= request.getContextPath() %>/viewJobs.jsp">Back to Jobs</a>
<br><br>

<%
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");

    if (jobs == null || jobs.isEmpty()) {
%>
        <p>No jobs found.</p>
<%
    } else {
        for (Job j : jobs) {
%>
            <div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">
                <h3><%= j.getTitle() %></h3>
                <p><strong>Location:</strong> <%= j.getLocation() %></p>
                <p><strong>Description:</strong> <%= j.getDescription() %></p>

                <a href="<%= request.getContextPath() %>/views/seeker/applyJob.jsp?job_id=<%= j.getId() %>">
                    Apply Now
                </a>
            </div>
<%
        }
    }
%>
