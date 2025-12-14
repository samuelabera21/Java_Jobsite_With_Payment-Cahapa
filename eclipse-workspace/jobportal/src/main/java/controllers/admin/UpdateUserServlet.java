package controllers.admin;

import dao.UserDAO;
import dao.UserDAOImpl;
import models.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/updateUser")
public class UpdateUserServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        String phone = request.getParameter("phone");

        User u = userDAO.findById(id);
        u.setName(name);
        u.setEmail(email);
        u.setRole(role);
        u.setStatus(status);
        u.setPhone(phone);

        userDAO.adminUpdate(u);

        response.sendRedirect(request.getContextPath() + "/admin/manageUsers");
    }
}
