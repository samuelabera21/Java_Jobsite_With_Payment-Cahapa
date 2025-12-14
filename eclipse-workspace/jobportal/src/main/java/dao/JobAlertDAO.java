package dao;

import models.JobAlert;
import java.util.List;

public interface JobAlertDAO {

    boolean create(JobAlert alert);

    boolean delete(int id);

    JobAlert getById(int id);

    List<JobAlert> getByUser(int userId);

    List<JobAlert> getAll();

}
