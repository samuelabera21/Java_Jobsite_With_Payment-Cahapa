package controllers.seeker;

import dao.ApplicationDAO;
import dao.ApplicationDAOImpl;
import dao.JobDAO;
import dao.JobDAOImpl;
import models.Application;
import models.Job;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/seeker/appliedJobs")
public class AppliedJobsServlet extends HttpServlet {

    private ApplicationDAO appDAO = new ApplicationDAOImpl();
    private JobDAO jobDAO = new JobDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=login_required");
            return;
        }

        int seekerId = (Integer) session.getAttribute("userId");

        // Get all applications by seeker
        List<Application> applications = appDAO.getBySeeker(seekerId);

        // Map for job details
        Map<Integer, Job> jobMap = new HashMap<>();

        for (Application app : applications) {
            Job j = jobDAO.getById(app.getJobId());
            if (j != null) jobMap.put(app.getJobId(), j);
        }

        request.setAttribute("applications", applications);
        request.setAttribute("jobs", jobMap);

        request.getRequestDispatcher("/views/seeker/appliedJobs.jsp").forward(request, response);
    }
}
