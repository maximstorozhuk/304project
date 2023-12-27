<%
	String userType = (String) session.getAttribute("userType");
	boolean authCustomer = session.getAttribute("authenticatedUser") == null ? false : true;
	
	if(userType == null){
		String loginMessage = "You have not been authorized to access the URL "+request.getRequestURL().toString();
        session.setAttribute("loginMessage",loginMessage);        
		response.sendRedirect("login.jsp");
	}else if(userType.equals("admin")){
		response.sendRedirect("admin.jsp");
	}else if (!authCustomer)
	{
		String loginMessage = "You have not been authorized to access the URL "+request.getRequestURL().toString();
        session.setAttribute("loginMessage",loginMessage);        
		response.sendRedirect("login.jsp");
	}
	
%>
