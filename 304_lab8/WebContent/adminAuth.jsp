<%
	boolean authAdmin = session.getAttribute("authenticatedAdmin") == null ? false: true;

	if (!authAdmin)
	{
		String loginMessage = "You have not been authorized to access the admin page";
        session.setAttribute("loginMessage",loginMessage);        
		response.sendRedirect("adminLogin.jsp");
	}
	
%>
