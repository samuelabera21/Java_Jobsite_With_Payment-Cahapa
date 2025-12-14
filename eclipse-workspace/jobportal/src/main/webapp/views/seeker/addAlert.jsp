<h2>Create Job Alert</h2>

<form action="${pageContext.request.contextPath}/seeker/addAlert" method="post">

    Keyword: <input type="text" name="keyword" required><br><br>

    Location: <input type="text" name="location"><br><br>

    Category: <input type="text" name="category"><br><br>

    <button type="submit">Create Alert</button>
</form>
