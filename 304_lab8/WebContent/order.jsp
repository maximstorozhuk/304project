<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Pay-To-Win Order Processing</title>
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
// Get customer id
String custId = request.getParameter("userId");
String custPassword = request.getParameter("customerPassword");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

try(Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();){
		if(productList.isEmpty()){
			throw new NullPointerException();
		}
		if(custId == null){
			throw new IndexOutOfBoundsException();
		}
		String userToId = "SELECT customerId FROM customer WHERE userId = ?";
		PreparedStatement pstUser = con.prepareStatement(userToId);
		pstUser.setString(1, custId);
		ResultSet rstUser = pstUser.executeQuery();
		if(!rstUser.next()){
			throw new IndexOutOfBoundsException();
		} else{
			custId = rstUser.getString("customerId");
		}
		String cust = "SELECT customerId, password FROM customer WHERE customerId = ?";
		PreparedStatement pst = con.prepareStatement(cust);
		pst.setString(1, custId);
		ResultSet rst = pst.executeQuery();
		if(!rst.next()){
			throw new IndexOutOfBoundsException();
		}
		String pass = rst.getString("password");
		if(!pass.equals(custPassword)){
			throw new IllegalArgumentException();
		}
		rst.close();

		String addOrder = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES ( ?, ?, " + 0 + ")";
		PreparedStatement pst2 = con.prepareStatement(addOrder, Statement.RETURN_GENERATED_KEYS);
		pst2.setString(1, custId);
		pst2.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
		pst2.executeUpdate();
		ResultSet keys = pst2.getGeneratedKeys();
		keys.next();
		int ordId = keys.getInt(1);
		keys.close();
		double totAmount = 0;

		String addOrderProduct = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (" + ordId + ", ?, ?, ?)";
		String updateProdQuant = "UPDATE product SET inventory = inventory - ? WHERE productId = ?";
		String checkInventory = "SELECT inventory FROM product WHERE productId = ?";
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		while (iterator.hasNext())
		{ 
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			int productId = Integer.parseInt(product.get(0).toString());
       		double price = Double.parseDouble(product.get(2).toString());
			int qty = ( (Integer)product.get(3)).intValue();
			PreparedStatement pst3 = con.prepareStatement(addOrderProduct);
			PreparedStatement pstQuant = con.prepareStatement(updateProdQuant);
			PreparedStatement pstInventory = con.prepareStatement(checkInventory);
			pstInventory.setInt(1, productId);
			ResultSet checkInventories = pstInventory.executeQuery();
			checkInventories.next();
			if(checkInventories.getInt("inventory") < qty){
				throw new ArithmeticException();
			}
			pst3.setInt(1, productId);
			pst3.setInt(2, qty);
			pst3.setDouble(3, price);
			pstQuant.setInt(1, qty);
			pstQuant.setInt(2, productId);
			pstQuant.executeUpdate();
			pst3.executeUpdate();
			totAmount += price * qty;
		}

		String updateAmount = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
		PreparedStatement pst4 = con.prepareStatement(updateAmount);
		pst4.setDouble(1, totAmount);
		pst4.setInt(2, ordId);
		pst4.executeUpdate();

		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		String orders = "SELECT orderId, orderDate, customerId, totalAmount FROM ordersummary WHERE orderId = ?";
		PreparedStatement pst5 = con.prepareStatement(orders);
		pst5.setInt(1, ordId);
		out.println("<table border = \"1\"><tr><th>OrderId</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
		ResultSet rst2 = pst5.executeQuery();
		String customerInfo = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
		String prods = "SELECT * FROM orderproduct WHERE orderId = ?";
		while(rst2.next()){
			Date ordDate = rst2.getDate("orderDate");
			int customId = rst2.getInt("customerId");
			double totaAmount = rst2.getDouble("totalAmount");
			PreparedStatement custInfo = con.prepareStatement(customerInfo);
			PreparedStatement prodInfo = con.prepareStatement(prods);
			custInfo.setInt(1, customId);
			prodInfo.setInt(1, ordId);
			ResultSet rst3 = custInfo.executeQuery();
			rst3.next();
			String custname = rst3.getString("firstName") + " " + rst3.getString("lastName");
			rst3.close();
			out.println("<tr><td>" + ordId + "</td><td>" + ordDate + "</td><td>" + custId + "</td><td>" + custname + "</td><td>" + currFormat.format(totaAmount) + "</td></tr>");

			ResultSet rst4 = prodInfo.executeQuery();
			out.println("<tr align = \"right\"><td colspan = \"4\"><table border = \"1\"><tr><th>Product Id</th><th>Quantity</th><th>Price</th></td></tr>");
			while(rst4.next()){
				int prodId = rst4.getInt("productId");
				int quant = rst4.getInt("quantity");
				double prices = rst4.getDouble("price");
				out.println("<tr><td>" + prodId + "</td><td>" + quant + "</td><td>" + currFormat.format(prices) + "</td><tr>");
			}
			out.println("</table></tr>");

			rst3.close();
		}
		rst.close();
		out.println("</table>");
		out.println("<br><h1><a href = customer.jsp>Go to Your Account Page</a></h1>");

		session.removeAttribute("productList");

	} catch(IndexOutOfBoundsException e){
		out.println("<h1>This customer ID does not exist</h1>");
		out.println("<h1><a href = showcart.jsp>Back to Cart</a></h1>");
	} catch(NullPointerException e){
		out.println("<h1>You cannot check out without any items in your cart.</h1>");
		out.println("<h1><a href = showcart.jsp>Back to Cart</a></h1>");
	} catch(IllegalArgumentException e){
		out.println("<h1>Incorrect Password</h1>");
		out.println("<h1><a href = showcart.jsp>Back to Cart</a></h1>");
	} catch(ArithmeticException e){
		out.println("<h1>Not enough time slots remaining</h1>");
		out.println("<h1><a href = showcart.jsp>Back to Cart</a></h1>");
	} catch(Exception e){
		out.println("<h1>" + e.toString() + "</h1>");
	} 


// Clear cart if order placed successfully

%>
</BODY>
</HTML>

