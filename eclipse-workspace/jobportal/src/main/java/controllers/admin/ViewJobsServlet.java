package controllers.admin;

import dao.JobDAO;
import dao.JobDAOImpl;
import models.Job;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/viewJobs")
public class ViewJobsServlet extends HttpServlet {

    private JobDAO jobDAO = new JobDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Job> jobs = jobDAO.getAll();
        request.setAttribute("jobs", jobs);

        request.getRequestDispatcher("/views/admin/view_jobs.jsp").forward(request, response);
    }
}
