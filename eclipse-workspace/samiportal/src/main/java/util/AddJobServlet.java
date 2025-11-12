package util;


import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/addjob")
public class AddJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String company = request.getParameter("company");
        String location = request.getParameter("location");

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO jobs (title, description, company, location) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, company);
            ps.setString(4, location);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                out.println("<h2>✅ Job Posted Successfully!</h2>");
                out.println("<a href='adminHome.jsp'>Back to Admin Home</a>");
            } else {
                out.println("<h2>❌ Failed to Post Job</h2>");
            }

        } catch (Exception e) {
            out.println("<h2>Error: " + e.getMessage() + "</h2>");
        }
    }
}
