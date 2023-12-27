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
    <br>
    <br>

<% String profId = request.getParameter("profId"); %>

<form method="get" action="processReview.jsp">
<p align = "left">
	<select size="1" name="rating">
		<option>1</option>
		<option>2</option>
		<option>3</option>
		<option>4</option>
		<option>5</option>
		</select>
        <textarea name="comment" rows="5" cols="200"></textarea>
        <input type="hidden" name="profId" value="<%= profId %>">
        <input type="submit" value="Submit"><input type="reset" value="Reset"></p>
	  </form>
</body>
</html>

