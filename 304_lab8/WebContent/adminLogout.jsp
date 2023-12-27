<%
	// Remove the user from the session to log them out
	session.setAttribute("authenticatedAdmin",null);
	session.setAttribute("adminName", null);
	session.setAttribute("userType", "customer");
	response.sendRedirect("listprod.jsp");		// Re-direct to main page
%>

