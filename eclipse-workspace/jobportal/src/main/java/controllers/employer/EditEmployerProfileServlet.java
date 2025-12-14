package controllers.employer;

import dao.EmployerProfileDAO;
import dao.EmployerProfileDAOImpl;
import dao.UserDAO;
import dao.UserDAOImpl;
import models.EmployerProfile;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/employer/editProfile")
@MultipartConfig
public class EditEmployerProfileServlet extends HttpServlet {

    private EmployerProfileDAO profileDAO = new EmployerProfileDAOImpl();
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

        // Get profile and user data
        EmployerProfile profile = profileDAO.getByEmployerId(employerId);
        User user = userDAO.findById(employerId);

        request.setAttribute("profile", profile);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/employer/editProfile.jsp").forward(request, response);
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

        // Get form parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String companyName = request.getParameter("companyName");
        String website = request.getParameter("website");
        String bio = request.getParameter("bio");
        String address = request.getParameter("address");

        // Avatar upload
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

        // Update User table (name, email, phone, avatar)
        User user = userDAO.findById(employerId);
        user.setName(name);
        user.setEmail(email);
        user.setPhone(phone);
        if (avatarPath != null) {
            user.setAvatarPath(avatarPath);
        }
        
        boolean userUpdated = userDAO.update(user);

        // Update or create EmployerProfile
        EmployerProfile profile = profileDAO.getByEmployerId(employerId);
        boolean profileUpdated = false;
        
        if (profile == null) {
            // Create new profile
            profile = new EmployerProfile();
            profile.setUserId(employerId);
            profile.setCompanyName(companyName);
            profile.setWebsite(website);
            profile.setBio(bio);
            profile.setAddress(address);
            profileUpdated = profileDAO.createProfile(profile);
        } else {
            // Update existing profile
            profile.setCompanyName(companyName);
            profile.setWebsite(website);
            profile.setBio(bio);
            profile.setAddress(address);
            profileUpdated = profileDAO.updateProfile(profile);
        }

        if (userUpdated || profileUpdated) {
            // Update session with new user data
            session.setAttribute("employerUser", user);
            response.sendRedirect(request.getContextPath() + "/employer/dashboard?profileUpdated=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/employer/editProfile?error=1");
        }
    }
}