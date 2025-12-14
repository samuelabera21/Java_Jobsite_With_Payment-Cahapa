package controllers.admin;

import dao.CVTemplateDAO;
import dao.CVTemplateDAOImpl;
import models.CVTemplate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/admin/deleteCVTemplate")
public class DeleteCVTemplateServlet extends HttpServlet {

    private CVTemplateDAO templateDAO = new CVTemplateDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/cvTemplates?error=missing");
            return;
        }

        int id = Integer.parseInt(idStr);
        CVTemplate t = templateDAO.getById(id);
        if (t != null) {
            // delete file from disk
            String fileRelative = t.getFilePath(); // e.g. uploads/cv_templates/160000_file.pdf
            if (fileRelative != null && !fileRelative.trim().isEmpty()) {
                String fullPath = request.getServletContext().getRealPath("/") + fileRelative;
                File f = new File(fullPath);
                if (f.exists()) f.delete();
            }
        }

        templateDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/cvTemplates?deleted=1");
    }
}
