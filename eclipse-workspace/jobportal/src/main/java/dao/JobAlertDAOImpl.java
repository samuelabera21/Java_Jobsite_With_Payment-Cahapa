//package dao;
//
//import models.JobAlert;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class JobAlertDAOImpl implements JobAlertDAO {
//
//    @Override
//    public boolean create(JobAlert alert) {
//        String sql = "INSERT INTO job_alerts (user_id, keyword, location, category) "
//                   + "VALUES (?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, alert.getUserId());
//            ps.setString(2, alert.getKeyword());
//            ps.setString(3, alert.getLocation());
//            ps.setString(4, alert.getCategory());
//
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return false;
//    }
//
//
//    @Override
//    public boolean delete(int id) {
//        String sql = "DELETE FROM job_alerts WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return false;
//    }
//
//
//    @Override
//    public JobAlert getById(int id) {
//        String sql = "SELECT * FROM job_alerts WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) return extract(rs);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return null;
//    }
//
//
//    @Override
//    public List<JobAlert> getByUser(int userId) {
//        List<JobAlert> list = new ArrayList<>();
//        String sql = "SELECT * FROM job_alerts WHERE user_id=? ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, userId);
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return list;
//    }
//
//
//    @Override
//    public List<JobAlert> getAll() {
//        List<JobAlert> list = new ArrayList<>();
//        String sql = "SELECT * FROM job_alerts ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return list;
//    }
//
//
//    private JobAlert extract(ResultSet rs) throws Exception {
//        JobAlert ja = new JobAlert();
//
//        ja.setId(rs.getInt("id"));
//        ja.setUserId(rs.getInt("user_id"));
//        ja.setKeyword(rs.getString("keyword"));
//        ja.setLocation(rs.getString("location"));
//        ja.setCategory(rs.getString("category"));
//        ja.setCreatedAt(rs.getString("created_at"));
//        ja.setUpdatedAt(rs.getString("updated_at"));
//
//        return ja;
//    }
//}






















package dao;

import models.JobAlert;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobAlertDAOImpl implements JobAlertDAO {

    @Override
    public boolean create(JobAlert alert) {
        String sql = "INSERT INTO job_alerts (user_id, keywords, location, frequency, is_active) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, alert.getUserId());
            ps.setString(2, alert.getKeywords());
            ps.setString(3, alert.getLocation());
            ps.setString(4, alert.getFrequency());
            ps.setBoolean(5, alert.isActive());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM job_alerts WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public JobAlert getById(int id) {
        String sql = "SELECT * FROM job_alerts WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extract(rs);

        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public List<JobAlert> getByUser(int userId) {
        List<JobAlert> list = new ArrayList<>();
        String sql = "SELECT * FROM job_alerts WHERE user_id=? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    @Override
    public List<JobAlert> getAll() {
        List<JobAlert> list = new ArrayList<>();
        String sql = "SELECT * FROM job_alerts ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    private JobAlert extract(ResultSet rs) throws Exception {
        JobAlert ja = new JobAlert();

        ja.setId(rs.getInt("id"));
        ja.setUserId(rs.getInt("user_id"));
        ja.setKeywords(rs.getString("keywords"));
        ja.setLocation(rs.getString("location"));
        ja.setFrequency(rs.getString("frequency"));
        ja.setActive(rs.getBoolean("is_active"));
        ja.setCreatedAt(rs.getString("created_at"));

        return ja;
    }
}

