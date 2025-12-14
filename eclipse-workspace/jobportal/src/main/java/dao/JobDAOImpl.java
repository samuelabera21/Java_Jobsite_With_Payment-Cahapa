//package dao;
//
//import models.Job;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class JobDAOImpl implements JobDAO {
//
//    @Override
//    public boolean create(Job job) {
//        String sql = "INSERT INTO jobs (employer_id, title, description, location, category, salary, type) "
//                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, job.getEmployerId());
//            ps.setString(2, job.getTitle());
//            ps.setString(3, job.getDescription());
//            ps.setString(4, job.getLocation());
//            ps.setString(5, job.getCategory());
//            ps.setString(6, job.getSalary());
//            ps.setString(7, job.getType());
//
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//
//    @Override
//    public boolean update(Job job) {
//        String sql = "UPDATE jobs SET title=?, description=?, location=?, category=?, salary=?, type=? WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, job.getTitle());
//            ps.setString(2, job.getDescription());
//            ps.setString(3, job.getLocation());
//            ps.setString(4, job.getCategory());
//            ps.setString(5, job.getSalary());
//            ps.setString(6, job.getType());
//            ps.setInt(7, job.getId());
//
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//
//    @Override
//    public boolean delete(int jobId) {
//        String sql = "DELETE FROM jobs WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, jobId);
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//
//    @Override
//    public Job getById(int id) {
//        String sql = "SELECT * FROM jobs WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) return extract(rs);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//
//    @Override
//    public List<Job> getAll() {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs ORDER BY created_at DESC";
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
//        return list;
//    }
//
//
//    @Override
//    public List<Job> getByEmployer(int employerId) {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs WHERE employer_id=? ORDER BY created_at DESC";
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
//        return list;
//    }
//
//
//    @Override
//    public List<Job> search(String keyword) {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs WHERE title LIKE ? OR description LIKE ? OR location LIKE ?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            String like = "%" + keyword + "%";
//            ps.setString(1, like);
//            ps.setString(2, like);
//            ps.setString(3, like);
//
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//
//    @Override
//    public List<Job> filter(String location, String category) {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs WHERE location LIKE ? AND category LIKE ?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, location.equals("") ? "%" : location);
//            ps.setString(2, category.equals("") ? "%" : category);
//
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//
//    private Job extract(ResultSet rs) throws Exception {
//        Job j = new Job();
//        j.setId(rs.getInt("id"));
//        j.setEmployerId(rs.getInt("employer_id"));
//        j.setTitle(rs.getString("title"));
//        j.setDescription(rs.getString("description"));
//        j.setLocation(rs.getString("location"));
//        j.setCategory(rs.getString("category"));
//        j.setSalary(rs.getString("salary"));
//        j.setType(rs.getString("type"));
//        j.setCreatedAt(rs.getString("created_at"));
//        j.setUpdatedAt(rs.getString("updated_at"));
//        return j;
//    }
//}


