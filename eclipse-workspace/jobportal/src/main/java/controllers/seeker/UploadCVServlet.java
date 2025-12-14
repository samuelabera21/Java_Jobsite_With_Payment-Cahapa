//package controllers.seeker;
//
//import dao.SeekerCVDAO;
//import dao.SeekerCVDAOImpl;
//import models.SeekerCV;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.MultipartConfig;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.*;
//
//@WebServlet("/uploadCV")
//@MultipartConfig
//public class UploadCVServlet extends HttpServlet {
//
//    private SeekerCVDAO cvDAO = new SeekerCVDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp?error=login_required");
//            return;
//        }
//
//        int seekerId = (Integer) session.getAttribute("userId");
//
//        // Get CV File (PDF)
//        Part filePart = request.getPart("cv_file");
//        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
//
//        // Upload directory inside your project
//        String uploadDir = request.getServletContext().getRealPath("/uploads/cv/");
//        File uploadFolder = new File(uploadDir);
//        if (!uploadFolder.exists()) uploadFolder.mkdirs();
//
//        // Save file physically
//        filePart.write(uploadDir + File.separator + fileName);
//
//        // Optional CV Text
//        String cvText = request.getParameter("cv_text");
//
//        // Check if seeker already has a CV → UPDATE instead of CREATE
//        SeekerCV existing = cvDAO.getBySeeker(seekerId);
//
//        SeekerCV cv = new SeekerCV();
//        cv.setSeekerId(seekerId);
//        cv.setCvText(cvText != null ? cvText.trim() : "");
//        cv.setCvFile("uploads/cv/" + fileName);  // saved relative path
//
//        boolean success;
//        if (existing == null) {
//            success = cvDAO.create(cv);
//        } else {
//            success = cvDAO.update(cv);
//        }
//
//        if (success) {
//            response.sendRedirect(request.getContextPath() + "/seeker/dashboard?msg=cv_uploaded");
//        } else {
//            response.sendRedirect(request.getContextPath() + "/views/seeker/uploadCV.jsp?error=1");
//        }
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        request.getRequestDispatcher("/views/seeker/uploadCV.jsp").forward(request, response);
//    }
//}
