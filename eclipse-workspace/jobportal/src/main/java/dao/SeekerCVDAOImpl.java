//package dao;
//
//import models.SeekerCV;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class SeekerCVDAOImpl implements SeekerCVDAO {
//
//    @Override
//    public boolean create(SeekerCV cv) {
//        String sql = "INSERT INTO seeker_cv (seeker_id, cv_text, cv_file) VALUES (?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, cv.getSeekerId());
//            ps.setString(2, cv.getCvText());
//            ps.setString(3, cv.getCvFile());
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
//    public boolean update(SeekerCV cv) {
//        String sql = "UPDATE seeker_cv SET cv_text=?, cv_file=? WHERE seeker_id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, cv.getCvText());
//            ps.setString(2, cv.getCvFile());
//            ps.setInt(3, cv.getSeekerId());
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
//    public SeekerCV getBySeeker(int seekerId) {
//        String sql = "SELECT * FROM seeker_cv WHERE seeker_id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, seekerId);
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
//    public SeekerCV getById(int id) {
//        String sql = "SELECT * FROM seeker_cv WHERE id=?";
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
//    public List<SeekerCV> getAll() {
//        List<SeekerCV> list = new ArrayList<>();
//        String sql = "SELECT * FROM seeker_cv";
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
//    public boolean delete(int id) {
//        String sql = "DELETE FROM seeker_cv WHERE id=?";
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
//    private SeekerCV extract(ResultSet rs) throws Exception {
//        SeekerCV cv = new SeekerCV();
//
//        cv.setId(rs.getInt("id"));
//        cv.setSeekerId(rs.getInt("seeker_id"));
//        cv.setCvText(rs.getString("cv_text"));
//        cv.setCvFile(rs.getString("cv_file"));
//        cv.setCreatedAt(rs.getString("created_at"));
//        cv.setUpdatedAt(rs.getString("updated_at"));
//
//        return cv;
//    }
//}























//
//package dao;
//
//import models.SeekerCV;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class SeekerCVDAOImpl implements SeekerCVDAO {
//
//    @Override
//    public boolean create(SeekerCV cv) {
//        String sql = "INSERT INTO seeker_cv (user_id, headline, about, education, experience, skills, attachments) " +
//                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, cv.getUserId());
//            ps.setString(2, cv.getHeadline());
//            ps.setString(3, cv.getAbout());
//            ps.setString(4, cv.getEducationJson());
//            ps.setString(5, cv.getExperienceJson());
//            ps.setString(6, cv.getSkillsJson());
//            ps.setString(7, cv.getAttachmentsJson());
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
//    public boolean update(SeekerCV cv) {
//        String sql = "UPDATE seeker_cv SET headline=?, about=?, education=?, experience=?, skills=?, attachments=? WHERE user_id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, cv.getHeadline());
//            ps.setString(2, cv.getAbout());
//            ps.setString(3, cv.getEducationJson());
//            ps.setString(4, cv.getExperienceJson());
//            ps.setString(5, cv.getSkillsJson());
//            ps.setString(6, cv.getAttachmentsJson());
//            ps.setInt(7, cv.getUserId());
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
//    public SeekerCV getByUserId(int userId) {
//        String sql = "SELECT * FROM seeker_cv WHERE user_id = ?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, userId);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) return extract(rs);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    @Override
//    public SeekerCV getById(int id) {
//        String sql = "SELECT * FROM seeker_cv WHERE id = ?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) return extract(rs);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    @Override
//    public List<SeekerCV> getAll() {
//        List<SeekerCV> list = new ArrayList<>();
//        String sql = "SELECT * FROM seeker_cv ORDER BY saved_at DESC";
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
//    @Override
//    public boolean delete(int id) {
//        String sql = "DELETE FROM seeker_cv WHERE id = ?";
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
//    private SeekerCV extract(ResultSet rs) throws Exception {
//        SeekerCV cv = new SeekerCV();
//
//        cv.setId(rs.getInt("id"));
//        cv.setUserId(rs.getInt("user_id"));
//        cv.setHeadline(rs.getString("headline"));
//        cv.setAbout(rs.getString("about"));
//        cv.setEducationJson(rs.getString("education"));
//        cv.setExperienceJson(rs.getString("experience"));
//        cv.setSkillsJson(rs.getString("skills"));
//        cv.setAttachmentsJson(rs.getString("attachments"));
//        cv.setSavedAt(rs.getString("saved_at"));
//        cv.setUpdatedAt(rs.getString("updated_at"));
//
//        return cv;
//    }
//}


















package dao;

import models.SeekerCV;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SeekerCVDAOImpl implements SeekerCVDAO {

    @Override
    public boolean create(SeekerCV cv) {
        String sql = "INSERT INTO seeker_cv "
                + "(user_id, headline, about, education, experience, skills, attachments) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cv.getUserId());
            ps.setString(2, cv.getHeadline());
            ps.setString(3, cv.getAbout());
            ps.setString(4, cv.getEducation());
            ps.setString(5, cv.getExperience());
            ps.setString(6, cv.getSkills());
            ps.setString(7, cv.getAttachments());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean update(SeekerCV cv) {
        String sql = "UPDATE seeker_cv SET "
                + "headline=?, about=?, education=?, experience=?, skills=?, attachments=? "
                + "WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, cv.getHeadline());
            ps.setString(2, cv.getAbout());
            ps.setString(3, cv.getEducation());
            ps.setString(4, cv.getExperience());
            ps.setString(5, cv.getSkills());
            ps.setString(6, cv.getAttachments());
            ps.setInt(7, cv.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public SeekerCV getByUserId(int userId) {
        String sql = "SELECT * FROM seeker_cv WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next())
                return extract(rs);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private SeekerCV extract(ResultSet rs) throws Exception {
        SeekerCV cv = new SeekerCV();

        cv.setId(rs.getInt("id"));
        cv.setUserId(rs.getInt("user_id"));
        cv.setHeadline(rs.getString("headline"));
        cv.setAbout(rs.getString("about"));
        cv.setEducation(rs.getString("education"));
        cv.setExperience(rs.getString("experience"));
        cv.setSkills(rs.getString("skills"));
        cv.setAttachments(rs.getString("attachments"));
        cv.setSavedAt(rs.getString("saved_at"));
        cv.setUpdatedAt(rs.getString("updated_at"));

        return cv;
    }

    @Override
    public List<SeekerCV> getAll() {
        return new ArrayList<>();
    }

    @Override
    public SeekerCV getById(int id) { return null; }

    @Override
    public boolean delete(int id) { return false; }
}
