<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
        <title>Pay-To-Win Main Page</title>
		<link rel="stylesheet" href="style.css">
</head>
<body>


<%
    try
                {	// Load driver class
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                }
                catch (java.lang.ClassNotFoundException e)
                {
                    out.println("ClassNotFoundException: " +e);
                }
                
                String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String uid = "sa";
                String pw = "304#sa#pw";

        
        
                

		try(Connection con = DriverManager.getConnection(url, uid, pw);){


			
				String SQL = "SELECT * FROM incart;";
				PreparedStatement pstmt = con.prepareStatement(SQL);
				

				ResultSet rst = pstmt.executeQuery();

                while(rst.next()){
                    out.println("<h3>" + rst.getInt(1) + ", " + rst.getInt(2) + ", "  + rst.getString(3) + ", " + rst.getInt(4) + ", " + rst.getDouble(5) + " </h3>");
                }

				
				


			
			

		}catch(Exception e){
			out.println("<script> alert('Issue with Adding cart to database!!!') </script>");
		}


%>

</body>
</html>