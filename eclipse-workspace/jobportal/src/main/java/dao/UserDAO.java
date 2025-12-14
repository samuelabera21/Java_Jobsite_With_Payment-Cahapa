//package dao;
//
//import models.User;
//import java.util.List;
//
//public interface UserDAO {
//
//    boolean register(User user);
//
//    User login(String email, String password);
//
//    User getById(int id);
//
//    User getByEmail(String email);
//
//    List<User> getAllUsers();
//
//    boolean update(User user);
//
//    boolean delete(int id);
//}


//package dao;
//
//import models.User;
//import java.util.List;
//
//public interface UserDAO {
//
//    boolean create(User user);
//
//    User getByEmailAndPassword(String email, String password);
//
//    User getById(int id);
//
//    List<User> getAll();
//
//    List<User> getPendingEmployers();
//
//    boolean approveEmployer(int id);
//
//    int countAll();
//
//    int countPendingEmployers();
//    
//
//}
//
//
//package dao;
//
//import models.User;
//import java.util.List;
//
//public interface UserDAO {
//
//    // find user by id
//    User findById(int id);
//
//    // update profile fields (name, email, phone, avatar)
//    boolean update(User user);
//
//    // change password
//    boolean changePassword(int userId, String newPassword);
//
//    // FOR LOGIN: (You already have this in your project)
//    User login(String email, String password);
//
//    // OPTIONAL:
//    boolean updateAvatar(int userId, String avatarPath);
//}
//
















//
//
//package dao;
//
//import models.User;
//import java.util.List;
//
//public interface UserDAO {
//
//    // ---- BASIC (used by login/register) ----
//    boolean create(User user);
//    User getByEmailAndPassword(String email, String password);
//    User getById(int id);
//
//    // ---- ADMIN USE ----
//    List<User> getAll();
//    List<User> getPendingEmployers();
//    boolean approveEmployer(int id);
//    int countAll();
//    int countPendingEmployers();
//
//    // ---- NEW FEATURES FOR SEEKER PROFILE ----
//    User findById(int id);
//    boolean update(User user);
//    boolean changePassword(int userId, String newPassword);
//    boolean updateAvatar(int userId, String avatarPath);
//    User login(String email, String password);
//    boolean adminUpdate(User user);
//    boolean delete(int id);
//
//    // ---- NEW: ACTIVE / DEACTIVE USER ----
//    boolean activateUser(int id);        // set status = 'active'
//    boolean deactivateUser(int id);      // set status = 'suspended'
//}
//






package dao;

import models.User;
import java.util.List;

public interface UserDAO {

    // ---- BASIC ----
    boolean create(User user);
    User getByEmailAndPassword(String email, String password);
    User getById(int id);

    // ---- ADMIN ----
    List<User> getAll();
    List<User> getPendingEmployers();
    boolean approveEmployer(int id);
    int countAll();
    int countPendingEmployers();

    // ---- NEW ----
    User findById(int id);
    boolean update(User user);
    boolean changePassword(int userId, String newPassword);
    boolean updateAvatar(int userId, String avatarPath);
    User login(String email, String password);
    boolean adminUpdate(User user);
    boolean delete(int id);

    boolean activateUser(int id);
    boolean deactivateUser(int id);

    // ⭐⭐⭐ ADD THIS NEW METHOD ⭐⭐⭐
    List<User> getUsersByRole(String role);
}
