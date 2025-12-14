package dao;

import models.Setting;
import java.util.List;

public interface SettingDAO {
    List<Setting> getAll();
    Setting get(String name);
    boolean upsert(Setting s); // insert or update
}
