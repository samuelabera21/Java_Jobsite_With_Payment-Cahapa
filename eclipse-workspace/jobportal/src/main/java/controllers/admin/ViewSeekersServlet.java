package controllers.admin;

import dao.UserDAO;
import dao.UserDAOImpl;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/viewSeekers")
public class ViewSeekersServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> seekers = userDAO.getUsersByRole("seeker");
        request.setAttribute("seekers", seekers);

        request.getRequestDispatcher("/views/admin/view_seekers.jsp").forward(request, response);
    }
}
