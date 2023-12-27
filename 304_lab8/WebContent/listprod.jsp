<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Pay-To-Win</title>
<link rel="stylesheet" href="style.css">
</head>
<body>


<%
	String username = (String) session.getAttribute("authenticatedUser");
	if (username != null){
		
		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid = "sa";
		String pw = "304#sa#pw";

		try(Connection con = DriverManager.getConnection(url, uid, pw);){
			

			String sql = "SELECT firstName " +
							"FROM customer " +
							"WHERE userId = ?";
							
			
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, username);
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


<div class = 'searchBar'>
<h1>Search Pay-To-Win for Office Hours</h1>

<form method="get" action="listprod.jsp">
<p align = "left">
	<select size="1" name="profName">
		<option>All</option>
	  
	  
	  
		<option>Ramon Lawrence</option>
		<option>Yves Lucet</option>
		<option>Abdallah Mohamed</option>
		<option>Scott Fazackerley</option>
		<option>Donovan Hare</option>
		<option>Wayne Broughton</option>
		<option>Paul Lee</option>
		<option>Heinz Bauschke</option>
	  
		<input type="text" name="productName" size="50">    
		</select><input type="submit" value="Submit"><input type="reset" value="Reset"></p>
	  </form>

</div>

<% // Get product name to search for
String name = request.getParameter("productName");

String prof = request.getParameter("profName");

String userName = "";
boolean dynamic = false;

if(session.getAttribute("authenticatedUser") != null){
	userName = (String) session.getAttribute("authenticatedUser");
	dynamic = true;
}

		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}


// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try(Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();){
		int currCustId = -1;
		int favProf = -1;
		String getAllFav = "";
		if(dynamic){
			String getCustId = "SELECT customerId FROM customer WHERE userId = ?";
			PreparedStatement pstmtCust = con.prepareStatement(getCustId);
			pstmtCust.setString(1, userName);
			ResultSet rstCust = pstmtCust.executeQuery();
			rstCust.next();
			currCustId = rstCust.getInt("customerId");
			String getFavProf = "SELECT TOP 1 profId, COUNT(profId) AS num " +
								"FROM ordersummary JOIN orderproduct ON ordersummary.orderId = orderproduct.orderId JOIN product ON orderproduct.productId = product.productId " +
								"WHERE customerId = ? AND orderDate > ? " +
								"GROUP BY profId ORDER BY num DESC";
			PreparedStatement pstmtProf = con.prepareStatement(getFavProf);
			pstmtProf.setInt(1, currCustId);
			pstmtProf.setDate(2, java.sql.Date.valueOf(java.time.LocalDate.now().minusMonths(6)));
			ResultSet rstProf = pstmtProf.executeQuery();
			if(rstProf.next()){
				favProf = rstProf.getInt("profId");
			}
			getAllFav = "SELECT * FROM product WHERE inventory > 0 AND profId = ? ORDER BY inventory ASC, productDate ASC";
		}





		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		String getAll = "SELECT * FROM product WHERE inventory > 0 ORDER BY inventory ASC, productDate ASC";
		if(dynamic){
			getAll = "SELECT * FROM product WHERE inventory > 0 AND profId != ? ORDER BY inventory ASC, productDate ASC";
		}
		String not = "SELECT * FROM product WHERE inventory > 0 AND productName LIKE ? AND profId IN (SELECT profId FROM prof WHERE profName LIKE ?) ORDER BY inventory ASC, productDate ASC";
		//out.println("<table border = \"1\"><tr><th></th><th>Office Hours</th><th>Price</th><th>Slots Left</th></tr>");
		out.println("<div class = 'gridParent'>");


		if((name == null || name.equals("") )&& (prof == null || prof.equals("All"))){
			if(dynamic){
				PreparedStatement execFav = con.prepareStatement(getAllFav);
				execFav.setInt(1, favProf);
				ResultSet rstFav = execFav.executeQuery();
				while(rstFav.next()){
					String prodName = rstFav.getString("productName");
					String prodDesc = rstFav.getString("productDesc");
					int prodId = rstFav.getInt("productId");
					double price = rstFav.getDouble("productPrice");
					String profImageURL = rstFav.getString("profImageURL");
					int inventory = rstFav.getInt("inventory");
					out.println("<div class = 'item'><img src=\"" + profImageURL + "\" alt=\"No image for this product\"> <a href=\"product.jsp?id=" + prodId + "\" class = 'prodname'>" + prodName + "</a><h3>" + currFormat.format(price)  + "</h3><h3 class = 'qty'>" + inventory + " Slots Left</h3> <a href=\"addcart.jsp?id=" + prodId + "&name=" + prodName + "&price=" + price + "\" class = 'addtocart'>Add to cart</a></div>");
				}
			}
			PreparedStatement getAllProd = con.prepareStatement(getAll);
			if(dynamic){
				getAllProd.setInt(1, favProf);
			}
			ResultSet all = getAllProd.executeQuery();
			while(all.next()){
				String prodName = all.getString("productName");
				String prodDesc = all.getString("productDesc");
				int prodId = all.getInt("productId");
				double price = all.getDouble("productPrice");
				String profImageURL = all.getString("profImageURL");
				int inventory = all.getInt("inventory");
				out.println("<div class = 'item'><img src=\"" + profImageURL + "\" alt=\"No image for this product\"> <a href=\"product.jsp?id=" + prodId + "\" class = 'prodname'>" + prodName + "</a><h3>" + currFormat.format(price)  + "</h3><h3 class = 'qty'>" + inventory + " Slots Left</h3> <a href=\"addcart.jsp?id=" + prodId + "&name=" + prodName + "&price=" + price + "\" class = 'addtocart'>Add to cart</a></div>");
			}
			all.close();
		}else{
			
			PreparedStatement query = con.prepareStatement(not);
			query.setString(1, "%" + name + "%");
			if(prof.equals("All")){
				query.setString(2, "% %");
			} else{
				query.setString(2, "%" + prof + "%");
			}
			ResultSet notAll = query.executeQuery();
			while(notAll.next()){
				String prodName = notAll.getString("productName");
				String prodDesc = notAll.getString("productDesc");
				int prodId = notAll.getInt("productId");
				double price = notAll.getDouble("productPrice");
				String profImageURL = notAll.getString("profImageURL");
				int inventory = notAll.getInt("inventory");
				out.println("<div class = 'item'><img src=\"" + profImageURL + "\" alt=\"No image for this product\"> <a href=\"product.jsp?id=" + prodId + "\" class = 'prodname'>" + prodName + "</a><h3>" + currFormat.format(price)  + "</h3><h3 class = 'qty'>" + inventory + " Slots Left</h3> <a href=\"addcart.jsp?id=" + prodId + "&name=" + prodName + "&price=" + price + "\" class = 'addtocart'>Add to cart</a></div>");
			}
			notAll.close();
		}
		out.println("</div>");
}	catch(Exception e){
	out.println("<h1>" + e.toString() + "</h1>");
}


// Make the connection

// Print out the ResultSet

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>