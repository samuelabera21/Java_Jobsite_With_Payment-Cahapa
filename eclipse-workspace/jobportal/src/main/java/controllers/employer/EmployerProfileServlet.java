//package controllers.employer;
//
//import dao.EmployerProfileDAO;
//
//import models.User;
//
//import dao.EmployerProfileDAOImpl;
//import models.EmployerProfile;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/employer/profile")
//public class EmployerProfileServlet extends HttpServlet {
//
//    private EmployerProfileDAO profileDAO = new EmployerProfileDAOImpl();
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
////        HttpSession session = request.getSession();
////        Integer employerId = (Integer) session.getAttribute("userId");
////
////        if (employerId == null) {
////            response.sendRedirect("../auth/login.jsp");
////            return;
////        }
//
//    	
//    	
//    	
//    	HttpSession session = request.getSession();
//
//    	// Use employerId instead of userId
//    	Integer employerId = (Integer) session.getAttribute("employerId");
//    	User employerUser = (User) session.getAttribute("employerUser");
//
//    	if (employerId == null || employerUser == null) {
//    	    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
//    	    return;
//    	}
//    	
//    	
//    	
//        EmployerProfile profile = profileDAO.getByEmployerId(employerId);
//
//        request.setAttribute("profile", profile);
//        request.getRequestDispatcher("/views/employer/profile.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
////
////        HttpSession session = request.getSession();
////        Integer employerId = (Integer) session.getAttribute("userId");
////
////        if (employerId == null) {
////            response.sendRedirect("../auth/login.jsp");
////            return;
////        }
//    	
//    	
//    	
//    	
//    	HttpSession session = request.getSession();
//
//    	// Use employerId instead of userId
//    	Integer employerId = (Integer) session.getAttribute("employerId");
//    	User employerUser = (User) session.getAttribute("employerUser");
//
//    	if (employerId == null || employerUser == null) {
//    	    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
//    	    return;
//    	}
//    	
//    	
//    	
//
//        EmployerProfile profile = new EmployerProfile();
//        profile.setUserId(employerId);
//        profile.setCompanyName(request.getParameter("companyName"));
//        profile.setWebsite(request.getParameter("website"));
//        profile.setBio(request.getParameter("bio"));
//        profile.setAddress(request.getParameter("address"));
//
//        // check if profile exists
//        EmployerProfile existing = profileDAO.getByEmployerId(employerId);
//
//        if (existing == null) {
//            profileDAO.createProfile(profile);
//        } else {
//            profileDAO.updateProfile(profile);
//        }
//
////        response.sendRedirect("profile?success=1");
//        response.sendRedirect(request.getContextPath() + "/employer/profile?success=1");
//    }
//}






















package controllers.employer;

import dao.EmployerProfileDAO;
import models.User;
import dao.EmployerProfileDAOImpl;
import models.EmployerProfile;
import dao.UserDAO;
import dao.UserDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/employer/profile")
@MultipartConfig
public class EmployerProfileServlet extends HttpServlet {

    private EmployerProfileDAO profileDAO = new EmployerProfileDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Use employerId instead of userId
        Integer employerId = (Integer) session.getAttribute("employerId");
        User employerUser = (User) session.getAttribute("employerUser");

        if (employerId == null || employerUser == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        
        EmployerProfile profile = profileDAO.getByEmployerId(employerId);
        
        // Get fresh user data
        User user = userDAO.findById(employerId);

        request.setAttribute("profile", profile);
        request.setAttribute("user", user);  // Add user to request
        request.getRequestDispatcher("/views/employer/profile.jsp").forward(request, response);
    }

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

        EmployerProfile profile = new EmployerProfile();
        profile.setUserId(employerId);
        profile.setCompanyName(request.getParameter("companyName"));
        profile.setWebsite(request.getParameter("website"));
        profile.setBio(request.getParameter("bio"));
        profile.setAddress(request.getParameter("address"));

        // check if profile exists
        EmployerProfile existing = profileDAO.getByEmployerId(employerId);

        if (existing == null) {
            profileDAO.createProfile(profile);
        } else {
            profileDAO.updateProfile(profile);
        }

        response.sendRedirect(request.getContextPath() + "/employer/profile?success=1");
    }
}
