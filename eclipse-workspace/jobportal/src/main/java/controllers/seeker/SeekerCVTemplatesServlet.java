package controllers.seeker;

import dao.CVTemplateDAO;
import dao.CVTemplateDAOImpl;
import models.CVTemplate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/seeker/cvTemplates")
public class SeekerCVTemplatesServlet extends HttpServlet {

    private CVTemplateDAO templateDAO = new CVTemplateDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<CVTemplate> templates = templateDAO.getAll();
        request.setAttribute("templates", templates);

        request.getRequestDispatcher("/views/seeker/cv_templates.jsp")
                .forward(request, response);
    }
}
