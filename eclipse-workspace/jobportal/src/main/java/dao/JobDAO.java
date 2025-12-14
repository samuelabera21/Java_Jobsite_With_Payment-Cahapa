//package dao;
//
//import models.Job;
//import java.util.List;
//
//public interface JobDAO {
//
//    boolean create(Job job);
//
//    boolean update(Job job);
//
//    boolean delete(int jobId);
//
//    Job getById(int id);
//
//    List<Job> getAll();
//
//    List<Job> getByEmployer(int employerId);
//
//    List<Job> search(String keyword);
//
//    List<Job> filter(String location, String category);
//
//}

//
//
//package dao;
//
//import models.Job;
//import java.util.List;
//
//public interface JobDAO {
//
//    boolean create(Job job);
//
//    Job getById(int id);
//
//    List<Job> getAll();
//    
//
//    List<Job> getByEmployer(int employerId);
//
//    int countAll();
//}
//


//
//
//package dao;
//
//import models.Job;
//import java.util.List;
//
//public interface JobDAO {
//
//    boolean create(Job job);
//
//    Job getById(int id);
//
//    List<Job> getAll();
//
//    List<Job> getByEmployer(int employerId);
//
//    int countAll();
//}










//
//
//package dao;
//
//import models.Job;
//import java.util.List;
//
//public interface JobDAO {
//
//    boolean create(Job job);
//
//    Job getById(int id);
//
//    List<Job> getAll();
//
//    List<Job> getByEmployer(int employerId);
//
//    int countAll();
//
//    // NEW → Search Jobs by keyword
//    List<Job> search(String keyword);
//}







//
//
//package dao;
//
//import models.Job;
//import java.util.List;
//
//public interface JobDAO {
//
//    boolean create(Job job);
//
//    Job getById(int id);
//
//    List<Job> getAll();
//
//    List<Job> getByEmployer(int employerId);
//
//    int countAll();
//
//    // Search by keyword
//    List<Job> search(String keyword);
//
//    // Filter jobs
//    List<Job> filter(String location, String category, String type, String salary);
//}











//
//
//
//package dao;
//
//import models.Job;
//import java.util.List;
//
//public interface JobDAO {
//
//    boolean create(Job job);
//
//    Job getById(int id);
//
//    List<Job> getAll();
//
//    List<Job> getByEmployer(int employerId);
//
//    int countAll();
//
//    List<Job> search(String keyword);
//
//    List<Job> filter(String location, String category, String type, String salary);
//    
//
//}
//














package dao;

import models.Job;
import java.util.List;

public interface JobDAO {

    boolean create(Job job);

    Job getById(int id);

    List<Job> getAll();

    List<Job> getByEmployer(int employerId);

    int countAll();

    List<Job> search(String keyword);

    List<Job> filter(String location, String category, String type, String salary);

    boolean update(Job job);

    boolean delete(int id);

    boolean toggleActive(int id, boolean active);
}

