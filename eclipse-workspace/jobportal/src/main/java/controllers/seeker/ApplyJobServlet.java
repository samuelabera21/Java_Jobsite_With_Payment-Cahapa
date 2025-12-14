//package controllers.seeker;
//
//import dao.ApplicationDAO;
//import dao.ApplicationDAOImpl;
//import models.Application;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/applyJob")
//public class ApplyJobServlet extends HttpServlet {
//
//    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Ensure user is logged in
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//            // not logged in -> redirect to login
//            response.sendRedirect(request.getContextPath() + "/login.jsp?error=login_required");
//            return;
//        }
//
//        int seekerId = (Integer) session.getAttribute("userId");
//
//        // Parse form
//        String jobIdStr = request.getParameter("job_id");
//        String coverLetter = request.getParameter("cover_letter"); // textarea name
//
//        int jobId;
//        try {
//            jobId = Integer.parseInt(jobIdStr);
//        } catch (NumberFormatException e) {
//            response.sendRedirect(request.getContextPath() + "/viewJobs.jsp?error=invalid_job");
//            return;
//        }
//
//        // Build model
//        Application app = new Application();
//        app.setJobId(jobId);
//        app.setSeekerId(seekerId);
//        app.setCoverLetter(coverLetter != null ? coverLetter.trim() : "");
//        app.setStatus("pending");
//
//        boolean ok = applicationDAO.create(app);
//
//        if (ok) {
//            // success
//            response.sendRedirect(request.getContextPath() + "/seeker/dashboard?msg=applied");
//        } else {
//            // failed
//            response.sendRedirect(request.getContextPath() + "/applyJob.jsp?job_id=" + jobId + "&error=1");
//        }
//    }
//
//    // Optional: support GET to forward to JSP (if you want servlet to serve the form)
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // If you want the servlet to forward to JSP, you can do that.
//        String jobId = request.getParameter("job_id");
//        request.getRequestDispatcher("/views/seeker/applyJob.jsp").forward(request, response);
//    }
//}




//
//
//
//
//
//
//
//package controllers.seeker;
//
//import dao.ApplicationDAO;
//import dao.ApplicationDAOImpl;
//import models.Application;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/seeker/applyJob")
//public class ApplyJobServlet extends HttpServlet {
//
//    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Ensure user is logged in
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp?error=login_required");
//            return;
//        }
//
//        int seekerId = (Integer) session.getAttribute("userId");
//
//        // Read form values
//        String jobIdStr = request.getParameter("job_id");
//        String message = request.getParameter("message");  // textarea name = message
//
//        int jobId;
//        try {
//            jobId = Integer.parseInt(jobIdStr);
//        } catch (NumberFormatException e) {
//            response.sendRedirect(request.getContextPath() + "/seeker/viewJobs?error=invalid_job");
//            return;
//        }
//
//        // Build application object
//        Application app = new Application();
//        app.setJobId(jobId);
//        app.setSeekerId(seekerId);
//        app.setMessage(message != null ? message.trim() : "");
//        app.setCvPath(null); // optional unless you later upload CV
//        app.setStatus("pending");
//
//        boolean ok = applicationDAO.create(app);
//
//        if (ok) {
//            response.sendRedirect(request.getContextPath() + "/seeker/dashboard?msg=applied");
//        } else {
//            response.sendRedirect(request.getContextPath() + "/seeker/applyJob?job_id=" + jobId + "&error=1");
//        }
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        request.getRequestDispatcher("/views/seeker/applyJob.jsp")
//                .forward(request, response);
//    }
//}
//






















package controllers.seeker;

import dao.ApplicationDAO;
import dao.ApplicationDAOImpl;
import models.Application;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/seeker/applyJob")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 20 * 1024 * 1024
)
public class ApplyJobServlet extends HttpServlet {

    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp?error=login_required");
//            return;
//        }
//
//        int seekerId = (Integer) session.getAttribute("userId");
    	
    	HttpSession session = request.getSession(false);

    	// UPDATE: Use seekerId instead of userId
    	Integer seekerId = (Integer) session.getAttribute("seekerId");
    	User seekerUser = (User) session.getAttribute("seekerUser");

    	if (session == null || seekerId == null || seekerUser == null) {
    	    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=login_required");
    	    return;
    	}

    	int seekerIdInt = seekerId; // Keep as int for compatibility

        int jobId = Integer.parseInt(request.getParameter("job_id"));
        String message = request.getParameter("message");

        // -------------------------
        // Upload CV file
        // -------------------------
        Part cvPart = request.getPart("cv");
        String cvFileName = null;

        if (cvPart != null && cvPart.getSize() > 0) {
            String original = cvPart.getSubmittedFileName();
            cvFileName = System.currentTimeMillis() + "_" + original;

            String uploadDir = request.getServletContext().getRealPath("/") + "uploads/applications";
            File folder = new File(uploadDir);
            if (!folder.exists()) folder.mkdirs();

            cvPart.write(uploadDir + File.separator + cvFileName);
        }

        // -------------------------
        // Build Application object
        // -------------------------
        Application app = new Application();
        app.setJobId(jobId);
        app.setSeekerId(seekerId);
        app.setMessage(message != null ? message.trim() : "");
        app.setStatus("pending");
        app.setCvPath(cvFileName != null ? "uploads/applications/" + cvFileName : null);

        boolean ok = applicationDAO.create(app);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/seeker/dashboard?msg=applied");
        } else {
            response.sendRedirect(request.getContextPath() + "/seeker/applyJob?job_id=" + jobId + "&error=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/seeker/applyJob.jsp")
                .forward(request, response);
    }
}
