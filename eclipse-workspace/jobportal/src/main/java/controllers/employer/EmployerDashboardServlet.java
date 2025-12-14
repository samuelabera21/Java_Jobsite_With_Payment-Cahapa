//package controllers.employer;
//
//import dao.JobDAO;
//import dao.JobDAOImpl;
//import dao.ApplicationDAO;
//import dao.ApplicationDAOImpl;
//
//import models.Job;
//import models.Application;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet("/employer/dashboard")
//public class EmployerDashboardServlet extends HttpServlet {
//
//    private JobDAO jobDAO = new JobDAOImpl();
//    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
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
//        // Jobs created by this employer
//        List<Job> jobs = jobDAO.getByEmployer(userId);
//
//        // Applications for employer jobs
//        List<Application> applications = applicationDAO.getByEmployer(userId);
//
//        request.setAttribute("jobs", jobs);
//        request.setAttribute("applications", applications);
//
//        request.getRequestDispatcher("/views/employer/dashboard.jsp").forward(request, response);
//    }
//}
//
//


























//
//package controllers.employer;
//
//import dao.JobDAO;
//import dao.JobDAOImpl;
//import dao.ApplicationDAO;
//import dao.ApplicationDAOImpl;
//import dao.UserDAO;
//import dao.UserDAOImpl;
//
//import models.Job;
//import models.Application;
//import models.User;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet("/employer/dashboard")
//public class EmployerDashboardServlet extends HttpServlet {
//
//    private JobDAO jobDAO = new JobDAOImpl();
//    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
//    private UserDAO userDAO = new UserDAOImpl();
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
//        // CHECK IF EMPLOYER IS APPROVED
//        User user = userDAO.findById(userId);
//        if (!"approved".equalsIgnoreCase(user.getStatus())) {
//            response.sendRedirect(request.getContextPath() + "/error_not_approved.jsp");
//            return;
//        }
//
//        List<Job> jobs = jobDAO.getByEmployer(userId);
//        List<Application> applications = applicationDAO.getByEmployer(userId);
//
//        request.setAttribute("jobs", jobs);
//        request.setAttribute("applications", applications);
//
//        request.getRequestDispatcher("/views/employer/dashboard.jsp").forward(request, response);
//    }
//}
//


//----------above is original----------------
//
//package controllers.employer;
//
//import dao.JobDAO;
//import dao.JobDAOImpl;
//import dao.ApplicationDAO;
//import dao.ApplicationDAOImpl;
//import dao.UserDAO;
//import dao.UserDAOImpl;
//
//import models.Job;
//import models.Application;
//import models.User;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet("/employer/dashboard")
//public class EmployerDashboardServlet extends HttpServlet {
//
//    private JobDAO jobDAO = new JobDAOImpl();
//    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
//    private UserDAO userDAO = new UserDAOImpl();
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
////        Integer userId = (Integer) session.getAttribute("userId");
//        Integer userId = (Integer) session.getAttribute("employerId");
//
//        if (userId == null) {
////            response.sendRedirect("../login.jsp");
//        	   response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
//            return;
//        }
//
//        // ========== FIXED: Get and verify employer user ==========
//        User user = (User) session.getAttribute("employerUser");
//        
//        // If not in session, fetch from database
//        if (user == null) {
//            user = userDAO.findById(userId);
//            
//            if (user != null) {
//                // Verify this is actually an employer
//                if ("employer".equalsIgnoreCase(user.getRole())) {
//                    session.setAttribute("employerUser", user);
//                    System.out.println("EmployerDashboard: Fetched and stored employer user: " + user.getName());
//                } else {
//                    // Wrong role - this shouldn't happen
//                    System.out.println("ERROR: User " + user.getName() + " is not an employer! Role: " + user.getRole());
//                    session.invalidate();
////                    response.sendRedirect("../login.jsp");
////                    response.sendRedirect(request.getContextPath() + "/login.jsp");
//                    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
//                    return;
//                }
//            }
//        }
//        
//        // CHECK IF EMPLOYER IS APPROVED
//        if (user != null && !"approved".equalsIgnoreCase(user.getStatus())) {
//            response.sendRedirect(request.getContextPath() + "/error_not_approved.jsp");
//            return;
//        }
//        
//        // Pass user to JSP
//        request.setAttribute("user", user);
//        // ========== END FIX ==========
//
//        List<Job> jobs = jobDAO.getByEmployer(userId);
//        List<Application> applications = applicationDAO.getByEmployer(userId);
//
//        request.setAttribute("jobs", jobs);
//        request.setAttribute("applications", applications);
//
//        request.getRequestDispatcher("/views/employer/dashboard.jsp").forward(request, response);
//    }
//}



