package controllers.admin;

import dao.UserDAO;
import dao.UserDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/deactivateUser")
public class DeactivateUserServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deactivateUser(id);

        response.sendRedirect(request.getContextPath() + "/admin/manageUsers");
    }
}
