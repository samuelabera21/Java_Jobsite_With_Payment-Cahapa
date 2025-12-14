package controllers.admin;

import dao.UserDAO;
import dao.UserDAOImpl;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/manageUsers")
public class ManageUsersServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> userList = userDAO.getAll();

        request.setAttribute("users", userList);

        request.getRequestDispatcher("/views/admin/manageUsers.jsp")
               .forward(request, response);
    }
}
