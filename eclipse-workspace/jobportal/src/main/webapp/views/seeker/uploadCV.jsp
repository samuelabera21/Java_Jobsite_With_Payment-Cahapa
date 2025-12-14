<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Upload CV</title>
</head>
<body>

<h2>Upload Your CV</h2>

<form action="<%= request.getContextPath() %>/uploadCV" 
      method="post" enctype="multipart/form-data">

    <label>Select CV (PDF only):</label><br>
    <input type="file" name="cv_file" accept="application/pdf" required><br><br>

    <label>Optional CV Text:</label><br>
    <textarea name="cv_text" rows="6" cols="60"></textarea><br><br>

    <button type="submit">Upload</button>
</form>

<br>
<a href="<%= request.getContextPath() %>/seeker/dashboard">Back to Dashboard</a>

</body>
</html>
