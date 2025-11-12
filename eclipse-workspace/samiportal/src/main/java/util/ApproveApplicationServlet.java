package util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/approve")
public class ApproveApplicationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int appId = Integer.parseInt(request.getParameter("id"));

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE applications SET status='approved' WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, appId);
            ps.executeUpdate();

            // ✅ Redirect to servlet (NOT JSP)
            response.sendRedirect("adminViewApps");

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
