<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
	<%-- <nav class="navbar">
		<div class="container">
			<div class="logo"><a href = "index.jsp">Pay-To-Win</a></div>
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
	</nav> --%>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>
	<div class = "header">
		<div class = "side-nav">
            <div class = "user">
                <h2><%= session.getAttribute("firstName") %></h2>
            </div>

            <ul>
                <li><a href = 'editAccount.jsp'>Edit Info</a></li>
                <li><a href = 'review.jsp'>Leave a Review</a></li>
				<li><a href = 'listprod.jsp'>Continue Shopping</a></li>
                
            </ul>

            <ul>
                <li><a href = 'logout.jsp'>Logout</a></li>
            </ul>


        </div>

		<div class = "profile">

			<%

			// TODO: Print Customer information

			out.println("<h3>Customer Profile</h3>");

			String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
			String uid = "sa";
			String pw = "304#sa#pw";

			try(Connection con = DriverManager.getConnection(url, uid, pw);
			Statement stmt = con.createStatement();){
				NumberFormat currFormat = NumberFormat.getCurrencyInstance();

				String sql = "SELECT * FROM customer WHERE userId = ?";
				
				PreparedStatement pstmtX = con.prepareStatement(sql);
				pstmtX.setString(1, userName);
				ResultSet rstX = pstmtX.executeQuery();

				out.println("<table border = \"1\">");
				if(rstX.next()){
					String custId = rstX.getString(1);
					out.println("<tr><th>Id</th><td>" + custId + "</td></tr>");

					String first = rstX.getString(2);
					out.println("<tr><th>First Name</th><td>" + first + "</td></tr>");

					String last = rstX.getString(3);
					out.println("<tr><th>Last Name</th><td>" + last + "</td></tr>");

					String email = rstX.getString(4);
					out.println("<tr><th>Email</th><td>" + email + "</td></tr>");

					String userId = rstX.getString(5);
					out.println("<tr><th>UserId</th><td>" + userId + "</td></tr>");

				}
				out.println("</table>");
				
				
				

			} 	catch(Exception e){
				out.println("<h1>" + e.toString() + "</h1>");
			}



			// Make sure to close connection
			%>
		</div>
	</div>

</body>
</html>

