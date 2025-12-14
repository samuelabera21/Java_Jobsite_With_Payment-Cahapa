//package controllers.auth;
//
//import dao.UserDAO;
//import dao.UserDAOImpl;
//import models.User;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/login")
//public class LoginServlet extends HttpServlet {
//
//    private UserDAO userDAO = new UserDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String email = request.getParameter("email");
//        String password = request.getParameter("password");
//
//        User user = userDAO.login(email, password);
//
//        if (user == null) {
//            response.sendRedirect("login.jsp?error=invalid");
//            return;
//        }
//
//        // Store user in session
//        HttpSession session = request.getSession();
//        session.setAttribute("userId", user.getId());
//        session.setAttribute("userRole", user.getRole());
//        session.setAttribute("userName", user.getName());
//
//        // Redirect by role
//        switch (user.getRole()) {
//            case "admin":
//                response.sendRedirect("admin/dashboard");
//                break;
//            case "employer":
//                response.sendRedirect("employer/dashboard");
//                break;
//            default:
//                response.sendRedirect("seeker/dashboard");
//        }
//    }
//}




//
//package controllers.auth;
//
//import dao.UserDAO;
//import dao.UserDAOImpl;
//import models.User;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/login")
//public class LoginServlet extends HttpServlet {
//
//    private UserDAO userDAO = new UserDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String email = request.getParameter("email");
//        String password = request.getParameter("password");
//
//        // FIXED: use correct DAO method
//        User user = userDAO.getByEmailAndPassword(email, password);
//
//        if (user == null) {
//            response.sendRedirect("login.jsp?error=invalid");
//            return;
//        }
//
//        HttpSession session = request.getSession();
//        session.setAttribute("userId", user.getId());
//        session.setAttribute("userRole", user.getRole());
//        session.setAttribute("userName", user.getName());
//
//        switch (user.getRole()) {
//            case "admin":
//                response.sendRedirect("admin/dashboard");
//                break;
//            case "employer":
//                response.sendRedirect("employer/dashboard");
//                break;
//            default:
//                response.sendRedirect("seeker/dashboard");
//        }
//    }
//}









//
//
//
//
//
//package controllers.auth;
//
//import dao.UserDAO;
//import dao.UserDAOImpl;
//import models.User;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/login")
//public class LoginServlet extends HttpServlet {
//
//    private UserDAO userDAO = new UserDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String email = request.getParameter("email");
//        String password = request.getParameter("password");
//
//        // FIX: use correct method
//        User user = userDAO.login(email, password);
//
//        if (user == null) {
//            response.sendRedirect("login.jsp?error=invalid");
//            return;
//        }
//
//        // create session
//        HttpSession session = request.getSession();
//        session.setAttribute("userId", user.getId());
//        session.setAttribute("userRole", user.getRole());
//        session.setAttribute("userName", user.getName());
//
//        // redirect by role
//        switch (user.getRole()) {
//            case "admin":
//                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
//                break;
//            case "employer":
//                response.sendRedirect(request.getContextPath() + "/employer/dashboard");
//                break;
//            default:
//                response.sendRedirect(request.getContextPath() + "/seeker/dashboard");
//        }
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.sendRedirect("login.jsp");
//    }
//}




















