//package models;
//
//public class SeekerCV {
//
//    private int id;
//    private int seekerId;
//    private String cvText;
//    private String cvFile;
//    private String createdAt;
//    private String updatedAt;
//
//    public SeekerCV() {}
//
//    public int getId() {
//        return id;
//    }
//
//    public void setId(int id) {
//        this.id = id;
//    }
//
//    public int getSeekerId() {
//        return seekerId;
//    }
//
//    public void setSeekerId(int seekerId) {
//        this.seekerId = seekerId;
//    }
//
//    public String getCvText() {
//        return cvText;
//    }
//
//    public void setCvText(String cvText) {
//        this.cvText = cvText;
//    }
//
//    public String getCvFile() {
//        return cvFile;
//    }
//
//    public void setCvFile(String cvFile) {
//        this.cvFile = cvFile;
//    }
//
//    public String getCreatedAt() {
//        return createdAt;
//    }
//
//    public void setCreatedAt(String createdAt) {
//        this.createdAt = createdAt;
//    }
//
//    public String getUpdatedAt() {
//        return updatedAt;
//    }
//
//    public void setUpdatedAt(String updatedAt) {
//        this.updatedAt = updatedAt;
//    }
//}
























//
//
//
//
//package models;
//
//public class SeekerCV {
//
//    private int id;
//    private int userId;          // matches DB user_id
//    private String headline;
//    private String about;
//    private String educationJson;   // JSON string (array)
//    private String experienceJson;  // JSON string (array)
//    private String skillsJson;      // JSON string (array)
//    private String attachmentsJson; // JSON string (array of file paths)
//    private String savedAt;
//    private String updatedAt;
//
//    public SeekerCV() {}
//
//    // getters / setters
//    public int getId() { return id; }
//    public void setId(int id) { this.id = id; }
//
//    public int getUserId() { return userId; }
//    public void setUserId(int userId) { this.userId = userId; }
//
//    public String getHeadline() { return headline; }
//    public void setHeadline(String headline) { this.headline = headline; }
//
//    public String getAbout() { return about; }
//    public void setAbout(String about) { this.about = about; }
//
//    public String getEducationJson() { return educationJson; }
//    public void setEducationJson(String educationJson) { this.educationJson = educationJson; }
//
//    public String getExperienceJson() { return experienceJson; }
//    public void setExperienceJson(String experienceJson) { this.experienceJson = experienceJson; }
//
//    public String getSkillsJson() { return skillsJson; }
//    public void setSkillsJson(String skillsJson) { this.skillsJson = skillsJson; }
//
//    public String getAttachmentsJson() { return attachmentsJson; }
//    public void setAttachmentsJson(String attachmentsJson) { this.attachmentsJson = attachmentsJson; }
//
//    public String getSavedAt() { return savedAt; }
//    public void setSavedAt(String savedAt) { this.savedAt = savedAt; }
//
//    public String getUpdatedAt() { return updatedAt; }
//    public void setUpdatedAt(String updatedAt) { this.updatedAt = updatedAt; }
//}































package models;

public class SeekerCV {

    private int id;
    private int userId;
    private String headline;
    private String about;
    private String education;
    private String experience;
    private String skills;
    private String attachments;
    private String savedAt;
    private String updatedAt;

    // Getters/Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getHeadline() { return headline; }
    public void setHeadline(String headline) { this.headline = headline; }

    public String getAbout() { return about; }
    public void setAbout(String about) { this.about = about; }

    public String getEducation() { return education; }
    public void setEducation(String education) { this.education = education; }

    public String getExperience() { return experience; }
    public void setExperience(String experience) { this.experience = experience; }

    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }

    public String getAttachments() { return attachments; }
    public void setAttachments(String attachments) { this.attachments = attachments; }

    public String getSavedAt() { return savedAt; }
    public void setSavedAt(String savedAt) { this.savedAt = savedAt; }

    public String getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(String updatedAt) { this.updatedAt = updatedAt; }
}
