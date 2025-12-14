package controllers.seeker;

import dao.ApplicationDAO;
import models.User;
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

@WebServlet("/seeker/applications")
public class ViewApplicationsServlet extends HttpServlet {

    private ApplicationDAO appDAO = new ApplicationDAOImpl();
    private JobDAO jobDAO = new JobDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
//
//        if (session == null || session.getAttribute("userId") == null) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp?error=login_required");
//            return;
//        }
//
//        int seekerId = (Integer) session.getAttribute("userId");
        
        
     // UPDATE: Use seekerId instead of userId
        Integer seekerId = (Integer) session.getAttribute("seekerId");
        User seekerUser = (User) session.getAttribute("seekerUser");

        if (session == null || seekerId == null || seekerUser == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=login_required");
            return;
        }

        // Get all applications for seeker
        List<Application> applications = appDAO.getBySeeker(seekerId);

        // Load job info for each application
        Map<Integer, Job> jobMap = new HashMap<>();

        for (Application app : applications) {
            Job job = jobDAO.getById(app.getJobId());
            if (job != null) jobMap.put(app.getJobId(), job);
        }

        request.setAttribute("applications", applications);
        request.setAttribute("jobs", jobMap);

        request.getRequestDispatcher("/views/seeker/viewApplications.jsp").forward(request, response);
    }
}