//
//
//
//package dao;
//
//import models.Job;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class JobDAOImpl implements JobDAO {
//
//    private Job extract(ResultSet rs) throws Exception {
//        Job j = new Job();
//        j.setId(rs.getInt("id"));
//        j.setEmployerId(rs.getInt("employer_id"));
//        j.setTitle(rs.getString("title"));
//        j.setDescription(rs.getString("description"));
//        j.setLocation(rs.getString("location"));
//        j.setType(rs.getString("type"));
//        j.setCreatedAt(rs.getString("created_at"));
//        j.setUpdatedAt(rs.getString("updated_at"));
//        return j;
//    }
//
//    @Override
//    public boolean create(Job job) {
//        String sql = "INSERT INTO jobs (employer_id, title, description, location, type) VALUES (?, ?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, job.getEmployerId());
//            ps.setString(2, job.getTitle());
//            ps.setString(3, job.getDescription());
//            ps.setString(4, job.getLocation());
//            ps.setString(5, job.getType());
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
//    public Job getById(int id) {
//        String sql = "SELECT * FROM jobs WHERE id=?";
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
////    @Override
////    public List<Job> getAll() {
////        List<Job> list = new ArrayList<>();
////        String sql = "SELECT * FROM jobs ORDER BY created_at DESC";
////
////        try (Connection conn = DBConnection.getConnection();
////             PreparedStatement ps = conn.prepareStatement(sql);
////             ResultSet rs = ps.executeQuery()) {
////
////            while (rs.next()) list.add(extract(rs));
////
////        } catch (Exception e) {
////            e.printStackTrace();
////        }
////
////        return list;
////    }
//    
//    
//    
//    @Override
//    public List<Job> getAll() {
//        List<Job> list = new ArrayList<>();
//
//        String sql = "SELECT * FROM jobs ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                Job j = new Job();
//                j.setId(rs.getInt("id"));
//                j.setTitle(rs.getString("title"));
//                j.setDescription(rs.getString("description"));
//                j.setLocation(rs.getString("location"));
//                j.setType(rs.getString("type"));
//                j.setCreatedAt(rs.getTimestamp("created_at"));
//
//                list.add(j);
//            }
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
//    public List<Job> getByEmployer(int employerId) {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs WHERE employer_id=? ORDER BY created_at DESC";
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
//        String sql = "SELECT COUNT(*) FROM jobs";
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



//
//
//package dao;
//
//import models.Job;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class JobDAOImpl implements JobDAO {
//
//    // Convert database row -> Job object
//    private Job extract(ResultSet rs) throws Exception {
//        Job j = new Job();
//        j.setId(rs.getInt("id"));
//        j.setEmployerId(rs.getInt("employer_id"));
//        j.setTitle(rs.getString("title"));
//        j.setDescription(rs.getString("description"));
//        j.setLocation(rs.getString("location"));
//        j.setType(rs.getString("type"));
//
//        // Convert Timestamp -> String (your model uses String)
//        Timestamp created = rs.getTimestamp("created_at");
//        Timestamp updated = rs.getTimestamp("updated_at");
//
//        j.setCreatedAt(created != null ? created.toString() : null);
//        j.setUpdatedAt(updated != null ? updated.toString() : null);
//
//        return j;
//    }
//
//    @Override
//    public boolean create(Job job) {
//        String sql = "INSERT INTO jobs (employer_id, title, description, location, type) VALUES (?, ?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, job.getEmployerId());
//            ps.setString(2, job.getTitle());
//            ps.setString(3, job.getDescription());
//            ps.setString(4, job.getLocation());
//            ps.setString(5, job.getType());
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
//    public Job getById(int id) {
//        String sql = "SELECT * FROM jobs WHERE id=?";
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
//    public List<Job> getAll() {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs ORDER BY created_at DESC";
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
//    public List<Job> getByEmployer(int employerId) {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs WHERE employer_id=? ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, employerId);
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
//    public int countAll() {
//        String sql = "SELECT COUNT(*) FROM jobs";
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











