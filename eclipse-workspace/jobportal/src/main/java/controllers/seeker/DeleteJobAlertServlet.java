package controllers.seeker;

import dao.JobAlertDAO;
import dao.JobAlertDAOImpl;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/seeker/deleteAlert")
public class DeleteJobAlertServlet extends HttpServlet {

    private JobAlertDAO alertDAO = new JobAlertDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        alertDAO.delete(id);

        response.sendRedirect(request.getContextPath() + "/seeker/jobAlerts");
    }
}
