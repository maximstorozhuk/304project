<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>


<html>
<head>
<title>Pay-To-Win - Error</title>
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
String what = request.getParameter("param");
if(what.equals("blank")){
    out.println("<h2 align = \"center\">You left one or more fields blank</h2>");
} else if(what.equals("taken")){
    out.println("<h2 align = \"center\">That username is already taken</h2>");
} else if (what.equals("error")){
    out.println("<h2 align = \"center\">error</h2>");
} else if(what.equals("itsnull")){
    out.println("<h2 align = \"center\">Something is null for some reason let me fix this</h2>");
} else if(what.equals("diff")){
	out.println("<h2 align = \"center\">Your two passwords don't match</h2>");
}

out.println("<h2 align = \"center\"><a href = editAccount.jsp>Try Editing Account Info Again</a></h2>");
out.println("<h2 align = \"center\"><a href = index.jsp>Return to Homepage</a></h2>");
%>
</body>
</html>