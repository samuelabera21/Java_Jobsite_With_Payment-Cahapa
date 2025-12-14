//package controllers.seeker;
//
//import dao.JobDAO;
//import dao.JobDAOImpl;
//import models.Job;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet("/seeker/search")
//public class SearchJobServlet extends HttpServlet {
//
//    private JobDAO jobDAO = new JobDAOImpl();
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String keyword = request.getParameter("q");
//
//        List<Job> results = jobDAO.search(keyword);
//
//        request.setAttribute("jobs", results);
//        request.setAttribute("keyword", keyword);
//
//        request.getRequestDispatcher("/views/seeker/searchJobs.jsp").forward(request, response);
//    }
//}








package controllers.seeker;

import dao.JobDAO;
import dao.JobDAOImpl;
import models.Job;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/seeker/searchJobs")   // ✅ FIXED
public class SearchJobServlet extends HttpServlet {

    private JobDAO jobDAO = new JobDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("q");

        List<Job> results = jobDAO.search(keyword);

        request.setAttribute("jobs", results);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/views/seeker/viewJobs.jsp").forward(request, response);
    }
}
