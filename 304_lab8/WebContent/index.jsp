<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
        <title>Pay-To-Win Main Page</title>
		<link rel="stylesheet" href="style.css">
</head>
<body>
<%-- Displaying User's First name in the Header--%>
<%
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null){
		
		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid = "sa";
		String pw = "304#sa#pw";

		try(Connection con = DriverManager.getConnection(url, uid, pw);){
			

			String sql = "SELECT firstName " +
							"FROM customer " +
							"WHERE userId = ?";
							
			
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userName);
			ResultSet rst = pstmt.executeQuery();

			

			if(rst.next()){
				session.setAttribute("firstName", rst.getString(1));
				
			}
			
			
			


		} 	catch(Exception e){
			out.println("<h1>" + e.toString() + "</h1>");
		}
	}

		
%>



<nav class="navbar">
		<div class="container">
			<div class="logo"><a href = "listprod.jsp">Pay-To-Win</a></div>
			<ul class="nav">

			
				<li>
					
					<p><%= session.getAttribute("authenticatedUser") != null? (String)session.getAttribute("firstName") + "'s" : ""%> </p>
					<a href="customer.jsp">Account</a>
				</li>
				<li>
				
					<a href="order.jsp">Orders</a>
				</li>
				<li>
					<a href="showcart.jsp">Cart</a>
				</li>
			</ul>
		</div>
	</nav>

<h1 align="center">Welcome to "Pay-To-Win"</h1>

<%
String userNames = (String) session.getAttribute("authenticatedUser");
if(userNames == null){
	out.println("<h2 align=\"center\"><a href=\"login.jsp\">Login</a></h2>");
}
%>


<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

<%
	String userName2 = (String) session.getAttribute("authenticatedUser");
	if (userName2 != null){
		out.println("<h2 align=\"center\"><a href=\"review.jsp\">Leave a Review</a></h2>");
		String url2 = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid2 = "sa";
		String pw2 = "304#sa#pw";

		try(Connection con = DriverManager.getConnection(url2, uid2, pw2);){
			

			String sql = "SELECT firstName, lastName " +
							"FROM customer " +
							"WHERE userId = ?";
							
			
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userName);
			ResultSet rst = pstmt.executeQuery();

			

			if(rst.next()){
				String first = rst.getString(1);
				String last = rst.getString(2);
				out.println("<h3 align=\"center\">Signed in as: "+first + " " + last +"</h3>");
			}
			


		} 	catch(Exception e){
			out.println("<h1>" + e.toString() + "</h1>");
		}
	}

		
%>

</body>
</html>


