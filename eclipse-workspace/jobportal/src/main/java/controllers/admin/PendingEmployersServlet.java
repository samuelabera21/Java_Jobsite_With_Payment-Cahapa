package controllers.admin;

import dao.UserDAO;
import dao.UserDAOImpl;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/pendingEmployers")
public class PendingEmployersServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> pending = userDAO.getPendingEmployers();

        request.setAttribute("pendingEmployers", pending);

        request.getRequestDispatcher("/views/admin/pending_employers.jsp")
               .forward(request, response);
    }
}
