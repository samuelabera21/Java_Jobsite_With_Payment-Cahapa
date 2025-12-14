package controllers.admin;

import dao.ApplicationDAO;
import dao.ApplicationDAOImpl;
import models.Application;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/viewApplications")
public class ViewApplicationsServlet extends HttpServlet {

    private ApplicationDAO appDAO = new ApplicationDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Application> apps = appDAO.getAll();
        request.setAttribute("apps", apps);

        request.getRequestDispatcher("/views/admin/view_applications.jsp").forward(request, response);
    }
}
