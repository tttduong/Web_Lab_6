package Servlet;

import model.Student;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/StudentController")
public class StudentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studentID = request.getParameter("studentID");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Database connection details
            Class.forName("com.mysql.cj.jdbc.Driver");
            String jdbcUrl = "jdbc:mysql://localhost:3306/weblab6?autoReconnect=true&useSSL=false";
            String dbUser = "root";
            String dbPassword = "Shinichi@0";

            // Initialize database connection
            con = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

            // SQL query to retrieve student details
            String sql = "SELECT * FROM student WHERE StudentID = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, studentID);
            rs = ps.executeQuery();

            // Check if student exists
            if (rs.next()) {
                // Create a Student object and set its properties
                Student student = new Student();
                student.setStudentID(rs.getInt("StudentID"));
                student.setStudentName(rs.getString("StudentName"));

                // Store the student object in request scope
                request.setAttribute("student", student);

                // Forward the request to display the student information
                request.getRequestDispatcher("second.jsp").forward(request, response);
            } else {
                // If student not found, display an error message
                request.setAttribute("errorMessage", "Student not found.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            // Log the exception and forward to error page
            response.getWriter().println("An error occurred: " + e.getMessage());
            request.setAttribute("errorMessage", "Database error.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(StudentController.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            // Ensure resources are closed
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                response.getWriter().println("An error occurred while closing resources: " + e.getMessage());
            }
        }
    }
}
