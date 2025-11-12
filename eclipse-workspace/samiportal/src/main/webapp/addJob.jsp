<!DOCTYPE html>
<html>
<head>
    <title>Add Job</title>
</head>
<body>

<h2>Add New Job</h2>

<form action="addjob" method="post">

    Title: <input type="text" name="title" required><br><br>

    Description:<br>
    <textarea name="description" rows="5" cols="40" required></textarea><br><br>

    Company: <input type="text" name="company" required><br><br>

    Location: <input type="text" name="location" required><br><br>

    <button type="submit">Post Job</button>

</form>

</body>
</html>