//
//
//package controllers.auth;
//
//import dao.UserDAO;
//import dao.UserDAOImpl;
//import models.User;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/login")
//public class LoginServlet extends HttpServlet {
//
//    private UserDAO userDAO = new UserDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String email = request.getParameter("email");
//        String password = request.getParameter("password");
//
//        // Get user
//        User user = userDAO.login(email, password);
//
//        if (user == null) {
//            response.sendRedirect("login.jsp  ?error=invalid");
//            return;
//        }
//
//        // 🚫 BLOCK SUSPENDED USERS
//        if ("suspended".equalsIgnoreCase(user.getStatus())) {
//            response.sendRedirect("login.jsp?error=suspended");
//            return;
//        }
//
//        // 🚫 BLOCK PENDING EMPLOYERS UNTIL ADMIN APPROVES
//        if ("employer".equals(user.getRole()) && "pending".equalsIgnoreCase(user.getStatus())) {
//            response.sendRedirect("login.jsp?error=pending");
//            return;
//        }
//
//        // Create session
//        HttpSession session = request.getSession();
//        session.setAttribute("userId", user.getId());
//        session.setAttribute("userRole", user.getRole());
//        session.setAttribute("userName", user.getName());
//
//        // Redirect by role
//        switch (user.getRole()) {
//            case "admin":
//                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
//                break;
//
//            case "employer":
//                response.sendRedirect(request.getContextPath() + "/employer/dashboard");
//                break;
//
//            default:  // seeker
//                response.sendRedirect(request.getContextPath() + "/seeker/dashboard");
//                break;
//        }
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.sendRedirect("login.jsp");
//    }
//}














//here below is  mine and above is old 

//
//package controllers.auth;
//
//import dao.UserDAO;
//import dao.UserDAOImpl;
//import models.User;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/login")
//public class LoginServlet extends HttpServlet {
//
//    private UserDAO userDAO = new UserDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String email = request.getParameter("email");
//        String password = request.getParameter("password");
//
//        // DEBUG: Print login attempt
//        System.out.println("=== LOGIN ATTEMPT ===");
//        System.out.println("Email: " + email);
//        System.out.println("Password provided: " + password);
//
//        // Get user
//        User user = userDAO.login(email, password);
//
//        // DEBUG: Print user details
//        if (user != null) {
//            System.out.println("Login SUCCESSFUL:");
//            System.out.println("  User ID: " + user.getId());
//            System.out.println("  User Name: " + user.getName());
//            System.out.println("  User Role: " + user.getRole());
//            System.out.println("  User Email: " + user.getEmail());
//            System.out.println("  User Status: " + user.getStatus());
//        } else {
//            System.out.println("Login FAILED - user is null (wrong credentials)");
//            response.sendRedirect("login.jsp?error=invalid");
//            return; // IMPORTANT: Stop here!
//        }
//
//        // Check if user is active/approved
//        if ("suspended".equalsIgnoreCase(user.getStatus())) {
//            System.out.println("User is suspended: " + user.getEmail());
//            response.sendRedirect("login.jsp?error=suspended");
//            return;
//        }
//
//        if ("employer".equalsIgnoreCase(user.getRole()) && 
//            !"approved".equalsIgnoreCase(user.getStatus())) {
//            System.out.println("Employer not approved: " + user.getEmail());
//            response.sendRedirect("login.jsp?error=pending");
//            return;
//        }
//
//        // Store user in session
//        HttpSession session = request.getSession();
//        session.setAttribute("userId", user.getId());
//        session.setAttribute("user", user);
//        
//        System.out.println("Session created with userId: " + user.getId());
//
//        // Redirect based on role
//        if ("seeker".equalsIgnoreCase(user.getRole())) {
//            response.sendRedirect("seeker/dashboard?success=1");
//        } else if ("employer".equalsIgnoreCase(user.getRole())) {
//            response.sendRedirect("employer/dashboard?success=1");
//        } else if ("admin".equalsIgnoreCase(user.getRole())) {
//            response.sendRedirect("admin/dashboard?success=1");
//        } else {
//            response.sendRedirect("login.jsp?error=invalid_role");
//        }
//    }
//}



























package controllers.auth;

