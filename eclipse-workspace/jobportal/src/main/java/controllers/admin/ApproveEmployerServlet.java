package controllers.admin;

import dao.UserDAO;
import dao.UserDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/approveEmployer")
public class ApproveEmployerServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        userDAO.approveEmployer(id);

        response.sendRedirect(request.getContextPath() + "/admin/manageUsers?approved=1");
    }
}
