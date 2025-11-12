package util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/viewApplications")
public class ViewApplicationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = (String) request.getSession().getAttribute("email");

        if (email == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();

            String sql =
                "SELECT a.id, j.title, a.message, a.applied_at, a.status " +
                "FROM applications a JOIN jobs j ON a.job_id = j.id " +
                "WHERE a.user_email = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            request.setAttribute("apps", rs);
            request.getRequestDispatcher("viewApplications.jsp").forward(request, response);

        } catch (Exception e) {
            response.getWriter().println("<h2>Error: " + e.getMessage() + "</h2>");
        }
    }
}
