<%@page import="model.User"%> 
<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!DOCTYPE html> 
<html> 
    <head> 
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
        <title>JSP Page</title> 
    </head> 
    <body> 
        <% 
            User u = (User) session.getAttribute("user1"); 
            if (u != null) { 
        %> 
            <h1>User Record</h1> 
            <div>User Name: <%= u.getUsername()%></div> 
            <div>Password: <%= u.getPassword()%></div> 
        <% 
        } else { 
        %> 
            <h1>No user record found.</h1>  
        <%}%> 
    </body> 
</html> 