//
//
//
//
//
//package dao;
//
//import models.Job;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class JobDAOImpl implements JobDAO {
//
//    // Convert database row -> Job object
//    private Job extract(ResultSet rs) throws Exception {
//        Job j = new Job();
//        j.setId(rs.getInt("id"));
//        j.setEmployerId(rs.getInt("employer_id"));
//        j.setTitle(rs.getString("title"));
//        j.setDescription(rs.getString("description"));
//        j.setLocation(rs.getString("location"));
//        j.setType(rs.getString("type"));
//
//        Timestamp created = rs.getTimestamp("created_at");
//        Timestamp updated = rs.getTimestamp("updated_at");
//
//        j.setCreatedAt(created != null ? created.toString() : null);
//        j.setUpdatedAt(updated != null ? updated.toString() : null);
//
//        return j;
//    }
//
//    @Override
//    public boolean create(Job job) {
//        String sql = "INSERT INTO jobs (employer_id, title, description, location, type) VALUES (?, ?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, job.getEmployerId());
//            ps.setString(2, job.getTitle());
//            ps.setString(3, job.getDescription());
//            ps.setString(4, job.getLocation());
//            ps.setString(5, job.getType());
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
//    public Job getById(int id) {
//        String sql = "SELECT * FROM jobs WHERE id=?";
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
//    public List<Job> getAll() {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs ORDER BY created_at DESC";
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
//    public List<Job> getByEmployer(int employerId) {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs WHERE employer_id=? ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, employerId);
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
//    public int countAll() {
//        String sql = "SELECT COUNT(*) FROM jobs";
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
//
//    // NEW — Search Jobs
//    @Override
//    public List<Job> search(String keyword) {
//        List<Job> list = new ArrayList<>();
//
//        String sql = "SELECT * FROM jobs " +
//                     "WHERE title LIKE ? OR description LIKE ? OR location LIKE ? " +
//                     "ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            String key = "%" + keyword + "%";
//
//            ps.setString(1, key);
//            ps.setString(2, key);
//            ps.setString(3, key);
//
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
//}
















//
//package dao;
//
//import models.Job;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class JobDAOImpl implements JobDAO {
//
//    private Job extract(ResultSet rs) throws Exception {
//        Job j = new Job();
//        j.setId(rs.getInt("id"));
//        j.setEmployerId(rs.getInt("employer_id"));
//        j.setTitle(rs.getString("title"));
//        j.setDescription(rs.getString("description"));
//        j.setLocation(rs.getString("location"));
//        j.setCategory(rs.getString("category"));
//        j.setSalary(rs.getString("salary"));
//        j.setType(rs.getString("employment_type"));  // maps to your model "type"
//
//        Timestamp created = rs.getTimestamp("created_at");
//        Timestamp updated = rs.getTimestamp("updated_at");
//
//        j.setCreatedAt(created != null ? created.toString() : null);
//        j.setUpdatedAt(updated != null ? updated.toString() : null);
//
//        return j;
//    }
//
//    @Override
//    public boolean create(Job job) {
//        String sql = "INSERT INTO jobs (employer_id, title, description, location, category, employment_type, salary, email_to_apply) "
//                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, job.getEmployerId());
//            ps.setString(2, job.getTitle());
//            ps.setString(3, job.getDescription());
//            ps.setString(4, job.getLocation());
//            ps.setString(5, job.getCategory());
//            ps.setString(6, job.getType());
//            ps.setString(7, job.getSalary());
//            ps.setString(8, ""); // empty email
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
//    public Job getById(int id) {
//        String sql = "SELECT * FROM jobs WHERE id=?";
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
//    public List<Job> getAll() {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs WHERE is_active=1 ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return list;
//    }
//
//    @Override
//    public List<Job> getByEmployer(int employerId) {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs WHERE employer_id=? ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, employerId);
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return list;
//    }
//
//    @Override
//    public int countAll() {
//        String sql = "SELECT COUNT(*) FROM jobs";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            if (rs.next()) return rs.getInt(1);
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return 0;
//    }
//
//    @Override
//    public List<Job> search(String keyword) {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs WHERE "
//                   + "title LIKE ? OR description LIKE ? OR location LIKE ? "
//                   + "ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            String key = "%" + keyword + "%";
//            ps.setString(1, key);
//            ps.setString(2, key);
//            ps.setString(3, key);
//
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return list;
//    }
//
//    @Override
//    public List<Job> filter(String location, String category, String type, String salary) {
//
//        List<Job> list = new ArrayList<>();
//
//        String sql = "SELECT * FROM jobs WHERE is_active = 1 "
//                   + "AND (? IS NULL OR location = ?) "
//                   + "AND (? IS NULL OR category = ?) "
//                   + "AND (? IS NULL OR employment_type = ?) "
//                   + "AND (? IS NULL OR salary = ?) "
//                   + "ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, location);
//            ps.setString(2, location);
//            ps.setString(3, category);
//            ps.setString(4, category);
//            ps.setString(5, type);
//            ps.setString(6, type);
//            ps.setString(7, salary);
//            ps.setString(8, salary);
//
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return list;
//    }
//}





















