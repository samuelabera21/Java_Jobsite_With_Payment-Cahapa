package dao;

import models.Setting;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SettingDAOImpl implements SettingDAO {

    @Override
    public List<Setting> getAll() {
        List<Setting> list = new ArrayList<>();
        String sql = "SELECT name, value, updated_at FROM system_settings ORDER BY name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Setting s = new Setting();
                s.setName(rs.getString("name"));
                s.setValue(rs.getString("value"));
                s.setUpdatedAt(rs.getString("updated_at"));
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public Setting get(String name) {
        String sql = "SELECT name, value, updated_at FROM system_settings WHERE name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Setting s = new Setting();
                    s.setName(rs.getString("name"));
                    s.setValue(rs.getString("value"));
                    s.setUpdatedAt(rs.getString("updated_at"));
                    return s;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public boolean upsert(Setting s) {
        // MySQL upsert
        String sql = "INSERT INTO system_settings (`name`,`value`) VALUES (?, ?) " +
                     "ON DUPLICATE KEY UPDATE `value` = VALUES(`value`)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getValue());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
