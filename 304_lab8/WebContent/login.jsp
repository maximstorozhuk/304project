<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
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

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Please Login to System</h3>

<% session.setAttribute("userType", "customer"); 
if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
%>

<br>
<form name="MyForm" method=post action="validateLogin.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="username"  size=14 maxlength=14></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input type="password" name="password" size=14 maxlength="14"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Log In">
</form>







</div>
<div>
<h2 align="center"><a href="createAccount.jsp">Create Account</a></h2>
</div>
<div>
<h2 align="center"><a href="adminLogin.jsp">Admin Login</a></h2>
</div>

<div>
<h2 align="center"><a href="index.jsp">Back</a></h2>
</div>

</body>
</html>

