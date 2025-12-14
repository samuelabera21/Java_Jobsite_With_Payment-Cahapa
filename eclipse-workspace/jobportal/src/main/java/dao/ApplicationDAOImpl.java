//package dao;
//
//import models.Application;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class ApplicationDAOImpl implements ApplicationDAO {
//
//    @Override
//    public boolean apply(Application app) {
//        String sql = "INSERT INTO applications (job_id, seeker_id, cover_letter, status) "
//                   + "VALUES (?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, app.getJobId());
//            ps.setInt(2, app.getSeekerId());
//            ps.setString(3, app.getCoverLetter());
//            ps.setString(4, app.getStatus());
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
//    @Override
//    public List<Application> getByJob(int jobId) {
//        List<Application> list = new ArrayList<>();
//        String sql = "SELECT * FROM applications WHERE job_id=? ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, jobId);
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(extract(rs));
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return list;
//    }
//
//    @Override
//    public List<Application> getByUser(int userId) {
//        List<Application> list = new ArrayList<>();
//        String sql = "SELECT * FROM applications WHERE seeker_id=? ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, userId);
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(extract(rs));
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return list;
//    }
//
//    @Override
//    public List<Application> getAll() {
//        List<Application> list = new ArrayList<>();
//        String sql = "SELECT * FROM applications ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                list.add(extract(rs));
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return list;
//    }
//
//    @Override
//    public Application getById(int id) {
//        String sql = "SELECT * FROM applications WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return extract(rs);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return null;
//    }
//
//    @Override
//    public boolean updateStatus(int id, String status) {
//        String sql = "UPDATE applications SET status=? WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, status);
//            ps.setInt(2, id);
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
//    @Override
//    public boolean delete(int id) {
//        String sql = "DELETE FROM applications WHERE id=?";
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
//    private Application extract(ResultSet rs) throws Exception {
//        Application app = new Application();
//
//        app.setId(rs.getInt("id"));
//        app.setJobId(rs.getInt("job_id"));
//        app.setSeekerId(rs.getInt("seeker_id"));
//        app.setCoverLetter(rs.getString("cover_letter"));
//        app.setStatus(rs.getString("status"));
//        app.setCreatedAt(rs.getString("created_at"));
//        app.setUpdatedAt(rs.getString("updated_at"));
//
//        return app;
//    }
//}





















//
//
//
//
//
//
//package dao;
//
//import models.Application;
//import util.DBConnection;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class ApplicationDAOImpl implements ApplicationDAO {
//
//    // Helper method to convert ResultSet → Application object
//    private Application extract(ResultSet rs) throws Exception {
//        Application a = new Application();
//        a.setId(rs.getInt("id"));
//        a.setJobId(rs.getInt("job_id"));
//        a.setSeekerId(rs.getInt("seeker_id"));
//        a.setCoverLetter(rs.getString("cover_letter"));
//        a.setStatus(rs.getString("status"));
//        a.setUpdatedAt(rs.getString("created_at"));
//        a.setUpdatedAt(rs.getString("updated_at"));
//        return a;
//    }
//
//    @Override
//    public boolean create(Application app) {
//        String sql = "INSERT INTO applications (job_id, seeker_id, cover_letter, status) VALUES (?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, app.getJobId());
//            ps.setInt(2, app.getSeekerId());
//            ps.setString(3, app.getCoverLetter());
//            ps.setString(4, app.getStatus());
//
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    @Override
//    public Application getById(int id) {
//        String sql = "SELECT * FROM applications WHERE id = ?";
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
//    @Override
//    public List<Application> getAll() {
//        List<Application> list = new ArrayList<>();
//        String sql = "SELECT * FROM applications ORDER BY created_at DESC";
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
//    @Override
//    public List<Application> getByJob(int jobId) {
//        List<Application> list = new ArrayList<>();
//        String sql = "SELECT * FROM applications WHERE job_id = ? ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, jobId);
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
//    @Override
//    public List<Application> getBySeeker(int seekerId) {
//        List<Application> list = new ArrayList<>();
//        String sql = "SELECT * FROM applications WHERE seeker_id = ? ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, seekerId);
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
//    @Override
//    public List<Application> getByEmployer(int employerId) {
//        List<Application> list = new ArrayList<>();
//
//        String sql = """
//            SELECT a.*
//            FROM applications a
//            JOIN jobs j ON a.job_id = j.id
//            WHERE j.employer_id = ?
//            ORDER BY a.created_at DESC
//        """;
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, employerId);
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
//    @Override
//    public int countAll() {
//        String sql = "SELECT COUNT(*) FROM applications";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            if (rs.next()) return rs.getInt(1);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return 0;
//    }
//}















package dao;

import models.Application;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAOImpl implements ApplicationDAO {

    // Convert ResultSet → Application
    private Application extract(ResultSet rs) throws Exception {
        Application a = new Application();

        a.setId(rs.getInt("id"));
        a.setJobId(rs.getInt("job_id"));
        a.setSeekerId(rs.getInt("seeker_id"));
        a.setMessage(rs.getString("message"));
        a.setCvPath(rs.getString("cv_path"));
        a.setStatus(rs.getString("status"));

        Timestamp applied = rs.getTimestamp("applied_at");
        a.setAppliedAt(applied != null ? applied.toString() : null);

        return a;
    }

//    @Override
//    public boolean create(Application app) {
//        String sql = "INSERT INTO applications (job_id, seeker_id, message, cv_path, status) VALUES (?, ?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, app.getJobId());
//            ps.setInt(2, app.getSeekerId());
//            ps.setString(3, app.getMessage());
//            ps.setString(4, app.getCvPath());
//            ps.setString(5, app.getStatus());
//
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return false;
//    }
    
    
    
    
    @Override
    public boolean create(Application app) {
        String sql = "INSERT INTO applications (job_id, seeker_id, message, cv_path, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, app.getJobId());
            ps.setInt(2, app.getSeekerId());
            ps.setString(3, app.getMessage());
            ps.setString(4, app.getCvPath() != null ? app.getCvPath() : null);
            ps.setString(5, app.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    
    
    
    
    
    
    
    
    
    
    
    
    

    @Override
    public Application getById(int id) {
        String sql = "SELECT * FROM applications WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return extract(rs);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Application> getAll() {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT * FROM applications ORDER BY applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    @Override
    public List<Application> getByJob(int jobId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT * FROM applications WHERE job_id = ? ORDER BY applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    @Override
    public List<Application> getBySeeker(int seekerId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT * FROM applications WHERE seeker_id = ? ORDER BY applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, seekerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    @Override
    public List<Application> getByEmployer(int employerId) {
        List<Application> list = new ArrayList<>();

        String sql =
            "SELECT a.* FROM applications a " +
            "JOIN jobs j ON a.job_id = j.id " +
            "WHERE j.employer_id = ? " +
            "ORDER BY a.applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, employerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    @Override
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE applications SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM applications";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) { e.printStackTrace(); }

        return 0;
    }
}

