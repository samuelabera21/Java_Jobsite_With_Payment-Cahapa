package controllers.seeker;

import dao.UserDAO;
import dao.UserDAOImpl;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/seeker/profile")
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

//        if (session == null || session.getAttribute("userId") == null) {
//            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
//            return;
//        }
     // Check for seeker-specific session attribute
        Integer userId = (Integer) session.getAttribute("seekerId");
        User seekerUser = (User) session.getAttribute("seekerUser");

        if (session == null || userId == null || seekerUser == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        

//        int userId = (Integer) session.getAttribute("userId");
        User user = userDAO.findById(userId);

        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/seeker/profile.jsp").forward(request, response);
    }
}
