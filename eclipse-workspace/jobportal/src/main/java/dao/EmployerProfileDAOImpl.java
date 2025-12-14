//package dao;
//
//import models.EmployerProfile;
//import util.DBConnection;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class EmployerProfileDAOImpl implements EmployerProfileDAO {
//
//    @Override
//    public boolean createProfile(EmployerProfile profile) {
//        String sql = "INSERT INTO employer_profiles (user_id, company_name, location, website, logo_path, about, is_approved) "
//                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, profile.getUserId());
//            ps.setString(2, profile.getCompanyName());
//            ps.setString(3, profile.getLocation());
//            ps.setString(4, profile.getWebsite());
//            ps.setString(5, profile.getLogoPath());
//            ps.setString(6, profile.getAbout());
//            ps.setBoolean(7, profile.isApproved());
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
//    public boolean updateProfile(EmployerProfile profile) {
//        String sql = "UPDATE employer_profiles SET company_name=?, location=?, website=?, logo_path=?, about=?, is_approved=? WHERE user_id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, profile.getCompanyName());
//            ps.setString(2, profile.getLocation());
//            ps.setString(3, profile.getWebsite());
//            ps.setString(4, profile.getLogoPath());
//            ps.setString(5, profile.getAbout());
//            ps.setBoolean(6, profile.isApproved());
//            ps.setInt(7, profile.getUserId());
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
//    public EmployerProfile getByEmployerId(int employerId) {
//        String sql = "SELECT * FROM employer_profiles WHERE user_id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, employerId);
//
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return extractProfile(rs);
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
//    public List<EmployerProfile> getAllProfiles() {
//        List<EmployerProfile> list = new ArrayList<>();
//        String sql = "SELECT * FROM employer_profiles";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                list.add(extractProfile(rs));
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
//    public boolean approveEmployer(int employerId) {
//        String sql = "UPDATE employer_profiles SET is_approved = TRUE WHERE user_id = ?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, employerId);
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
//    public boolean deleteProfile(int employerId) {
//        String sql = "DELETE FROM employer_profiles WHERE user_id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, employerId);
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return false;
//    }
//
//    private EmployerProfile extractProfile(ResultSet rs) throws Exception {
//        EmployerProfile ep = new EmployerProfile();
//
//        ep.setId(rs.getInt("id"));
//        ep.setUserId(rs.getInt("user_id"));
//        ep.setCompanyName(rs.getString("company_name"));
//        ep.setLocation(rs.getString("location"));
//        ep.setWebsite(rs.getString("website"));
//        ep.setLogoPath(rs.getString("logo_path"));
//        ep.setAbout(rs.getString("about"));
//        ep.setApproved(rs.getBoolean("is_approved"));
//        ep.setCreatedAt(rs.getString("created_at"));
//        ep.setUpdatedAt(rs.getString("updated_at"));
//
//        return ep;
//    }
//}


















package dao;

import models.EmployerProfile;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployerProfileDAOImpl implements EmployerProfileDAO {

    @Override
    public boolean createProfile(EmployerProfile profile) {
        String sql = "INSERT INTO employer_profiles (user_id, company_name, website, bio, address) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, profile.getUserId());
            ps.setString(2, profile.getCompanyName());
            ps.setString(3, profile.getWebsite());
            ps.setString(4, profile.getBio());
            ps.setString(5, profile.getAddress());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateProfile(EmployerProfile profile) {
        String sql = "UPDATE employer_profiles "
                + "SET company_name=?, website=?, bio=?, address=? "
                + "WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, profile.getCompanyName());
            ps.setString(2, profile.getWebsite());
            ps.setString(3, profile.getBio());
            ps.setString(4, profile.getAddress());
            ps.setInt(5, profile.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public EmployerProfile getByEmployerId(int employerId) {
        String sql = "SELECT * FROM employer_profiles WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, employerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return extract(rs);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<EmployerProfile> getAllProfiles() {
        List<EmployerProfile> list = new ArrayList<>();
        String sql = "SELECT * FROM employer_profiles";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(extract(rs));

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean deleteProfile(int employerId) {
        String sql = "DELETE FROM employer_profiles WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, employerId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private EmployerProfile extract(ResultSet rs) throws Exception {
        EmployerProfile ep = new EmployerProfile();

        ep.setId(rs.getInt("id"));
        ep.setUserId(rs.getInt("user_id"));
        ep.setCompanyName(rs.getString("company_name"));
        ep.setWebsite(rs.getString("website"));
        ep.setBio(rs.getString("bio"));
        ep.setAddress(rs.getString("address"));
        ep.setCreatedAt(rs.getString("created_at"));
        ep.setUpdatedAt(rs.getString("updated_at"));

        return ep;
    }
}
