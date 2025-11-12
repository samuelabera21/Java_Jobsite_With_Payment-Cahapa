package util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/dbtest")
public class DBTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();

            if (conn != null) {
                response.getWriter().println("<h1>✅ Database Connected Successfully!</h1>");
            } else {
                response.getWriter().println("<h1>❌ Database Connection Failed!</h1>");
            }

        } catch (SQLException e) {
            response.getWriter().println("<h1>❌ Error: " + e.getMessage() + "</h1>");
        }
    }
}