//final

//
//package dao;
//
//import models.Job;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class JobDAOImpl implements JobDAO {
//
//    private Job extract(ResultSet rs) throws Exception {
//        Job j = new Job();
//
//        j.setId(rs.getInt("id"));
//        j.setEmployerId(rs.getInt("employer_id"));
//        j.setTitle(rs.getString("title"));
//        j.setDescription(rs.getString("description"));
//        j.setLocation(rs.getString("location"));
//        j.setCategory(rs.getString("category"));
//        j.setSalary(rs.getString("salary"));
//        j.setType(rs.getString("employment_type"));
//        j.setEmailToApply(rs.getString("email_to_apply"));
//        j.setActive(rs.getBoolean("is_active"));
//
//        Timestamp created = rs.getTimestamp("created_at");
//        Timestamp updated = rs.getTimestamp("updated_at");
//
//        j.setCreatedAt(created != null ? created.toString() : null);
//        j.setUpdatedAt(updated != null ? updated.toString() : null);
//
//        return j;
//    }
//
//    @Override
//    public boolean create(Job job) {
//        String sql = "INSERT INTO jobs (employer_id, title, description, location, category, employment_type, salary, email_to_apply, is_active) "
//                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, job.getEmployerId());
//            ps.setString(2, job.getTitle());
//            ps.setString(3, job.getDescription());
//            ps.setString(4, job.getLocation());
//            ps.setString(5, job.getCategory());
//            ps.setString(6, job.getType());
//            ps.setString(7, job.getSalary());
//            ps.setString(8, job.getEmailToApply());
//            ps.setBoolean(9, job.isActive());
//
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return false;
//    }
//
//    @Override
//    public Job getById(int id) {
//        String sql = "SELECT * FROM jobs WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) return extract(rs);
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return null;
//    }
//
//    @Override
//    public List<Job> getAll() {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs WHERE is_active=1 ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return list;
//    }
//
//    @Override
//    public List<Job> getByEmployer(int employerId) {
//        List<Job> list = new ArrayList<>();
//        String sql = "SELECT * FROM jobs WHERE employer_id=? ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, employerId);
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return list;
//    }
//
//    @Override
//    public int countAll() {
//        String sql = "SELECT COUNT(*) FROM jobs";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            if (rs.next()) return rs.getInt(1);
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return 0;
//    }
//
//    @Override
//    public List<Job> search(String keyword) {
//        List<Job> list = new ArrayList<>();
//
//        String sql = "SELECT * FROM jobs WHERE is_active=1 AND "
//                   + "(title LIKE ? OR description LIKE ? OR location LIKE ?) "
//                   + "ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            String key = "%" + keyword + "%";
//
//            ps.setString(1, key);
//            ps.setString(2, key);
//            ps.setString(3, key);
//
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return list;
//    }
//
//    @Override
//    public List<Job> filter(String location, String category, String type, String salary) {
//        List<Job> list = new ArrayList<>();
//
//        String sql = "SELECT * FROM jobs WHERE is_active=1 "
//                   + "AND (? IS NULL OR location = ?) "
//                   + "AND (? IS NULL OR category = ?) "
//                   + "AND (? IS NULL OR employment_type = ?) "
//                   + "AND (? IS NULL OR salary = ?) "
//                   + "ORDER BY created_at DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, location); ps.setString(2, location);
//            ps.setString(3, category); ps.setString(4, category);
//            ps.setString(5, type);     ps.setString(6, type);
//            ps.setString(7, salary);   ps.setString(8, salary);
//
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) list.add(extract(rs));
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return list;
//    }
//    
//    
//    
//
//    
//    
//    
//    
//}














