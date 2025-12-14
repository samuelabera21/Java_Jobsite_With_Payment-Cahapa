//package dao;
//
//import models.User;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class UserDAOImpl implements UserDAO {
//
//    @Override
//    public boolean register(User user) {
//        String sql = "INSERT INTO users(name, email, password, role, status, phone, avatar_path) VALUES (?, ?, ?, ?, ?, ?, ?)";
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, user.getName());
//            ps.setString(2, user.getEmail());
//            ps.setString(3, user.getPassword());   // hashed later
//            ps.setString(4, user.getRole());
//            ps.setString(5, user.getStatus());
//            ps.setString(6, user.getPhone());
//            ps.setString(7, user.getAvatarPath());
//
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//    @Override
//    public User login(String email, String password) {
//        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, email);
//            ps.setString(2, password);
//
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return extractUser(rs);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    @Override
//    public User getById(int id) {
//        String sql = "SELECT * FROM users WHERE id = ?";
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return extractUser(rs);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    @Override
//    public User getByEmail(String email) {
//        String sql = "SELECT * FROM users WHERE email = ?";
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, email);
//
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return extractUser(rs);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    @Override
//    public List<User> getAllUsers() {
//        List<User> list = new ArrayList<>();
//        String sql = "SELECT * FROM users";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                list.add(extractUser(rs));
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
//    public boolean update(User user) {
//        String sql = "UPDATE users SET name=?, email=?, password=?, role=?, status=?, phone=?, avatar_path=? WHERE id=?";
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, user.getName());
//            ps.setString(2, user.getEmail());
//            ps.setString(3, user.getPassword());
//            ps.setString(4, user.getRole());
//            ps.setString(5, user.getStatus());
//            ps.setString(6, user.getPhone());
//            ps.setString(7, user.getAvatarPath());
//            ps.setInt(8, user.getId());
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
//    public boolean delete(int id) {
//        String sql = "DELETE FROM users WHERE id=?";
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//    // Helper method to convert ResultSet → User object
//    private User extractUser(ResultSet rs) throws Exception {
//        User u = new User();
//        u.setId(rs.getInt("id"));
//        u.setName(rs.getString("name"));
//        u.setEmail(rs.getString("email"));
//        u.setPassword(rs.getString("password"));
//        u.setRole(rs.getString("role"));
//        u.setStatus(rs.getString("status"));
//        u.setPhone(rs.getString("phone"));
//        u.setAvatarPath(rs.getString("avatar_path"));
//        u.setCreatedAt(rs.getString("created_at"));
//        u.setUpdatedAt(rs.getString("updated_at"));
//        return u;
//    }
//}





//
//
////
////
//package dao;
//
//import models.User;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class UserDAOImpl implements UserDAO {
//
//    private User extract(ResultSet rs) throws Exception {
//        User u = new User();
//        u.setId(rs.getInt("id"));
//        u.setName(rs.getString("name"));
//        u.setEmail(rs.getString("email"));
//        u.setPassword(rs.getString("password"));
//        u.setRole(rs.getString("role"));
//        u.setStatus(rs.getString("status"));
//        u.setCreatedAt(rs.getString("created_at"));
//        return u;
//    }
//
//    @Override
//    public boolean create(User user) {
//        String sql = "INSERT INTO users (name, email, password, role, status) VALUES (?, ?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, user.getName());
//            ps.setString(2, user.getEmail());
//            ps.setString(3, user.getPassword());
//            ps.setString(4, user.getRole());
//            ps.setString(5, user.getStatus());
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
//    public User getByEmailAndPassword(String email, String password) {
//        String sql = "SELECT * FROM users WHERE email=? AND password=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, email);
//            ps.setString(2, password);
//
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
//    public User getById(int id) {
//        String sql = "SELECT * FROM users WHERE id=?";
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
//    public List<User> getAll() {
//        List<User> list = new ArrayList<>();
//        String sql = "SELECT * FROM users ORDER BY created_at DESC";
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
//    public List<User> getPendingEmployers() {
//        List<User> list = new ArrayList<>();
//        String sql = "SELECT * FROM users WHERE role='employer' AND status='pending'";
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
//    public boolean approveEmployer(int id) {
//        String sql = "UPDATE users SET status='approved' WHERE id=?";
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
//    @Override
//    public int countAll() {
//        String sql = "SELECT COUNT(*) FROM users";
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
//    @Override
//    public int countPendingEmployers() {
//        String sql = "SELECT COUNT(*) FROM users WHERE role='employer' AND status='pending'";
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
//
//
//package dao;
//
//import models.User;
//import util.DBConnection;
//
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//
//public class UserDAOImpl implements UserDAO {
//
//    @Override
//    public User findById(int id) {
//        String sql = "SELECT * FROM users WHERE id = ?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                User u = new User();
//                u.setId(rs.getInt("id"));
//                u.setName(rs.getString("name"));
//                u.setEmail(rs.getString("email"));
//                u.setPassword(rs.getString("password"));
//                u.setRole(rs.getString("role"));
//                u.setStatus(rs.getString("status"));
//                u.setPhone(rs.getString("phone"));
//                u.setAvatarPath(rs.getString("avatar_path"));
//                u.setCreatedAt(rs.getString("created_at"));
//                u.setUpdatedAt(rs.getString("updated_at"));
//                return u;
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//
//    @Override
//    public boolean update(User user) {
//
//        String sql = "UPDATE users SET name=?, email=?, phone=?, avatar_path=? WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, user.getName());
//            ps.setString(2, user.getEmail());
//            ps.setString(3, user.getPhone());
//            ps.setString(4, user.getAvatarPath());
//            ps.setInt(5, user.getId());
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
//    public boolean changePassword(int userId, String newPassword) {
//
//        String sql = "UPDATE users SET password=? WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, newPassword);
//            ps.setInt(2, userId);
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
//    public boolean updateAvatar(int userId, String avatarPath) {
//
//        String sql = "UPDATE users SET avatar_path=? WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, avatarPath);
//            ps.setInt(2, userId);
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
//    // Already exists in your system; included for completeness.
//    @Override
//    public User login(String email, String password) {
//        String sql = "SELECT * FROM users WHERE email=? AND password=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, email);
//            ps.setString(2, password);
//
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                User u = new User();
//                u.setId(rs.getInt("id"));
//                u.setName(rs.getString("name"));
//                u.setEmail(rs.getString("email"));
//                u.setPassword(rs.getString("password"));
//                u.setRole(rs.getString("role"));
//                u.setStatus(rs.getString("status"));
//                u.setPhone(rs.getString("phone"));
//                u.setAvatarPath(rs.getString("avatar_path"));
//                u.setCreatedAt(rs.getString("created_at"));
//                u.setUpdatedAt(rs.getString("updated_at"));
//                return u;
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//}
















