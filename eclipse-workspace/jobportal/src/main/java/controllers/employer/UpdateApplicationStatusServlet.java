package controllers.employer;

import dao.ApplicationDAO;
import dao.ApplicationDAOImpl;
import dao.JobDAO;
import dao.JobDAOImpl;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/employer/updateApplicationStatus")
public class UpdateApplicationStatusServlet extends HttpServlet {

    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
    private JobDAO jobDAO = new JobDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=login_required");
//            return;
//        }
//
//        Integer employerId = (Integer) session.getAttribute("userId");
        
     // UPDATE: Use employerId instead of userId
        Integer employerId = (Integer) session.getAttribute("employerId");
        User employerUser = (User) session.getAttribute("employerUser");

        if (session == null || employerId == null || employerUser == null) {
            resp.sendRedirect(req.getContextPath() + "/views/auth/login.jsp?error=login_required");
            return;
        }
        String idStr = req.getParameter("id");
        String action = req.getParameter("action");

        if (idStr == null || action == null) {
            resp.sendRedirect(req.getContextPath() + "/employer/dashboard");
            return;
        }

        int appId;
        try {
            appId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/employer/dashboard");
            return;
        }

        // load application and job to verify ownership
        var app = applicationDAO.getById(appId);
        if (app == null) {
            resp.sendRedirect(req.getContextPath() + "/employer/dashboard");
            return;
        }

        var job = jobDAO.getById(app.getJobId());
        if (job == null || job.getEmployerId() != employerId) {
            // not the owner → forbidden
            resp.sendRedirect(req.getContextPath() + "/employer/dashboard?error=forbidden");
            return;
        }

        String newStatus;
        if ("approve".equalsIgnoreCase(action)) newStatus = "approved";
        else if ("reject".equalsIgnoreCase(action)) newStatus = "rejected";
        else {
            resp.sendRedirect(req.getContextPath() + "/employer/viewApplication?id=" + appId + "&error=bad_action");
            return;
        }

        boolean ok = applicationDAO.updateStatus(appId, newStatus);

        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/employer/viewApplication?id=" + appId + "&msg=status_updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/employer/viewApplication?id=" + appId + "&error=update_failed");
        }
    }
}
