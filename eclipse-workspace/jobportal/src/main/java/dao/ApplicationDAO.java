//package dao;
//
//import models.Application;
//import java.util.List;
//
//public interface ApplicationDAO {
//
//    boolean apply(Application application);
//
//    List<Application> getByJob(int jobId);
//
//    List<Application> getByUser(int userId);
//
//    List<Application> getAll();
//
//    Application getById(int id);
//
//    boolean updateStatus(int id, String status);
//
//    boolean delete(int id);
//}




//
//package dao;
//
//import models.Application;
//import java.util.List;
//
//public interface ApplicationDAO {
//
//    boolean create(Application app);
//
//    Application getById(int id);
//
//    List<Application> getAll();
//
//    List<Application> getByJob(int jobId);
//
//    List<Application> getBySeeker(int seekerId);
//
//    List<Application> getByEmployer(int employerId);
//
//    int countAll();
//}









//
//
//
//
//package dao;
//
//import models.Application;
//import java.util.List;
//
//public interface ApplicationDAO {
//
//    boolean create(Application app);
//
//    Application getById(int id);
//
//    List<Application> getAll();
//
//    List<Application> getByJob(int jobId);
//
//    List<Application> getBySeeker(int seekerId);
//
//    List<Application> getByEmployer(int employerId);
//
//    int countAll();
//}














package dao;

import models.Application;
import java.util.List;

public interface ApplicationDAO {

    boolean create(Application app);

    Application getById(int id);

    List<Application> getAll();

    List<Application> getByJob(int jobId);

    List<Application> getBySeeker(int seekerId);

    List<Application> getByEmployer(int employerId);

    boolean updateStatus(int id, String status);

    int countAll();
}
