//package controllers.seeker;
//
//import dao.JobAlertDAO;
//import dao.JobAlertDAOImpl;
//import models.JobAlert;
//
//import javax.servlet.*;
//import javax.servlet.http.*;
//import javax.servlet.annotation.*;
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet("/seeker/jobAlerts")
//public class JobAlertsServlet extends HttpServlet {
//
//    private JobAlertDAO alertDAO = new JobAlertDAOImpl();
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//
//        Integer userId = (Integer) request.getSession().getAttribute("userId");
//        if (userId == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
//
//        List<JobAlert> alerts = alertDAO.getByUser(userId);
//        request.setAttribute("alerts", alerts);
//
//        request.getRequestDispatcher("/views/seeker/jobAlerts.jsp").forward(request, response);
//    }
//}




package controllers.seeker;

import dao.JobAlertDAO;
import dao.JobAlertDAOImpl;
import models.JobAlert;
import models.User; // ADD THIS IMPORT

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/seeker/jobAlerts")
public class JobAlertsServlet extends HttpServlet {

    private JobAlertDAO alertDAO = new JobAlertDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // UPDATE: Use seekerId instead of userId
        Integer seekerId = (Integer) session.getAttribute("seekerId");
        User seekerUser = (User) session.getAttribute("seekerUser");

        if (session == null || seekerId == null || seekerUser == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        List<JobAlert> alerts = alertDAO.getByUser(seekerId);
        request.setAttribute("alerts", alerts);

        request.getRequestDispatcher("/views/seeker/jobAlerts.jsp").forward(request, response);
    }
}