package dao;

import models.Job;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobDAOImpl implements JobDAO {

    // Extract job from ResultSet
    private Job extract(ResultSet rs) throws Exception {
        Job j = new Job();

        j.setId(rs.getInt("id"));
        j.setEmployerId(rs.getInt("employer_id"));
        j.setTitle(rs.getString("title"));
        j.setDescription(rs.getString("description"));
        j.setLocation(rs.getString("location"));
        j.setCategory(rs.getString("category"));
        j.setSalary(rs.getString("salary"));
        j.setType(rs.getString("employment_type"));
        j.setEmailToApply(rs.getString("email_to_apply"));
        j.setActive(rs.getBoolean("is_active"));

        Timestamp c = rs.getTimestamp("created_at");
        Timestamp u = rs.getTimestamp("updated_at");

        j.setCreatedAt(c != null ? c.toString() : null);
        j.setUpdatedAt(u != null ? u.toString() : null);

        return j;
    }

    // Create job
    @Override
    public boolean create(Job job) {

        String sql = "INSERT INTO jobs "
                + "(employer_id, title, description, location, category, employment_type, salary, email_to_apply, is_active) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, job.getEmployerId());
            ps.setString(2, job.getTitle());
            ps.setString(3, job.getDescription());
            ps.setString(4, job.getLocation());
            ps.setString(5, job.getCategory());
            ps.setString(6, job.getType());
            ps.setString(7, job.getSalary());
            ps.setString(8, job.getEmailToApply());
            ps.setBoolean(9, job.isActive());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Get job by ID
    @Override
    public Job getById(int id) {
        String sql = "SELECT * FROM jobs WHERE id=?";

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

    // Get all active jobs
    @Override
    public List<Job> getAll() {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT * FROM jobs WHERE is_active=1 ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Employer's jobs
    @Override
    public List<Job> getByEmployer(int employerId) {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT * FROM jobs WHERE employer_id=? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, employerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Count jobs
    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM jobs";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Search
    @Override
    public List<Job> search(String keyword) {
        List<Job> list = new ArrayList<>();

        String sql = "SELECT * FROM jobs WHERE is_active=1 "
                + "AND (title LIKE ? OR description LIKE ? OR location LIKE ?) "
                + "ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String key = "%" + keyword + "%";

            ps.setString(1, key);
            ps.setString(2, key);
            ps.setString(3, key);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    // Filter
    @Override
    public List<Job> filter(String location, String category, String type, String salary) {

        List<Job> list = new ArrayList<>();

        String sql = "SELECT * FROM jobs WHERE is_active=1 "
                + "AND (? IS NULL OR location = ?) "
                + "AND (? IS NULL OR category = ?) "
                + "AND (? IS NULL OR employment_type = ?) "
                + "AND (? IS NULL OR salary = ?) "
                + "ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, location); ps.setString(2, location);
            ps.setString(3, category); ps.setString(4, category);
            ps.setString(5, type);     ps.setString(6, type);
            ps.setString(7, salary);   ps.setString(8, salary);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    // UPDATE job
    @Override
    public boolean update(Job job) {

        String sql = "UPDATE jobs SET "
                + "title=?, description=?, location=?, category=?, salary=?, "
                + "employment_type=?, email_to_apply=? "
                + "WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, job.getTitle());
            ps.setString(2, job.getDescription());
            ps.setString(3, job.getLocation());
            ps.setString(4, job.getCategory());
            ps.setString(5, job.getSalary());
            ps.setString(6, job.getType());
            ps.setString(7, job.getEmailToApply());
            ps.setInt(8, job.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // DELETE job
    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM jobs WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    // TOGGLE active/inactive
    @Override
    public boolean toggleActive(int id, boolean active) {
        String sql = "UPDATE jobs SET is_active=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, active);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }
}
