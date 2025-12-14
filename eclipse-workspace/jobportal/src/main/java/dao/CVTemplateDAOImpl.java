package dao;

import models.CVTemplate;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CVTemplateDAOImpl implements CVTemplateDAO {

    @Override
    public boolean create(CVTemplate template) {
        String sql = "INSERT INTO cv_templates (name, file_path, description) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, template.getName());
            ps.setString(2, template.getFilePath());
            ps.setString(3, template.getDescription());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean update(CVTemplate template) {
        String sql = "UPDATE cv_templates SET name=?, file_path=?, description=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, template.getName());
            ps.setString(2, template.getFilePath());
            ps.setString(3, template.getDescription());
            ps.setInt(4, template.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM cv_templates WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public CVTemplate getById(int id) {
        String sql = "SELECT * FROM cv_templates WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extract(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<CVTemplate> getAll() {
        List<CVTemplate> list = new ArrayList<>();
        String sql = "SELECT * FROM cv_templates ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extract(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private CVTemplate extract(ResultSet rs) throws Exception {
        CVTemplate t = new CVTemplate();

        t.setId(rs.getInt("id"));
        t.setName(rs.getString("name"));
        t.setFilePath(rs.getString("file_path"));
        t.setDescription(rs.getString("description"));
        t.setCreatedAt(rs.getString("created_at"));
//        t.setUpdatedAt(rs.getString("updated_at"));

        return t;
    }
}
