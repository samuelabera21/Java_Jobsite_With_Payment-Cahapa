package dao;

import models.CVTemplate;
import java.util.List;

public interface CVTemplateDAO {

    boolean create(CVTemplate template);

    boolean update(CVTemplate template);

    boolean delete(int id);

    CVTemplate getById(int id);

    List<CVTemplate> getAll();
}
