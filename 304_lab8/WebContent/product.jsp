<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Pay-To-Win - Product Information</title>
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

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
String productId = request.getParameter("id");

String sql = "SELECT * FROM product WHERE productId = ?";

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
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    PreparedStatement pst = con.prepareStatement(sql);
    pst.setString(1, productId);
    ResultSet rst = pst.executeQuery();
    rst.next();
    int prodId = Integer.parseInt(productId);
    String productName = rst.getString("productName");
    double productPrice = rst.getDouble("productPrice");
    String productDesc = rst.getString("productDesc");
    String profImageURL = rst.getString("profImageURL");
    int profId = rst.getInt("profId");
    out.println("<h1>" + productName + "</h1>");
    out.println("<img src=\"" + profImageURL + "\" alt=\"No image for this product\">");

    String sql4 = "SELECT profName, officeLocation FROM prof WHERE profId = ?";
    PreparedStatement pstmt4 = con.prepareStatement(sql4);
    pstmt4.setInt(1, profId);
    ResultSet rst4 = pstmt4.executeQuery();
    rst4.next();
    String professorName = rst4.getString("profName");
    String location = rst4.getString("officeLocation");
    out.println("<h2>" + professorName + "'s Office Location: " + location + "</h2>");





    out.println("<h3>Id:    " + prodId + "</h3>");
    out.println("<h3>Price: " + currFormat.format(productPrice) + "</h3>");
    out.println("<h2><a href=\"addcart.jsp?id=" + prodId + "&name=" + productName + "&price=" + productPrice + "\">Add to cart</a></h2>");
    out.println("<h2><a href=\"listprod.jsp\">Continue Shopping</a></h2>");

    String sql3 = "SELECT ROUND(AVG(CAST(reviewRating AS FLOAT)), 2) AS avgRating FROM review WHERE profId = ?";
    PreparedStatement pstmt3 = con.prepareStatement(sql3);
    pstmt3.setInt(1, profId);
    ResultSet rst3 = pstmt3.executeQuery();
    rst3.next();
    double avgRating = rst3.getDouble("avgRating");




    out.println("<h2>Reviews: &#160 &#160 &#160 &#160 &#160 &#160 Average Rating: " + avgRating + "</h2>");
    String sql2 = "SELECT reviewRating, reviewDate, reviewComment FROM review WHERE profId = ?";
    PreparedStatement pstmt2 = con.prepareStatement(sql2);
    pstmt2.setInt(1, profId);
    ResultSet rst2 = pstmt2.executeQuery();
    while(rst2.next()){
        int rating = rst2.getInt("reviewRating");
        String comment = rst2.getString("reviewComment");
        java.sql.Timestamp timestamp = rst2.getTimestamp("reviewDate");
        java.util.Date date = new java.util.Date(timestamp.getTime());
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String rateDate = sdf.format(date);

        out.println("<h2>" + rating + "/5 Rating on " + rateDate + "</h2>");
        out.println("<br>");
        out.println("<h3>" + comment + "</h3>");
        out.println("<br><br>");
    }



} catch(Exception e){
    out.println("<h1>" + e.toString() + "</h1>");
}

// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
%>

</body>
</html>

