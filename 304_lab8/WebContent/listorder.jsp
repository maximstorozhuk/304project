<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Pay-To-Win Order List</title>
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

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0));  // Prints $5.00

// Make connection

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try ( Connection con = DriverManager.getConnection(url, uid, pw);
	          Statement stmt = con.createStatement();) 
	    {
			NumberFormat currFormat = NumberFormat.getCurrencyInstance();
			String orders = "SELECT orderId, orderDate, customerId, totalAmount FROM ordersummary";
			out.println("<table border = \"1\"><tr><th>OrderId</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
			ResultSet rst = stmt.executeQuery(orders);
			String customerInfo = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
			String prods = "SELECT * FROM orderproduct WHERE orderId = ?";
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
				out.println("<tr><td>" + ordId + "</td><td>" + ordDate + "</td><td>" + custId + "</td><td>" + custname + "</td><td>" + currFormat.format(totAmount) + "</td></tr>");

				ResultSet rst3 = prodInfo.executeQuery();
				out.println("<tr align = \"right\"><td colspan = \"4\"><table border = \"1\"><tr><th>Product Id</th><th>Quantity</th><th>Price</th></td></tr>");
				while(rst3.next()){
					int prodId = rst3.getInt("productId");
					int quant = rst3.getInt("quantity");
					double price = rst3.getDouble("price");
					out.println("<tr><td>" + prodId + "</td><td>" + quant + "</td><td>" + currFormat.format(price) + "</td><tr>");
				}
				out.println("</table></tr>");

				rst3.close();
			}
			rst.close();

			out.println("</table>");
		}
	catch(Exception e){
		out.println("<h1>" + e.toString() + "</h1>");
	}


// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
%>

</body>
</html>

