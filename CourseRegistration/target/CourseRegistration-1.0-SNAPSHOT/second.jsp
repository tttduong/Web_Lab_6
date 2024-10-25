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
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Courses Registration</title>
    </head>
    <body>

        <%
          
            String studentIDParam = request.getParameter("studentID");
            Student student = (Student) session.getAttribute("student");

            if (studentIDParam != null && student == null) {
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String jdbcUrl = "jdbc:mysql://localhost:3306/weblab6?autoReconnect=true&useSSL=false";
                    String dbuser = "root";
                    String dbpassword = "Shinichi@0";

                    con = DriverManager.getConnection(jdbcUrl, dbuser, dbpassword);
                    String sql = "SELECT * FROM student WHERE StudentID = ?";
                    ps = con.prepareStatement(sql);
                    ps.setString(1, studentIDParam);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        int id = rs.getInt("StudentID");
                        String name = rs.getString("StudentName");
                        student = new Student(id, name);
                        session.setAttribute("student", student); 
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            }

            List<Course> allCourses = new ArrayList<>();
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String jdbcUrl = "jdbc:mysql://localhost:3306/weblab6?autoReconnect=true&useSSL=false";
                String dbuser = "root";
                String dbpassword = "Shinichi@0";

                con = DriverManager.getConnection(jdbcUrl, dbuser, dbpassword);
                String sql = "SELECT * FROM course";
                ps = con.prepareStatement(sql);
                rs = ps.executeQuery();

                while (rs.next()) {
                    int courseID = rs.getInt("CourseID");
                    String courseName = rs.getString("CourseName");
                    allCourses.add(new Course(courseID, courseName));
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }

            List<Course> registeredCourses = (List<Course>) session.getAttribute("registeredCourses");
            if (registeredCourses == null) {
                registeredCourses = new ArrayList<>(); 
            }

            String courseIdStr = request.getParameter("courseID");
            if (courseIdStr != null) {
                int courseId = Integer.parseInt(courseIdStr);
              
                boolean alreadyRegistered = false;
                for (Course course : registeredCourses) {
                    if (course.getCourseID() == courseId) {
                        alreadyRegistered = true;
                        break; 
                    }
                }

                if (!alreadyRegistered) {
                    for (Course course : allCourses) {
                        if (course.getCourseID() == courseId) {
                            registeredCourses.add(course);
                            break;
                        }
                    }
                    session.setAttribute("registeredCourses", registeredCourses); 
                }
            }

            if (student != null) {
        %>
        <h1>Student's Detail</h1> 
        <div>Student ID: <%= student.getStudentID() %></div> 
        <div>Student Name: <%= student.getStudentName() %></div> 

        <h3>Select Course</h3>
        <form action="second.jsp" method="post">
            <label>Select Course:</label>
            <select name="courseID">
                <% 
                    for (Course course : allCourses) {
                %>
                <option value="<%= course.getCourseID() %>"><%= course.getCourseName() %></option>
                <% 
                    }
                %>
            </select>
            <input type="submit" value="Add">
        </form>

        <h4>Registered Courses</h4>
        <table>
            <tr>
                <th>Course ID</th>
                <th>Course Name</th>
                <th>Action</th>
            </tr>
            <% 
                for (Course course : registeredCourses) {
            %>
            <tr>
                <td><%= course.getCourseID() %></td>
                <td><%= course.getCourseName() %></td>
                <td><a href="second.jsp?removeCourseID=<%= course.getCourseID() %>">Remove</a></td>
            </tr>
            <% 
                }
            %>
        </table>
        <%
            }
        %>
        <hr>
        <a href="home.jsp">homepage</a>
    </body>
</html>