import dao.UserDAO;
import dao.UserDAOImpl;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // DEBUG: Print login attempt
        System.out.println("=== LOGIN ATTEMPT ===");
        System.out.println("Email: " + email);
        System.out.println("Password provided: " + password);

        // Get user
        User user = userDAO.login(email, password);

        // DEBUG: Print user details
        if (user != null) {
            System.out.println("Login SUCCESSFUL:");
            System.out.println("  User ID: " + user.getId());
            System.out.println("  User Name: " + user.getName());
            System.out.println("  User Role: " + user.getRole());
            System.out.println("  User Email: " + user.getEmail());
            System.out.println("  User Status: " + user.getStatus());
        } else {
            System.out.println("Login FAILED - user is null (wrong credentials)");
            // FIXED: Correct path to login.jsp
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=invalid");
            return; // IMPORTANT: Stop here!
        }

        // Check if user is active/approved
        if ("suspended".equalsIgnoreCase(user.getStatus())) {
            System.out.println("User is suspended: " + user.getEmail());
            // FIXED: Correct path to login.jsp
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=suspended");
            return;
        }

        if ("employer".equalsIgnoreCase(user.getRole()) && 
            !"approved".equalsIgnoreCase(user.getStatus())) {
            System.out.println("Employer not approved: " + user.getEmail());
            // FIXED: Correct path to login.jsp
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=pending");
            return;
        }

//        // ========== FIXED: Store user with role-specific attributes ==========
//        HttpSession session = request.getSession();
//        session.setAttribute("userId", user.getId());
//        
//        // Store with role-specific attribute names
//        if ("seeker".equalsIgnoreCase(user.getRole())) {
//            session.setAttribute("seekerUser", user);
//            session.removeAttribute("employerUser"); // Clean up
//            System.out.println("Stored as seekerUser in session");
//        } else if ("employer".equalsIgnoreCase(user.getRole())) {
//            session.setAttribute("employerUser", user);
//            session.removeAttribute("seekerUser"); // Clean up
//            System.out.println("Stored as employerUser in session");
//        }
//        
//        // Keep generic for compatibility with existing code
//        session.setAttribute("user", user);
//        // ========== END FIX ==========
        
        
        
//        
//        
//     // ========== FIXED: Store user with role-specific attributes ==========
//        HttpSession session = request.getSession();
//        session.setAttribute("userId", user.getId()); // ← REMOVE THIS LINE!
//
//        // Store with role-specific attribute names
//        if ("seeker".equalsIgnoreCase(user.getRole())) {
//            session.setAttribute("seekerUser", user);
//            session.removeAttribute("employerUser"); // Clean up
//            session.setAttribute("seekerId", user.getId()); // ← ADD THIS
//            System.out.println("Stored as seekerUser in session");
//        } else if ("employer".equalsIgnoreCase(user.getRole())) {
//            session.setAttribute("employerUser", user);
//            session.removeAttribute("seekerUser"); // Clean up
//            session.setAttribute("employerId", user.getId()); // ← ADD THIS
//            System.out.println("Stored as employerUser in session");
//        }
//
//        // Keep generic for compatibility with existing code
//        session.setAttribute("user", user); // ← You can keep or remove this
//        // ========== END FIX ==========
//        
        
        
     // ========== FIXED: Store user with role-specific attributes ==========
        HttpSession session = request.getSession();

        // KEEP THIS LINE for backward compatibility:
        session.setAttribute("userId", user.getId());

        // Store with role-specific attribute names
        if ("seeker".equalsIgnoreCase(user.getRole())) {
            session.setAttribute("seekerUser", user);
            session.removeAttribute("employerUser"); // Clean up
            session.setAttribute("seekerId", user.getId()); // ← ADD THIS
            System.out.println("Stored as seekerUser in session");
        } else if ("employer".equalsIgnoreCase(user.getRole())) {
            session.setAttribute("employerUser", user);
            session.removeAttribute("seekerUser"); // Clean up
            session.setAttribute("employerId", user.getId()); // ← ADD THIS
            System.out.println("Stored as employerUser in session");
        }

        // Keep generic for compatibility with existing code
        session.setAttribute("user", user); // ← You can keep or remove this
        // ========== END FIX ==========
        
        
        
        
        
        System.out.println("Session created with userId: " + user.getId());

        // Redirect based on role
        if ("seeker".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/seeker/dashboard?success=1");
        } else if ("employer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard?success=1");
        } else if ("admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=1");
        } else {
            // FIXED: Correct path to login.jsp
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=invalid_role");
        }
    }
}