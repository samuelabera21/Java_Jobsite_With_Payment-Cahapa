package controllers.seeker;

import dao.JobDAO;
import dao.JobDAOImpl;
import models.Job;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/seeker/filterJobs")
public class FilterJobServlet extends HttpServlet {

    private JobDAO jobDAO = new JobDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read filter parameters
        String location = request.getParameter("location");
        String category = request.getParameter("category");
        String type = request.getParameter("type");
        String salary = request.getParameter("salary");

        // Empty parameters should be treated as NULL
        if (location != null && location.trim().isEmpty()) location = null;
        if (category != null && category.trim().isEmpty()) category = null;
        if (type != null && type.trim().isEmpty()) type = null;
        if (salary != null && salary.trim().isEmpty()) salary = null;

        // Fetch filtered jobs
        List<Job> jobList = jobDAO.filter(location, category, type, salary);

        // Pass result to JSP
        request.setAttribute("jobs", jobList);

        // Keep filters in form
        request.setAttribute("location", location);
        request.setAttribute("category", category);
        request.setAttribute("type", type);
        request.setAttribute("salary", salary);

        request.getRequestDispatcher("/views/seeker/viewJobs.jsp").forward(request, response);
    }
}
