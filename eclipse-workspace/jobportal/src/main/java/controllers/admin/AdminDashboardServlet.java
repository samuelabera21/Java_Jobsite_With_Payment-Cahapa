package controllers.admin;

import dao.UserDAO;
import dao.UserDAOImpl;
import dao.JobDAO;
import dao.JobDAOImpl;
import dao.ApplicationDAO;
import dao.ApplicationDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();
    private JobDAO jobDAO = new JobDAOImpl();
    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Dashboard statistics
        int users = userDAO.countAll();
        int employersPending = userDAO.countPendingEmployers();
        int jobs = jobDAO.countAll();
        int applications = applicationDAO.countAll();

        request.setAttribute("users", users);
        request.setAttribute("pendingEmployers", employersPending);
        request.setAttribute("jobs", jobs);
        request.setAttribute("applications", applications);

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}
