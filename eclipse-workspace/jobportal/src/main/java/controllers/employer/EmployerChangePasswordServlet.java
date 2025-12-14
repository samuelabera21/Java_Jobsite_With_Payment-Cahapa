package controllers.employer;

import dao.UserDAO;
import dao.UserDAOImpl;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/employer/changePassword")
public class EmployerChangePasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer employerId = (Integer) session.getAttribute("employerId");
        User employerUser = (User) session.getAttribute("employerUser");

        if (employerId == null || employerUser == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        request.getRequestDispatcher("/views/employer/changePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer employerId = (Integer) session.getAttribute("employerId");
        User employerUser = (User) session.getAttribute("employerUser");

        if (employerId == null || employerUser == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String newPass = request.getParameter("new_password");
        String confirm = request.getParameter("confirm_password");

        if (!newPass.equals(confirm)) {
            response.sendRedirect(request.getContextPath() + "/employer/changePassword?error=nomatch");
            return;
        }

        boolean ok = userDAO.changePassword(employerId, newPass);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/employer/profile?msg=password_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/employer/changePassword?error=1");
        }
    }
}