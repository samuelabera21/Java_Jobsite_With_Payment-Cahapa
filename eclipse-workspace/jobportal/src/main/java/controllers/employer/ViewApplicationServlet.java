package controllers.employer;

import dao.ApplicationDAO;
import dao.ApplicationDAOImpl;
import dao.JobDAO;
import dao.JobDAOImpl;
import dao.UserDAO;
import dao.UserDAOImpl;
import models.Application;
import models.Job;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/employer/viewApplication")
public class ViewApplicationServlet extends HttpServlet {

    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
    private JobDAO jobDAO = new JobDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=login_required");
//            return;
//        }
//
//        Integer employerId = (Integer) session.getAttribute("userId");
        
        
        
     // Check for employer-specific session attribute
        Integer employerId = (Integer) session.getAttribute("employerId");
        User employerUser = (User) session.getAttribute("employerUser");

        if (session == null || employerId == null || employerUser == null) {
            resp.sendRedirect(req.getContextPath() + "/views/auth/login.jsp?error=login_required");
            return;
        }
        String idStr = req.getParameter("id");
        if (idStr == null) {
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

        Application app = applicationDAO.getById(appId);
        if (app == null) {
            // not found
            resp.sendRedirect(req.getContextPath() + "/employer/dashboard");
            return;
        }

        // ensure this employer owns the job that this application refers to
        Job job = jobDAO.getById(app.getJobId());
        if (job == null || job.getEmployerId() != employerId) {
            // forbidden - not the owner
            resp.sendRedirect(req.getContextPath() + "/employer/dashboard?error=forbidden");
            return;
        }

        // fetch seeker info
        User seeker = userDAO.getById(app.getSeekerId());
        
        req.setAttribute("application", app);
        req.setAttribute("job", job);
        req.setAttribute("seeker", seeker);

        req.getRequestDispatcher("/views/employer/view_application.jsp").forward(req, resp);
    }
}
