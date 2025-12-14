//package dao;
//
//import models.EmployerProfile;
//import java.util.List;
//
//public interface EmployerProfileDAO {
//
//    boolean createProfile(EmployerProfile profile);
//
//    boolean updateProfile(EmployerProfile profile);
//
//    EmployerProfile getByEmployerId(int employerId);
//
//    List<EmployerProfile> getAllProfiles();
//
//    boolean approveEmployer(int employerId);
//
//    boolean deleteProfile(int employerId);
//}




package dao;

import models.EmployerProfile;
import java.util.List;

public interface EmployerProfileDAO {

    boolean createProfile(EmployerProfile profile);

    boolean updateProfile(EmployerProfile profile);

    EmployerProfile getByEmployerId(int employerId);

    List<EmployerProfile> getAllProfiles();

    boolean deleteProfile(int employerId);
}
