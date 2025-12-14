package controllers.seeker;

import dao.UserDAO;
import dao.UserDAOImpl;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/seeker/editProfile")
@MultipartConfig
public class EditProfileServlet extends HttpServlet {

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
        request.getRequestDispatcher("/views/seeker/editProfile.jsp").forward(request, response);
    }

//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//
//        if (session == null || session.getAttribute("userId") == null) {
//            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
//            return;
//        }
//
//        int userId = (Integer) session.getAttribute("userId");
//
//        String name = request.getParameter("name");
//        String email = request.getParameter("email");
//        String phone = request.getParameter("phone");
//
//        // avatar upload
//        Part avatarPart = request.getPart("avatar");
//        String avatarPath = null;
//
//        if (avatarPart != null && avatarPart.getSize() > 0) {
//
//            String fileName = System.currentTimeMillis() + "_" + avatarPart.getSubmittedFileName();
//            String uploadDir = request.getServletContext().getRealPath("/uploads/avatars/");
//
//            File folder = new File(uploadDir);
//            if (!folder.exists()) folder.mkdirs();
//
//            avatarPart.write(uploadDir + File.separator + fileName);
//
//            avatarPath = "uploads/avatars/" + fileName;
//        }
//
//        User user = userDAO.findById(userId);
//        user.setName(name);
//        user.setEmail(email);
//        user.setPhone(phone);
//
//        if (avatarPath != null) user.setAvatarPath(avatarPath);
//
//        boolean ok = userDAO.update(user);
//
//        if (ok) {
////            response.sendRedirect(request.getContextPath() + "/seeker/profile?msg=updated");
//        	response.sendRedirect(request.getContextPath() + "/seeker/dashboard?profileUpdated=1");
//        } else {
//            response.sendRedirect(request.getContextPath() + "/seeker/editProfile?error=1");
//        }
//    }
    
    
    
    
    
    
    
    
    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // CHANGE THIS: Use seekerId instead of userId
        Integer userId = (Integer) session.getAttribute("seekerId");
        User seekerUser = (User) session.getAttribute("seekerUser");

        if (session == null || userId == null || seekerUser == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        // KEEP EVERYTHING ELSE EXACTLY THE SAME
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // avatar upload
        Part avatarPart = request.getPart("avatar");
        String avatarPath = null;

        if (avatarPart != null && avatarPart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + avatarPart.getSubmittedFileName();
            String uploadDir = request.getServletContext().getRealPath("/uploads/avatars/");

            File folder = new File(uploadDir);
            if (!folder.exists()) folder.mkdirs();

            avatarPart.write(uploadDir + File.separator + fileName);

            avatarPath = "uploads/avatars/" + fileName;
        }

        User user = userDAO.findById(userId);
        user.setName(name);
        user.setEmail(email);
        user.setPhone(phone);

        if (avatarPath != null) user.setAvatarPath(avatarPath);

        boolean ok = userDAO.update(user);

        if (ok) {
            // Update session with new user data
            session.setAttribute("seekerUser", user);
            response.sendRedirect(request.getContextPath() + "/seeker/dashboard?profileUpdated=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/seeker/editProfile?error=1");
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
