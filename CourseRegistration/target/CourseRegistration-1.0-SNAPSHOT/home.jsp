<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="model.Student"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Register Page</title>
</head>
<body>
    <h1>Course Registration Demo</h1>
    <form action="${pageContext.request.contextPath}/StudentController" method="post">
        Student ID: <input type="text" name="studentID" required>
        <input type="submit" value="Submit"> 
    </form>    

    <h3>Manager</h3>
    <a href="third.jsp">Students Manager</a><br>
    <a href="forth.jsp">Course Manager</a>
</body>
</html>
