<!DOCTYPE html>
<html>
<head>
<title>Your Orders</title>
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

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// TODO: Print Customer information


String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try(Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement();){
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    
	out.println("<h3>All Your Orders</h3>");
			String sql3 = "SELECT customerId FROM customer WHERE userId = ?";
			PreparedStatement pstmtY = con.prepareStatement(sql3);
            pstmtY.setString(1, userName);
            ResultSet rstY = pstmtY.executeQuery();
            rstY.next();
            int custIdY = rstY.getInt("customerId");
			String orders = "SELECT orderId, orderDate, customerId, totalAmount FROM ordersummary WHERE customerId = ?";
			PreparedStatement pstmtZ = con.prepareStatement(orders);
			pstmtZ.setInt(1, custIdY);
			out.println("<table border = \"1\"><tr><th>Order Date</th><th>Customer Name</th><th>Total Amount</th></tr>");
			ResultSet rst = pstmtZ.executeQuery();
			String customerInfo = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
			String prods = "SELECT OP.productId, OP.quantity, OP.price, P.productName " +
                            "FROM orderproduct OP JOIN product P ON OP.productId = P.productId " +
                            "WHERE orderId = ?";
			while(rst.next()){
				int ordId = rst.getInt("orderId");
				Date ordDate = rst.getDate("orderDate");
				int custId = rst.getInt("customerId");
				double totAmount = rst.getDouble("totalAmount");
				PreparedStatement custInfo = con.prepareStatement(customerInfo);
				PreparedStatement prodInfo = con.prepareStatement(prods);
				custInfo.setInt(1, custId);
				prodInfo.setInt(1, ordId);
				ResultSet rst2 = custInfo.executeQuery();
				rst2.next();
				String custname = rst2.getString("firstName") + " " + rst2.getString("lastName");
				rst2.close();
				out.println("<tr><td>" + ordDate + "</td><td>" + custname + "</td><td>" + currFormat.format(totAmount) + "</td></tr>");

				ResultSet rst3 = prodInfo.executeQuery();
				out.println("<tr align = \"right\"><td colspan = \"4\"><table border = \"1\"><tr><th>Product Id</th><th>Quantity</th><th>Price</th></td></tr>");
				while(rst3.next()){
					int prodId = rst3.getInt("productId");
                    String prodName = rst3.getString("productName");
					int quant = rst3.getInt("quantity");
					double price = rst3.getDouble("price");
					out.println("<tr><td>" + prodName + "</td><td>" + quant + "</td><td>" + currFormat.format(price) + "</td><tr>");
				}
				out.println("</table></tr>");

				rst3.close();
			}
			rst.close();

			out.println("</table>");

} 	catch(Exception e){
	out.println("<h1>" + e.toString() + "</h1>");
}



// Make sure to close connection
%>

</body>
</html>