package dao;

import models.User;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {

    // Extract user from ResultSet
    private User extract(ResultSet rs) throws Exception {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setPhone(rs.getString("phone"));
        u.setAvatarPath(rs.getString("avatar_path"));
        u.setCreatedAt(rs.getString("created_at"));
        u.setUpdatedAt(rs.getString("updated_at"));
        return u;
    }

    // ---------------- BASIC FUNCTIONS -------------------

    @Override
    public boolean create(User user) {
        String sql = "INSERT INTO users (name, email, password, role, status, phone, avatar_path) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getStatus());
            ps.setString(6, user.getPhone());
            ps.setString(7, user.getAvatarPath());

            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    @Override
    public User getByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM users WHERE email=? AND password=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extract(rs);

        } catch (Exception e) { e.printStackTrace(); }

        return null;
    }

    @Override
    public User login(String email, String password) {
        return getByEmailAndPassword(email, password);
    }

    @Override
    public User getById(int id) {
        return findById(id);
    }

    @Override
    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return extract(rs);

        } catch (Exception e) { e.printStackTrace(); }

        return null;
    }

    // ---------------- ADMIN FUNCTIONS -------------------

    @Override
    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    @Override
    public List<User> getPendingEmployers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role='employer' AND status='pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    @Override
    public boolean approveEmployer(int id) {
        String sql = "UPDATE users SET status='approved' WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM users";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) { e.printStackTrace(); }

        return 0;
    }

    @Override
    public int countPendingEmployers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role='employer' AND status='pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) { e.printStackTrace(); }

        return 0;
    }

    // ---------------- NEW SEEKER FEATURES -------------------

    @Override
    public boolean update(User user) {

        String sql = "UPDATE users SET name=?, email=?, phone=?, avatar_path=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getAvatarPath());
            ps.setInt(5, user.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    @Override
    public boolean changePassword(int userId, String newPassword) {

        String sql = "UPDATE users SET password=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    @Override
    public boolean updateAvatar(int userId, String avatarPath) {

        String sql = "UPDATE users SET avatar_path=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, avatarPath);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }
    
    @Override
    public boolean delete(int id) {

        String sql = "DELETE FROM users WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    
    
    @Override
    public boolean adminUpdate(User user) {

        String sql = "UPDATE users SET name=?, email=?, role=?, status=?, phone=?, avatar_path=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getStatus());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getAvatarPath());
            ps.setInt(7, user.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    
    
    @Override
    public boolean deactivateUser(int id) {
        String sql = "UPDATE users SET status='suspended' WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    @Override
    public boolean activateUser(int id) {

        // Step 1 — Fetch user role first
        User user = findById(id);
        if (user == null) return false;

        String newStatus;

        // If EMPLOYER → restore to APPROVED (not active)
        if ("employer".equalsIgnoreCase(user.getRole())) {
            newStatus = "approved";
        }
        // If SEEKER or ADMIN → normal active
        else {
            newStatus = "active";
        }

        String sql = "UPDATE users SET status=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    
    
    
    @Override
    public List<User> getUsersByRole(String role) {
        List<User> list = new ArrayList<>();

        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extract(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }



    
    
    
}
