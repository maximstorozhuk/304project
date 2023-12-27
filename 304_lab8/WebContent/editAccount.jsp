<!DOCTYPE html>
<html>
<head>
<title>Account Editing Screen</title>
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

<h3>Edit Account</h3>

<h2>Leave fields blank to leave them unchanged</h2>
<% session.setAttribute("userType","customer"); %>

<br>
<form name="MyForm" method=post action="validateChange.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="username"  size=14 maxlength=14></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">First Name:</font></div></td>
	<td><input type="text" name="firstname"  size=14 maxlength=14></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Last Name:</font></div></td>
	<td><input type="text" name="lastname"  size=14 maxlength=14></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Email Address:</font></div></td>
	<td><input type="text" name="email"  size=14 maxlength=14></td>
    <td><select size="1" name="domain">
    <option>@student.ubc.ca</option>
    <option>@gmail.com</option>
    <option>@outlook.com</option>
    <option>@icloud.com</option>
    <option>@hotmail.com</option>
    <option>@yahoo.com</option>   
    </select></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input type="password" name="password" size=14 maxlength="14"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Confirm Password:</font></div></td>
	<td><input type="password" name="password2" size=14 maxlength="14"></td>
</tr>
<tr><td></td>
<td><div align = "right"><input class="submit" type="submit" name="Submit2" value="Change Account Info"></div></td>
</tr>
</table>
<br/>

</form>







</div>

<div>
<h2 align="center"><a href="customer.jsp">Back</a></h2>
</div>

</body>
</html>

