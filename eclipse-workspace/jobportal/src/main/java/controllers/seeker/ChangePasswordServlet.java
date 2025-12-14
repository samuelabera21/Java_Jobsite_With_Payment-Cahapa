package controllers.seeker;

import dao.UserDAO;
import models.User;
import dao.UserDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/seeker/changePassword")
public class ChangePasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/seeker/changePassword.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

//        if (session == null || session.getAttribute("userId") == null) {
//            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
//            return;
//        }
//
//        int userId = (Integer) session.getAttribute("userId");
        
     // Use seekerId instead of userId
        Integer seekerId = (Integer) session.getAttribute("seekerId");
        User seekerUser = (User) session.getAttribute("seekerUser");

        if (session == null || seekerId == null || seekerUser == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        int userId = seekerId; // Use seekerId

        String newPass = request.getParameter("new_password");
        String confirm = request.getParameter("confirm_password");

        if (!newPass.equals(confirm)) {
            response.sendRedirect(request.getContextPath() + "/seeker/changePassword?error=nomatch");
            return;
        }

        boolean ok = userDAO.changePassword(userId, newPass);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/seeker/profile?msg=password_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/seeker/changePassword?error=1");
        }
    }
}
