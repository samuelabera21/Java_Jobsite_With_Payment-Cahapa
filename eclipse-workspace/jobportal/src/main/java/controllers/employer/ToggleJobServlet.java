package controllers.employer;

import dao.JobDAO;
import dao.JobDAOImpl;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/employer/toggleJob")
public class ToggleJobServlet extends HttpServlet {

    private JobDAO jobDAO = new JobDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        boolean active = req.getParameter("active").equals("1");

        jobDAO.toggleActive(id, active);

        resp.sendRedirect(req.getContextPath() + "/employer/dashboard");
    }
}
