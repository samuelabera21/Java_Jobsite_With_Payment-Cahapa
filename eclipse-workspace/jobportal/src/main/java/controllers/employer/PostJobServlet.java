//package controllers.employer;
//
//import dao.JobDAO;
//import dao.JobDAOImpl;
//import models.Job;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/employer/postJob")
//public class PostJobServlet extends HttpServlet {
//
//    private JobDAO jobDAO = new JobDAOImpl();
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        request.getRequestDispatcher("/views/employer/postJob.jsp")
//               .forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        Integer employerId = (Integer) session.getAttribute("userId");
//
//        if (employerId == null) {
//            response.sendRedirect("../login.jsp");
//            return;
//        }
//
//        Job job = new Job();
//        job.setEmployerId(employerId);
//        job.setTitle(request.getParameter("title"));
//        job.setDescription(request.getParameter("description"));
//        job.setLocation(request.getParameter("location"));
//        job.setCategory(request.getParameter("category"));
//        job.setType(request.getParameter("employment_type"));  // MATCH DB COLUMN
//        job.setSalary(request.getParameter("salary"));
//        job.setEmailToApply(request.getParameter("email_to_apply"));
//        job.setActive(true);
//
//        boolean created = jobDAO.create(job);
//
//        if (created)
//            response.sendRedirect(request.getContextPath() + "/employer/dashboard?posted=success");
//        else
//            response.sendRedirect(request.getContextPath() + "/employer/postJob?error=1");
//    }
//}









//
//
//
//
//
//
//
//package controllers.employer;
//
//import dao.JobDAO;
//import dao.JobDAOImpl;
//import dao.UserDAO;
//import dao.UserDAOImpl;
//import models.Job;
//import models.User;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/employer/postJob")
//public class PostJobServlet extends HttpServlet {
//
//    private JobDAO jobDAO = new JobDAOImpl();
//    private UserDAO userDAO = new UserDAOImpl();   // ADD USER DAO
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        Integer userId = (Integer) session.getAttribute("userId");
//
//        if (userId == null) {
//            response.sendRedirect("../login.jsp");
//            return;
//        }
//
//        // CHECK EMPLOYER APPROVAL
//        User user = userDAO.findById(userId);
//        if (!"approved".equalsIgnoreCase(user.getStatus())) {
//            response.sendRedirect(request.getContextPath() + "/error_not_approved.jsp");
//            return;
//        }
//
//        request.getRequestDispatcher("/views/employer/postJob.jsp")
//               .forward(request, response);
//    }
//
//    
//    
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        Integer employerId = (Integer) session.getAttribute("userId");
//
//        if (employerId == null) {
//            response.sendRedirect("../login.jsp");
//            return;
//        }
//
//        // CHECK EMPLOYER STATUS BEFORE POSTING
//        User user = new UserDAOImpl().findById(employerId);
//        if (!"approved".equalsIgnoreCase(user.getStatus())) {
//            response.sendRedirect(request.getContextPath() + "/error_not_approved.jsp");
//            return;
//        }
//
//        Job job = new Job();
//        job.setEmployerId(employerId);
//        job.setTitle(request.getParameter("title"));
//        job.setDescription(request.getParameter("description"));
//        job.setLocation(request.getParameter("location"));
//        job.setCategory(request.getParameter("category"));
//        job.setType(request.getParameter("employment_type"));
//        job.setSalary(request.getParameter("salary"));
//        job.setEmailToApply(request.getParameter("email_to_apply"));
//        job.setActive(true);
//
//        boolean created = jobDAO.create(job);
//
//        if (created)
//            response.sendRedirect(request.getContextPath() + "/employer/dashboard?posted=success");
//        else
//            response.sendRedirect(request.getContextPath() + "/employer/postJob?error=1");
//    }
//}







































package controllers.employer;

import dao.JobDAO;
import dao.JobDAOImpl;
import dao.UserDAO;
import dao.UserDAOImpl;
import models.Job;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/employer/postJob")
public class PostJobServlet extends HttpServlet {

    private JobDAO jobDAO = new JobDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();   // User DAO for employer check

    // -----------------------------------------
    // GET → show post job page
    // -----------------------------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        HttpSession session = request.getSession();
//        Integer userId = (Integer) session.getAttribute("userId");
//
//        if (userId == null) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp");
//            return;
//        }
    	
    	
    	
    	
    	
    	HttpSession session = request.getSession();

    	// Use employerId instead of userId
    	Integer employerId = (Integer) session.getAttribute("employerId");
    	User employerUser = (User) session.getAttribute("employerUser");

    	if (employerId == null || employerUser == null) {
    	    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
    	    return;
    	}
    	
    	

        // CHECK EMPLOYER APPROVAL
//        User user = userDAO.findById(userId);
    	
    	User user = userDAO.findById(employerId);

        if (user == null || !"approved".equalsIgnoreCase(user.getStatus())) {
            // redirect to a friendly message page
            response.sendRedirect(request.getContextPath() + "/error_not_approved.jsp");
            return;
        }

        // allow employer to view Post Job page
        request.getRequestDispatcher("/views/employer/postJob.jsp").forward(request, response);
    }

    // -----------------------------------------
    // POST → submit job
    // -----------------------------------------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	HttpSession session = request.getSession();

    	// Use employerId instead of userId
    	Integer employerId = (Integer) session.getAttribute("employerId");
    	User employerUser = (User) session.getAttribute("employerUser");

    	if (employerId == null || employerUser == null) {
    	    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
    	    return;
    	}

        // Re-check employer approval before saving job
        User user = userDAO.findById(employerId);

        if (user == null || !"approved".equalsIgnoreCase(user.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/error_not_approved.jsp");
            return;
        }

        // Create job object
        Job job = new Job();
        job.setEmployerId(employerId);
        job.setTitle(request.getParameter("title"));
        job.setDescription(request.getParameter("description"));
        job.setLocation(request.getParameter("location"));
        job.setCategory(request.getParameter("category"));
        job.setType(request.getParameter("employment_type"));  // employment type field
        job.setSalary(request.getParameter("salary"));
        job.setEmailToApply(request.getParameter("email_to_apply"));
        job.setActive(true);

        boolean created = jobDAO.create(job);

        if (created) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard?posted=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/employer/postJob?error=1");
        }
    }
}
