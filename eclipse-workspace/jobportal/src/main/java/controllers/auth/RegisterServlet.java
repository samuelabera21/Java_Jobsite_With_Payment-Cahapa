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
//@WebServlet("/register")
//public class RegisterServlet extends HttpServlet {
//
//    private UserDAO userDAO = new UserDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String name = request.getParameter("name");
//        String email = request.getParameter("email");
//        String password = request.getParameter("password");
//        String role = request.getParameter("role");  // user selects: seeker / employer
//
//        User user = new User();
//        user.setName(name);
//        user.setEmail(email);
//        user.setPassword(password);
//        user.setRole(role);
//        user.setStatus("pending"); // employers need approval
//
//        boolean saved = userDAO.register(user);
//
//        if (saved) {
//            response.sendRedirect("login.jsp?success=registered");
//        } else {
//            response.sendRedirect("register.jsp?error=1");
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
//@WebServlet("/register")
//public class RegisterServlet extends HttpServlet {
//
//    private UserDAO userDAO = new UserDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String name = request.getParameter("name");
//        String email = request.getParameter("email");
//        String password = request.getParameter("password");
//        String role = request.getParameter("role");
//
//        User user = new User();
//        user.setName(name);
//        user.setEmail(email);
//        user.setPassword(password);
//        user.setRole(role);
//
//        // If employer → pending approval
//        if (role.equals("employer")) {
//            user.setStatus("pending");
//        } else {
//            user.setStatus("approved");
//        }
//
//        // FIXED: use correct DAO method
//        boolean saved = userDAO.create(user);
//
//        if (saved) {
//            response.sendRedirect("login.jsp?success=registered");
//        } else {
//            response.sendRedirect("register.jsp?error=1");
//        }
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
//@WebServlet("/register")
//public class RegisterServlet extends HttpServlet {
//
//    private UserDAO userDAO = new UserDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String name = request.getParameter("name");
//        String email = request.getParameter("email");
//        String password = request.getParameter("password");
//        String role = request.getParameter("role");
//
//        User user = new User();
//        user.setName(name);
//        user.setEmail(email);
//        user.setPassword(password);
//        user.setRole(role);
//
//        // ✔ Correct status logic
//        if ("employer".equals(role)) {
//            user.setStatus("pending");   // must be approved by admin
//        }
//        else if ("seeker".equals(role)) {
//            user.setStatus("active");    // seekers always active
//        }
//        else {
//            user.setStatus("active");    // default for admin or others
//        }
//
//        boolean saved = userDAO.create(user);
//
//        if (saved) {
//            response.sendRedirect("login.jsp?success=registered");
//        } else {
//            response.sendRedirect("register.jsp?error=1");
//        }
//    }
//}
//





















//belo second---------------------------------

//
//package controllers.auth;
//
//import dao.UserDAO;
//import dao.UserDAOImpl;
//import dao.SettingDAO;
//import dao.SettingDAOImpl;
//import models.User;
//import models.Setting;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/register")
//public class RegisterServlet extends HttpServlet {
//
//    private UserDAO userDAO = new UserDAOImpl();
//    private SettingDAO settingDAO = new SettingDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // ============================
//        // 1) Load settings from DB
//        // ============================
//
//        Setting allowReg = settingDAO.get("allow_registration");
//        Setting employerDefault = settingDAO.get("employer_default_status");
//
//        boolean registrationAllowed = allowReg == null || 
//                                      !"false".equalsIgnoreCase(allowReg.getValue());
//
//        String employerStatus = (employerDefault != null)
//                ? employerDefault.getValue()
//                : "pending"; // fallback default
//
//
//        // ============================
//        // 2) If admin disabled registration → block
//        // ============================
//
//        if (!registrationAllowed) {
//            response.sendRedirect("register.jsp?error=disabled");
//            return;
//        }
//
//
//        // ============================
//        // 3) Read form inputs
//        // ============================
//
//        String name = request.getParameter("name");
//        String email = request.getParameter("email");
//        String password = request.getParameter("password");
//        String role = request.getParameter("role");
//
//
//        // ============================
//        // 4) Build User object
//        // ============================
//
//        User user = new User();
//        user.setName(name);
//        user.setEmail(email);
//        user.setPassword(password);
//        user.setRole(role);
//
//        // ✔ Dynamic role behavior based on admin settings
//        if ("employer".equals(role)) {
//            user.setStatus(employerStatus);  // <- pending / approved / active
//        } else {
//            user.setStatus("active"); // seeker or admin
//        }
//
//
//        // ============================
//        // 5) Save user
//        // ============================
//
//        boolean saved = userDAO.create(user);
//
//        if (saved) {
//            response.sendRedirect("login.jsp?success=registered");
//        } else {
//            response.sendRedirect("register.jsp?error=1");
//        }
//    }
//}




package controllers.auth;

import dao.UserDAO;
import dao.UserDAOImpl;
import dao.SettingDAO;
import dao.SettingDAOImpl;
import models.User;
import models.Setting;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();
    private SettingDAO settingDAO = new SettingDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath(); // Get context path

        // ============================
        // 1) Load settings from DB
        // ============================

        Setting allowReg = settingDAO.get("allow_registration");
        Setting employerDefault = settingDAO.get("employer_default_status");

        boolean registrationAllowed = allowReg == null || 
                                      !"false".equalsIgnoreCase(allowReg.getValue());

        String employerStatus = (employerDefault != null)
                ? employerDefault.getValue()
                : "pending"; // fallback default

        // ============================
        // 2) If admin disabled registration → block
        // ============================

        if (!registrationAllowed) {
            // FIXED: Add context path
            response.sendRedirect(contextPath + "/views/auth/register.jsp?error=disabled");
            return;
        }

        // ============================
        // 3) Read form inputs
        // ============================

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // ============================
        // 4) Build User object
        // ============================

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole(role);

        // ✔ Dynamic role behavior based on admin settings
        if ("employer".equals(role)) {
            user.setStatus(employerStatus);  // <- pending / approved / active
        } else {
            user.setStatus("active"); // seeker or admin
        }

        // ============================
        // 5) Save user
        // ============================

        boolean saved = userDAO.create(user);

        if (saved) {
            // FIXED: Add context path
            response.sendRedirect(contextPath + "/views/auth/login.jsp?success=registered");
        } else {
            // FIXED: Add context path
            response.sendRedirect(contextPath + "/views/auth/register.jsp?error=1");
        }
    }
}
