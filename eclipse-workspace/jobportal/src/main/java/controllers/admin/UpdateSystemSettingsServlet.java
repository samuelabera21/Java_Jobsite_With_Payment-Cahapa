package controllers.admin;

import dao.SettingDAO;
import dao.SettingDAOImpl;
import models.Setting;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/updateSystemSettings")
public class UpdateSystemSettingsServlet extends HttpServlet {

    private SettingDAO settingDAO = new SettingDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String siteName = request.getParameter("site_name");
        String adminEmail = request.getParameter("admin_email");
        String allowReg = request.getParameter("allow_registration");
        String employerDefault = request.getParameter("employer_default_status");

        if (siteName != null) settingDAO.upsert(new Setting("site_name", siteName.trim()));
        if (adminEmail != null) settingDAO.upsert(new Setting("admin_email", adminEmail.trim()));
        if (allowReg != null) settingDAO.upsert(new Setting("allow_registration", allowReg.trim()));
        if (employerDefault != null) settingDAO.upsert(new Setting("employer_default_status", employerDefault.trim()));

        response.sendRedirect(request.getContextPath() + "/admin/systemSettings?updated=1");
    }
}
