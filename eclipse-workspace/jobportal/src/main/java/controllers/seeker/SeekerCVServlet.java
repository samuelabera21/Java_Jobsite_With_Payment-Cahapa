package controllers.seeker;

import dao.SeekerCVDAO;

import models.User;


import dao.SeekerCVDAOImpl;
import models.SeekerCV;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/seeker/cvbuilder")
@MultipartConfig
public class SeekerCVServlet extends HttpServlet {

    private SeekerCVDAO cvDAO = new SeekerCVDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ensure logged in
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=login_required");
//            return;
//        }
//
//        int userId = (Integer) session.getAttribute("userId");
    	
    	
    	
    	
    	HttpSession session = request.getSession(false);

    	// Use seekerId instead of userId
    	Integer seekerId = (Integer) session.getAttribute("seekerId");
    	User seekerUser = (User) session.getAttribute("seekerUser");

    	if (session == null || seekerId == null || seekerUser == null) {
    	    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=login_required");
    	    return;
    	}

    	int userId = seekerId; // Use seekerId
    	
    	
        SeekerCV existing = cvDAO.getByUserId(userId);
        request.setAttribute("cv", existing);
        request.getRequestDispatcher("/views/seeker/cvBuilder.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=login_required");
//            return;
//        }
//
//        int userId = (Integer) session.getAttribute("userId");
    	
    	
    	
    	HttpSession session = request.getSession(false);

    	// Use seekerId instead of userId
    	Integer seekerId = (Integer) session.getAttribute("seekerId");
    	User seekerUser = (User) session.getAttribute("seekerUser");

    	if (session == null || seekerId == null || seekerUser == null) {
    	    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=login_required");
    	    return;
    	}

    	int userId = seekerId; // Use seekerId

        // read simple form fields
        String headline = safe(request.getParameter("headline"));
        String about = safe(request.getParameter("about"));

        // education and experience: user can enter multiple lines; we'll convert to JSON array
        String educationRaw = safe(request.getParameter("education"));
        String experienceRaw = safe(request.getParameter("experience"));

        String skillsRaw = safe(request.getParameter("skills")); // comma-separated

        // handle attachments (multiple)
        List<String> savedPaths = new ArrayList<>();
        // Servlet 3.0: getParts
        for (Part part : request.getParts()) {
            if (part == null) continue;
            String fieldName = part.getName();
            if (!"attachments".equals(fieldName)) continue;
            String filename = getFileName(part);
            if (filename == null || filename.isEmpty()) continue;

            String uploadDir = request.getServletContext().getRealPath("/uploads/cv/");
            File uploadFolder = new File(uploadDir);
            if (!uploadFolder.exists()) uploadFolder.mkdirs();

            String savedName = System.currentTimeMillis() + "_" + filename;
            part.write(uploadDir + File.separator + savedName);

            // store relative path
            savedPaths.add("uploads/cv/" + savedName);
        }

        // build JSON strings (simple, no external libs)
        String educationJson = linesToJsonArray(educationRaw);
        String experienceJson = linesToJsonArray(experienceRaw);
        String skillsJson = commaToJsonArray(skillsRaw);
        String attachmentsJson = listToJsonArray(savedPaths);

     // build model
        SeekerCV cv = new SeekerCV();
        cv.setUserId(userId);
        cv.setHeadline(headline);
        cv.setAbout(about);
        cv.setEducation(educationJson);
        cv.setExperience(experienceJson);
        cv.setSkills(skillsJson);
        cv.setAttachments(attachmentsJson);


        SeekerCV existing = cvDAO.getByUserId(userId);
        boolean ok;
        if (existing == null) {
            ok = cvDAO.create(cv);
        } else {
            ok = cvDAO.update(cv);
        }

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/seeker/cvbuilder?msg=saved");
        } else {
            response.sendRedirect(request.getContextPath() + "/seeker/cvbuilder?error=1");
        }
    }

    // helpers
    private static String safe(String s) {
        return s == null ? "" : s.trim();
    }

    private static String getFileName(Part part) {
        String cd = part.getHeader("content-disposition");
        if (cd == null) return null;
        for (String token : cd.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                // some browsers include full path, strip it
                return name.substring(name.lastIndexOf(File.separator) + 1);
            }
        }
        return null;
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    private static String listToJsonArray(List<String> list) {
        if (list == null || list.isEmpty()) return "[]";
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        boolean first = true;
        for (String v : list) {
            if (!first) sb.append(",");
            sb.append("\"").append(escapeJson(v)).append("\"");
            first = false;
        }
        sb.append("]");
        return sb.toString();
    }

    private static String linesToJsonArray(String raw) {
        if (raw == null || raw.trim().isEmpty()) return "[]";
        String[] lines = raw.split("\\r?\\n");
        List<String> items = new ArrayList<>();
        for (String ln : lines) {
            if (!ln.trim().isEmpty()) items.add(ln.trim());
        }
        return listToJsonArray(items);
    }

    private static String commaToJsonArray(String raw) {
        if (raw == null || raw.trim().isEmpty()) return "[]";
        String[] parts = raw.split(",");
        List<String> items = new ArrayList<>();
        for (String p : parts) {
            if (!p.trim().isEmpty()) items.add(p.trim());
        }
        return listToJsonArray(items);
    }
}
