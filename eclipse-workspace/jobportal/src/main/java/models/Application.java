//package models;
//
//public class Application {
//
//    private int id;
//    private int jobId;        // FK → jobs.id
//    private int seekerId;     // FK → users.id (job seeker)
//    private String coverLetter;
//    private String status;     // pending / approved / rejected
//    private String createdAt;  // auto timestamp
//    private String updatedAt;  // auto timestamp
//
//    public Application() {}
//
//    // --- GETTERS & SETTERS ---
//
//    public int getId() {
//        return id;
//    }
//
//    public void setId(int id) {
//        this.id = id;
//    }
//
//    public int getJobId() {
//        return jobId;
//    }
//
//    public void setJobId(int jobId) {
//        this.jobId = jobId;
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
//    public String getCoverLetter() {
//        return coverLetter;
//    }
//
//    public void setCoverLetter(String coverLetter) {
//        this.coverLetter = coverLetter;
//    }
//
//    public String getStatus() {
//        return status;
//    }
//
//    public void setStatus(String status) {
//        this.status = status;
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
//
//
//
//
//
//
//
//
//
//
//package models;
//
//public class Application {
//
//    private int id;
//    private int jobId;        // FK → jobs.id
//    private int seekerId;     // FK → users.id (job seeker)
//    private String coverLetter;
//    private String status;     // pending / approved / rejected
//    private String appliedAt;  // correct timestamp field from DB
//    private String updatedAt;  // if exists (optional)
//
//    public Application() {}
//
//    // --- GETTERS & SETTERS ---
//
//    public int getId() {
//        return id;
//    }
//
//    public void setId(int id) {
//        this.id = id;
//    }
//
//    public int getJobId() {
//        return jobId;
//    }
//
//    public void setJobId(int jobId) {
//        this.jobId = jobId;
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
//    public String getCoverLetter() {
//        return coverLetter;
//    }
//
//    public void setCoverLetter(String coverLetter) {
//        this.coverLetter = coverLetter;
//    }
//
//    public String getStatus() {
//        return status;
//    }
//
//    public void setStatus(String status) {
//        this.status = status;
//    }
//
//    public String getAppliedAt() {
//        return appliedAt;
//    }
//
//    public void setAppliedAt(String appliedAt) {
//        this.appliedAt = appliedAt;
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






















package models;

public class Application {

    private int id;
    private int jobId;
    private int seekerId;
    private String message;       // DB: message
    private String cvPath;        // DB: cv_path
    private String status;        // pending / approved / rejected
    private String appliedAt;     // DB: applied_at

    public Application() {}

    // GETTERS & SETTERS
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getJobId() { return jobId; }
    public void setJobId(int jobId) { this.jobId = jobId; }

    public int getSeekerId() { return seekerId; }
    public void setSeekerId(int seekerId) { this.seekerId = seekerId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getCvPath() { return cvPath; }
    public void setCvPath(String cvPath) { this.cvPath = cvPath; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAppliedAt() { return appliedAt; }
    public void setAppliedAt(String appliedAt) { this.appliedAt = appliedAt; }
}

