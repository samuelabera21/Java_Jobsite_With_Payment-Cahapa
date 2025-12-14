package controllers.employer;

import dao.JobDAO;
import dao.JobDAOImpl;
import models.Job;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/employer/updateJob")
public class UpdateJobServlet extends HttpServlet {

    private JobDAO jobDAO = new JobDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        Job job = new Job();

        job.setId(Integer.parseInt(req.getParameter("id")));
        job.setTitle(req.getParameter("title"));
        job.setLocation(req.getParameter("location"));
        job.setCategory(req.getParameter("category"));
        job.setSalary(req.getParameter("salary"));
        job.setDescription(req.getParameter("description"));
        job.setEmailToApply(req.getParameter("email"));
        job.setType(req.getParameter("type"));

        jobDAO.update(job);

        resp.sendRedirect(req.getContextPath() + "/employer/dashboard");
    }
}
