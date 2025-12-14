package controllers.employer;

import dao.JobDAO;
import dao.JobDAOImpl;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/employer/deleteJob")
public class DeleteJobServlet extends HttpServlet {

    private JobDAO jobDAO = new JobDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        jobDAO.delete(id);

        resp.sendRedirect(req.getContextPath() + "/employer/dashboard");
    }
}
