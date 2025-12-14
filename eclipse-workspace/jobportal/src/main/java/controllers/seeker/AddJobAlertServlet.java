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
//
//@WebServlet("/seeker/addAlert")
//public class AddJobAlertServlet extends HttpServlet {
//
//    private JobAlertDAO alertDAO = new JobAlertDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//
//        Integer userId = (Integer) request.getSession().getAttribute("userId");
//
//        String keyword = request.getParameter("keyword");
//        String location = request.getParameter("location");
//        String category = request.getParameter("category");
//
//        JobAlert alert = new JobAlert();
//        alert.setUserId(userId);
//        alert.setKeyword(keyword);
//        alert.setLocation(location);
//        alert.setCategory(category);
//
//        alertDAO.create(alert);
//
//        response.sendRedirect(request.getContextPath() + "/seeker/jobAlerts");
//    }
//}









//
//
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
//
//@WebServlet("/seeker/addAlert")
//public class AddJobAlertServlet extends HttpServlet {
//
//    private JobAlertDAO alertDAO = new JobAlertDAOImpl();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//
//        Integer userId = (Integer) request.getSession().getAttribute("userId");
//
//        String keywords = request.getParameter("keywords");
//        String location = request.getParameter("location");
//        String frequency = request.getParameter("frequency");
//
//        JobAlert alert = new JobAlert();
//        alert.setUserId(userId);
//        alert.setKeywords(keywords);
//        alert.setLocation(location);
//        alert.setFrequency(frequency);
//        alert.setActive(true);
//
//        alertDAO.create(alert);
//
//        response.sendRedirect(request.getContextPath() + "/seeker/jobAlerts");
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

@WebServlet("/seeker/addAlert")
public class AddJobAlertServlet extends HttpServlet {

    private JobAlertDAO alertDAO = new JobAlertDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // UPDATE: Use seekerId instead of userId
        Integer seekerId = (Integer) session.getAttribute("seekerId");
        User seekerUser = (User) session.getAttribute("seekerUser");

        if (session == null || seekerId == null || seekerUser == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String keywords = request.getParameter("keywords");
        String location = request.getParameter("location");
        String frequency = request.getParameter("frequency");

        JobAlert alert = new JobAlert();
        alert.setUserId(seekerId); // Use seekerId
        alert.setKeywords(keywords);
        alert.setLocation(location);
        alert.setFrequency(frequency);
        alert.setActive(true);

        alertDAO.create(alert);

        response.sendRedirect(request.getContextPath() + "/seeker/jobAlerts");
    }
}
