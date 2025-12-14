//package controllers.seeker;
//
//import dao.ApplicationDAO;
//import dao.ApplicationDAOImpl;
//import dao.JobDAO;
//import dao.JobDAOImpl;
//import models.Application;
//import models.Job;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet("/seeker/dashboard")
//public class SeekerDashboardServlet extends HttpServlet {
//
//    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
//    private JobDAO jobDAO = new JobDAOImpl();
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
//        // load data
//        List<Application> appliedJobs = applicationDAO.getBySeeker(userId);
//        List<Job> recommendedJobs = jobDAO.getAll(); // later: filter
//
//        request.setAttribute("appliedJobs", appliedJobs);
//        request.setAttribute("recommendedJobs", recommendedJobs);
//
//        request.getRequestDispatcher("/views/seeker/dashboard.jsp").forward(request, response);
//    }
//}
//
//
//
//above is original


package controllers.seeker;

import dao.ApplicationDAO;
import dao.ApplicationDAOImpl;
import dao.JobDAO;
import dao.JobDAOImpl;
import dao.UserDAO;
import dao.UserDAOImpl;
import models.Application;
import models.Job;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/seeker/dashboard")
public class SeekerDashboardServlet extends HttpServlet {

    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
    private JobDAO jobDAO = new JobDAOImpl();
    private UserDAO userDAO = new UserDAOImpl(); // ADDED

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
//        Integer userId = (Integer) session.getAttribute("userId");
        Integer userId = (Integer) session.getAttribute("seekerId");

        if (userId == null) {
//            response.sendRedirect("../login.jsp");
            response.sendRedirect(request.getContextPath() + "/views/seeker/login.jsp");
            return;
        }

        // ========== FIXED: Get and verify seeker user ==========
        User user = (User) session.getAttribute("seekerUser");
        
        // If not in session, fetch from database
        if (user == null) {
            user = userDAO.getById(userId);
            
            if (user != null) {
                // Verify this is actually a seeker
                if ("seeker".equalsIgnoreCase(user.getRole())) {
                    session.setAttribute("seekerUser", user);
                    System.out.println("SeekerDashboard: Fetched and stored seeker user: " + user.getName());
                } else {
                    // Wrong role - this shouldn't happen
                    System.out.println("ERROR: User " + user.getName() + " is not a seeker! Role: " + user.getRole());
                    session.invalidate();
//                    response.sendRedirect("../login.jsp");
//                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
                    return;
                }
            }
        }
        
        // Pass user to JSP
        request.setAttribute("user", user);
        // ========== END FIX ==========

        // load data (existing functionality)
        List<Application> appliedJobs = applicationDAO.getBySeeker(userId);
        List<Job> recommendedJobs = jobDAO.getAll(); // later: filter

        request.setAttribute("appliedJobs", appliedJobs);
        request.setAttribute("recommendedJobs", recommendedJobs);

        request.getRequestDispatcher("/views/seeker/dashboard.jsp").forward(request, response);
    }
}











































//
//package controllers.seeker;
//
//import dao.ApplicationDAO;
//import dao.ApplicationDAOImpl;
//import dao.JobDAO;
//import dao.JobDAOImpl;
//import models.Application;
//import models.Job;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet("/seeker/dashboard")
//public class SeekerDashboardServlet extends HttpServlet {
//
//    private ApplicationDAO applicationDAO = new ApplicationDAOImpl();
//    private JobDAO jobDAO = new JobDAOImpl();
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
//        // load data
//        List<Application> appliedJobs = applicationDAO.getBySeeker(userId);
//        List<Job> recommendedJobs = jobDAO.getAll(); // later: filter
//
//        request.setAttribute("appliedJobs", appliedJobs);
//        request.setAttribute("recommendedJobs", recommendedJobs);
//
//        request.getRequestDispatcher("/views/seeker/dashboard.jsp").forward(request, response);
//    }
//}
