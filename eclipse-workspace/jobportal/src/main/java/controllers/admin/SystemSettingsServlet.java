package controllers.admin;

import dao.SettingDAO;
import dao.SettingDAOImpl;
import models.Setting;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/systemSettings")
public class SystemSettingsServlet extends HttpServlet {

    private SettingDAO settingDAO = new SettingDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Setting> list = settingDAO.getAll();
        request.setAttribute("settings", list);

        // convenience: load common settings into attributes for easier form binding
        Setting sSite = settingDAO.get("site_name");
        Setting sEmail = settingDAO.get("admin_email");
        Setting sAllow = settingDAO.get("allow_registration");
        Setting sEmployer = settingDAO.get("employer_default_status");

        request.setAttribute("site_name", sSite != null ? sSite.getValue() : "");
        request.setAttribute("admin_email", sEmail != null ? sEmail.getValue() : "");
        request.setAttribute("allow_registration", sAllow != null ? sAllow.getValue() : "true");
        request.setAttribute("employer_default_status", sEmployer != null ? sEmployer.getValue() : "pending");

        request.getRequestDispatcher("/views/admin/system_settings.jsp").forward(request, response);
    }
}