//here below is for editing--------



package controllers.employer;

import dao.JobDAO;
import dao.JobDAOImpl;
import dao.ApplicationDAO;
import dao.ApplicationDAOImpl;
import dao.UserDAO;
import dao.UserDAOImpl;
import dao.EmployerProfileDAO;
import dao.EmployerProfileDAOImpl;

import models.Job;
import models.Application;
import models.User;
import models.EmployerProfile;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/employer/dashboard")
public class EmployerDashboardServlet extends HttpServlet {

    private JobDAO jobDAO = new JobDAOImpl();
    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();
    private EmployerProfileDAO employerProfileDAO = new EmployerProfileDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("employerId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        // ========== FIXED: Get and verify employer user ==========
        User user = (User) session.getAttribute("employerUser");
        
        // If not in session, fetch from database
        if (user == null) {
            user = userDAO.findById(userId);
            
            if (user != null) {
                // Verify this is actually an employer
                if ("employer".equalsIgnoreCase(user.getRole())) {
                    session.setAttribute("employerUser", user);
                    System.out.println("EmployerDashboard: Fetched and stored employer user: " + user.getName());
                } else {
                    // Wrong role - this shouldn't happen
                    System.out.println("ERROR: User " + user.getName() + " is not an employer! Role: " + user.getRole());
                    session.invalidate();
                    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
                    return;
                }
            }
        }
        
        // CHECK IF EMPLOYER IS APPROVED
        if (user != null && !"approved".equalsIgnoreCase(user.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/error_not_approved.jsp");
            return;
        }
        
        // Get employer profile
        EmployerProfile profile = null;
        if (userId != null) {
            try {
                profile = employerProfileDAO.getByEmployerId(userId);
                
                // If no profile exists, create a default one
                if (profile == null && user != null) {
                    profile = new EmployerProfile();
                    profile.setUserId(userId);
                    profile.setCompanyName(user.getName() + "'s Company"); // Default company name
                    employerProfileDAO.createProfile(profile);
                    System.out.println("Created default profile for employer: " + userId);
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("Error fetching employer profile: " + e.getMessage());
            }
        }
        
        // Pass both user and profile to JSP
        request.setAttribute("user", user);
        request.setAttribute("profile", profile);
        // ========== END FIX ==========

        List<Job> jobs = jobDAO.getByEmployer(userId);
        List<Application> applications = applicationDAO.getByEmployer(userId);

        request.setAttribute("jobs", jobs);
        request.setAttribute("applications", applications);

        request.getRequestDispatcher("/views/employer/dashboard.jsp").forward(request, response);
    }
}





















//package controllers.employer;
//
//import dao.JobDAO;
//import dao.JobDAOImpl;
//import dao.ApplicationDAO;
//import dao.ApplicationDAOImpl;
//
//import models.Job;
//import models.Application;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet("/employer/dashboard")
//public class EmployerDashboardServlet extends HttpServlet {
//
//    private JobDAO jobDAO = new JobDAOImpl();
//    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
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
//        // Jobs created by this employer
//        List<Job> jobs = jobDAO.getByEmployer(userId);
//
//        // Applications for employer jobs
//        List<Application> applications = applicationDAO.getByEmployer(userId);
//
//        request.setAttribute("jobs", jobs);
//        request.setAttribute("applications", applications);
//
//        request.getRequestDispatcher("/views/employer/dashboard.jsp").forward(request, response);
//    }
//}
