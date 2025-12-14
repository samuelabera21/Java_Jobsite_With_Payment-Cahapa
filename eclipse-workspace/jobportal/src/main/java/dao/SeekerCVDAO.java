//package dao;
//
//import models.SeekerCV;
//import java.util.List;
//
//public interface SeekerCVDAO {
//
//    boolean create(SeekerCV cv);
//
//    boolean update(SeekerCV cv);
//
//    SeekerCV getBySeeker(int seekerId);
//
//    SeekerCV getById(int id);
//
//    List<SeekerCV> getAll();
//
//    boolean delete(int id);
//}



package dao;

import models.SeekerCV;
import java.util.List;

public interface SeekerCVDAO {
    boolean create(SeekerCV cv);
    boolean update(SeekerCV cv);
    SeekerCV getByUserId(int userId);
    SeekerCV getById(int id);
    List<SeekerCV> getAll();
    boolean delete(int id);
}
