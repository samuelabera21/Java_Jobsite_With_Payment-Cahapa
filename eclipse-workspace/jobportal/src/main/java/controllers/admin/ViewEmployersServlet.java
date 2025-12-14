package controllers.admin;

import dao.UserDAO;
import dao.UserDAOImpl;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/viewEmployers")
public class ViewEmployersServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> employers = userDAO.getUsersByRole("employer");
        request.setAttribute("employers", employers);

        request.getRequestDispatcher("/views/admin/view_employers.jsp").forward(request, response);
    }
}
