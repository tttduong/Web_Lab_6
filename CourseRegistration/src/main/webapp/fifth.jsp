<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Course"%>
<%@page import="model.Student"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang='en'>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Course and Student List</title>
    </head>
    <body>
        <% 
            String courseIdParam = request.getParameter("courseID");
            int courseId = (courseIdParam != null) ? Integer.parseInt(courseIdParam) : 0;

            List<Student> studentsInCourse = new ArrayList<>();
            Course courseDetails = null;
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            String jdbcUrl = "jdbc:mysql://localhost:3306/weblab6?autoReconnect=true&useSSL=false";
            String dbuser = "root";
            String dbpassword = "Shinichi@0";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(jdbcUrl, dbuser, dbpassword);
                String sql = "SELECT sc.StudentID, c.CourseID, s.StudentName, c.CourseName " +
                             "FROM studentcourse sc " +
                             "JOIN course c ON c.CourseID = sc.CourseID " +
                             "JOIN student s ON s.StudentID = sc.StudentID " +
                             "WHERE c.CourseID = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, courseId);
                rs = ps.executeQuery();

                while (rs.next()) {
                    if (courseDetails == null) {
                        int id = rs.getInt("CourseID");
                        String name = rs.getString("CourseName");
                        courseDetails = new Course(id, name);
                    }
                    int studentId = rs.getInt("StudentID");
                    String studentName = rs.getString("StudentName");
                    studentsInCourse.add(new Student(studentId, studentName));
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        %>

        <% if (courseDetails != null) { %>
        <h1>Course's Details</h1>
        <table>
            <tr>
                <td>Course ID</td>
                <td><%= courseDetails.getCourseID() %></td>
            </tr>
            <tr>
                <td>Course Name</td>
                <td><%= courseDetails.getCourseName() %></td>
            </tr>
        </table>
        <% } %>
        <h3>Student List</h3>
        <table>
            <tr>
                <th>Student ID</th>
                <th>Student Name</th>
                <th>Action</th>
            </tr>
            <% for (Student student : studentsInCourse) {%>
            <tr>
                <td><%= student.getStudentID() %></td>
                <td><%= student.getStudentName() %></td>
                <td><a href="ForthPage.jsp?removeStudentID=<%= student.getStudentID() %>">Remove</a></td>
            </tr>
            <% }%>
        </table>
    </body>
</html>
