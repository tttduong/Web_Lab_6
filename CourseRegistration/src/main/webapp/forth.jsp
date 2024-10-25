<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Course"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Course List</title>
    </head>
    <body>
        <%
            List<Course> allCourses = new ArrayList<>();
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            String jdbcUrl = "jdbc:mysql://localhost:3306/weblab6?autoReconnect=true&useSSL=false";
            String dbuser = "root";
            String dbpassword = "Shinichi@0";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(jdbcUrl, dbuser, dbpassword);
                String sql = "SELECT * FROM course";
                ps = con.prepareStatement(sql);
                rs = ps.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("CourseID");
                    String name = rs.getString("CourseName");
                    allCourses.add(new Course(id, name));
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
            String removeCourseID = request.getParameter("removeCourseID");
            if (removeCourseID != null) {
                try {
                    con = DriverManager.getConnection(jdbcUrl, dbuser, dbpassword);
                    String deleteSql = "DELETE FROM course WHERE CourseID = ?";
                    ps = con.prepareStatement(deleteSql);
                    ps.setInt(1, Integer.parseInt(removeCourseID));
                    ps.executeUpdate();
                    response.sendRedirect("forth.jsp"); 
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            }
            String newCourseID = request.getParameter("newCourseID");
            String newCourseName = request.getParameter("newCourseName");
            if (newCourseID != null && newCourseName != null) {
                try {
                    con = DriverManager.getConnection(jdbcUrl, dbuser, dbpassword);
                    String insertSql = "INSERT INTO course (CourseID, CourseName) VALUES (?, ?)";
                    ps = con.prepareStatement(insertSql);
                    ps.setInt(1, Integer.parseInt(newCourseID));
                    ps.setString(2, newCourseName);
                    ps.executeUpdate();
                    response.sendRedirect("forth.jsp"); 
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            }
        %>
        
        <h1>Course List</h1>
        <table>
            <tr>
                <th>Course ID</th>
                <th>Course Name</th>
                <th>Action</th>
            </tr>
            <% for (Course course : allCourses) {%>
            <tr>
                <td><%= course.getCourseID() %></td>
                <td><a href="fifth.jsp?courseID=<%= course.getCourseID() %>"><%= course.getCourseName() %></a> </td>
                <td>
                    <a href="EditStudent.jsp?courseID=<%= course.getCourseID() %>">Edit</a>
                    <a href="forth.jsp?removeCourseID=<%= course.getCourseID() %>">Delete</a>
                </td>
            </tr>
            <%}%>
        </table>
        <h2>Add New Course</h2>
        <form action="forth.jsp" method="post">
            <label for="newCourseID">Course ID:</label>
            <input type="text" name="newCourseID" id="newCourseID" required>
            <br>
            <label for="newCourseName">Course Name:</label>
            <input type="text" name="newCourseName" id="newCourseName" required>
            <br>
            <input type="submit" value="Add">
        </form>
        <hr>
        <a href="home.jsp">homepage</a>
    </body>
</html>
