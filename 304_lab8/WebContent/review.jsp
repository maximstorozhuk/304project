<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
        <title>Pay-To-Win Reviews</title>
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
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null){
		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid = "sa";
		String pw = "304#sa#pw";

		try(Connection con = DriverManager.getConnection(url, uid, pw);){
			

			String sql = "SELECT DISTINCT prof.profId " +
             "FROM customer " +
             "JOIN ordersummary ON customer.customerId = ordersummary.customerId " +
             "JOIN orderproduct ON ordersummary.orderId = orderproduct.orderId " +
             "JOIN product ON orderproduct.productId = product.productId " +
             "JOIN prof ON product.profId = prof.profId " +
             "WHERE userId = ? AND prof.profId NOT IN (SELECT profId FROM review WHERE customerId = ?)";

            String sql2 = "SELECT profName FROM prof WHERE profId = ?";

            String sql3 = "SELECT customerId FROM customer WHERE userId = ?";
			
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userName);

            PreparedStatement pstmt3 = con.prepareStatement(sql3);
            pstmt3.setString(1, userName);
            ResultSet rst3 = pstmt3.executeQuery();
            rst3.next();
            int custId = rst3.getInt("customerId");

            pstmt.setInt(2, custId);
            ResultSet rst = pstmt.executeQuery();
            
            

            

            if(!rst.next()){
                out.println("<h2 align = \"center\">You can only leave reviews on professors whose office hours you've visited. Visit a professor to leave a review!");
                out.println("<h2 align = \"center\"><a href = customer.jsp>Return to Account Page</a></h2>");
            } else{
                do{
                int profId = rst.getInt("profId");
                PreparedStatement pstmt2 = con.prepareStatement(sql2);
                pstmt2.setInt(1, profId);
                ResultSet rst2 = pstmt2.executeQuery();
                rst2.next();
                String profName = rst2.getString("profName");
                out.println("<h2 align = \"center\"><a href =\"leaveReview.jsp?profId=" + profId + "\">Leave a review on " + profName + "</a></h2>");
                } while(rst.next());
            }
			


		} 	catch(Exception e){
			out.println("<h1>" + e.toString() + "</h1>");
		}
	}

		
%>

</body>
</html>


