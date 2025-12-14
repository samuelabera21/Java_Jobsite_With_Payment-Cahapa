package controllers.admin;

import dao.CVTemplateDAO;
import dao.CVTemplateDAOImpl;
import models.CVTemplate;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/admin/addCVTemplate")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 10 * 1024 * 1024,  // 10MB
    maxRequestSize = 20 * 1024 * 1024 // 20MB
)
public class AddCVTemplateServlet extends HttpServlet {

    private CVTemplateDAO templateDAO = new CVTemplateDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // show form
        request.getRequestDispatcher("/views/admin/add_cv_template.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Part filePart = request.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect(request.getContextPath() + "/admin/cvTemplates?error=nofile");
            return;
        }

        String originalFileName = new File(filePart.getSubmittedFileName()).getName();
        String filename = System.currentTimeMillis() + "_" + originalFileName;

        // relative path stored in DB
        String relativeFolder = "uploads/cv_templates";
        String relativePath = relativeFolder + "/" + filename;

        // physical path on server
        String uploadDirPath = request.getServletContext().getRealPath("/") + relativeFolder;
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // write file
        filePart.write(uploadDirPath + File.separator + filename);

        // create DB entry
        CVTemplate t = new CVTemplate();
        t.setName(name);
        t.setDescription(description);
        t.setFilePath(relativePath);

        boolean ok = templateDAO.create(t);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/admin/cvTemplates?added=1");
        } else {
            // if DB failed, try delete the uploaded file to avoid orphan files
            File saved = new File(uploadDirPath + File.separator + filename);
            if (saved.exists()) saved.delete();
            response.sendRedirect(request.getContextPath() + "/admin/cvTemplates?error=db");
        }
    }
}
