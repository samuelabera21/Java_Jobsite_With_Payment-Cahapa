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

@WebServlet("/applyJob")
public class ApplyJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        int jobId = Integer.parseInt(request.getParameter("job_id"));
        String message = request.getParameter("message");

        // ✅ Get user email from session
        String userEmail = (String) request.getSession().getAttribute("email");

        // ✅ If user not logged in
        if (userEmail == null) {
            out.println("<h2>⚠ Session expired — Please Login Again</h2>");
            out.println("<a href='login.jsp'>Go to Login</a>");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO applications (job_id, user_email, message) VALUES (?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, jobId);
            ps.setString(2, userEmail);
            ps.setString(3, message);

            int row = ps.executeUpdate();

            if (row > 0) {
                out.println("<h2>✅ Application Submitted Successfully!</h2>");
                out.println("<a href='viewJobs.jsp'>Back to Jobs</a>");
            } else {
                out.println("<h2>❌ Failed to Submit Application</h2>");
            }

        } catch (Exception e) {
            out.println("<h2>Error: " + e.getMessage() + "</h2>");
        }
    }
}
