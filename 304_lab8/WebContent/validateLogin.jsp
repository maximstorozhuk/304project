<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);
	String userType = (String)session.getAttribute("userType");

	try
	{
		authenticatedUser = validateLogin(out,request,session, userType);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null && userType.equals("customer")){
		response.sendRedirect("initializeCart.jsp");	
		session.setAttribute("loginMessage", null);	// Successful login
	}else if(authenticatedUser != null && userType.equals("admin")){
		response.sendRedirect("admin.jsp");
		session.setAttribute("loginMessage", null);
	}else if(userType.equals("admin"))
		response.sendRedirect("adminLogin.jsp");
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session, String userType) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();

			if(userType.equals("customer")){
			
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
				String SQL = "SELECT customerId FROM customer WHERE userId = ? AND password = ?";
				PreparedStatement pstmt = con.prepareStatement(SQL);
				pstmt.setString(1, username);
				pstmt.setString(2, password);

				ResultSet rst = pstmt.executeQuery();

				if(rst.next()){
					retStr = username;
					session.setAttribute("customerId", rst.getInt(1) + "");



				}
				else retStr = null;		
			}else if(userType.equals("admin")){
				String SQL = "SELECT firstName, lastName FROM admin WHERE userId = ? AND password = ?";
				PreparedStatement pstmt = con.prepareStatement(SQL);
				pstmt.setString(1, username);
				pstmt.setString(2, password);

				ResultSet rst = pstmt.executeQuery();

				if(rst.next()){
					String adminName = rst.getString("firstName") +  " " + rst.getString("lastName");
					session.setAttribute("adminName", adminName);
					retStr = username;
				}
				else retStr = null;	
				//session.setAttribute("loginMessage", "Nothing returned from admin query");
			}
		} 
		catch (SQLException ex) {
			out.println("<h1>An exception occurred</h1>");
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			if(userType.equals("customer"))
				session.setAttribute("authenticatedUser",username);
			else if(userType.equals("admin"))
				session.setAttribute("authenticatedAdmin", username);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>

