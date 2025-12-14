//
//
//package models;
//
//public class Job {
//
//    private int id;
//    private int employerId;
//    private String title;
//    private String description;
//    private String location;
//    private String category;
//    private String salary;
//    private String type;         // FULL TIME / PART TIME / REMOTE
//    private String createdAt;
//    private String updatedAt;
//
//    public Job() {}
//
//    public int getId() {
//        return id;
//    }
//
//    public void setId(int id) {
//        this.id = id;
//    }
//
//    public int getEmployerId() {
//        return employerId;
//    }
//
//    public void setEmployerId(int employerId) {
//        this.employerId = employerId;
//    }
//
//    public String getTitle() {
//        return title;
//    }
//
//    public void setTitle(String title) {
//        this.title = title;
//    }
//
//    public String getDescription() {
//        return description;
//    }
//
//    public void setDescription(String description) {
//        this.description = description;
//    }
//
//    public String getLocation() {
//        return location;
//    }
//
//    public void setLocation(String location) {
//        this.location = location;
//    }
//
//    public String getCategory() {
//        return category;
//    }
//
//    public void setCategory(String category) {
//        this.category = category;
//    }
//
//    public String getSalary() {
//        return salary;
//    }
//
//    public void setSalary(String salary) {
//        this.salary = salary;
//    }
//
//    public String getType() {
//        return type;
//    }
//
//    public void setType(String type) {
//        this.type = type;
//    }
//
//    public String getCreatedAt() {
//        return createdAt;
//    }
//
//    public void setCreatedAt(String createdAt) {
//        this.createdAt = createdAt;
//    }
//
//    public String getUpdatedAt() {
//        return updatedAt;
//    }
//
//    public void setUpdatedAt(String updatedAt) {
//        this.updatedAt = updatedAt;
//    }
//}
//
//
//
//
//
//
//
//
//

















package models;

public class Job {

    private int id;
    private int employerId;
    private String title;
    private String description;
    private String location;
    private String category;
    private String salary;
    private String type;               // employment_type column
    private String emailToApply;       // NEW
    private boolean active;            // is_active column
    private String createdAt;
    private String updatedAt;

    public Job() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getEmployerId() {
        return employerId;
    }

    public void setEmployerId(int employerId) {
        this.employerId = employerId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSalary() {
        return salary;
    }

    public void setSalary(String salary) {
        this.salary = salary;
    }

    // employment_type
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    // NEW
    public String getEmailToApply() {
        return emailToApply;
    }

    public void setEmailToApply(String emailToApply) {
        this.emailToApply = emailToApply;
    }

    // NEW
    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }
}



































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
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return list;
//    }
//
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
