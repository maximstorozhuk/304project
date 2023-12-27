<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Pay-To-Win - Leave a Review</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="navbar">
		<div class="container">
			<div class="logo"><a href = "listprod.jsp">UBC Pay-To-Win</a></div>
			<ul class="nav">

			
				<li>
					
					<p><%= session.getAttribute("authenticatedUser") != null? (String)session.getAttribute("firstName") + "'s" : ""%> </p>
					<a href="customer.jsp">Account</a>
				</li>
				<li>
				
					<a href="customerOrders.jsp">Orders</a>
				</li>
				<li>
					<a href="showcart.jsp">Cart</a>
				</li>
			</ul>
		</div>
	</nav>

<% String profId = request.getParameter("profId"); 
String ratings = request.getParameter("rating");
boolean thereIsInput = ratings != null;
int rating = 0;
if(thereIsInput){
rating = Integer.parseInt(ratings);
}
String comment = request.getParameter("comment"); 

// Get product name to search for
// TODO: Retrieve and display info for the product
String userName = (String) session.getAttribute("authenticatedUser");

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
    if(thereIsInput){
    String sql = "INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (?, ?, ?, ?, ?)";
    PreparedStatement pstmt = con.prepareStatement(sql);

    String sql3 = "SELECT customerId FROM customer WHERE userId = ?";
    PreparedStatement pstmt3 = con.prepareStatement(sql3);
            pstmt3.setString(1, userName);
            ResultSet rst3 = pstmt3.executeQuery();
            rst3.next();
            int custId = rst3.getInt("customerId");

    pstmt.setInt(1, rating);
    pstmt.setDate(2, java.sql.Date.valueOf(java.time.LocalDate.now()));
    pstmt.setInt(3, custId);
    pstmt.setString(4, profId);
    pstmt.setString(5, comment);
    pstmt.executeUpdate();

    out.println("<h1><a href = index.jsp>Return to Homepage</a></h1>");
    
    }else{
        out.println("<h1>Something went wrong.</h1>");
        out.println("<h1><a href = index.jsp>Return to Homepage</a></h1>");
    }
} catch(Exception e){
    out.println("<h1>" + e.toString() + "</h1>");
}
%>


</body>
</html>
<jsp:forward page="reviewProcessed.jsp" />

