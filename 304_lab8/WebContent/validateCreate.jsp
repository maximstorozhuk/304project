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

    if(authenticatedUser == null){
        response.sendRedirect("failedCreation.jsp?param=itsnull");
    }else if(authenticatedUser.equals("error"))
        response.sendRedirect("failedCreation.jsp?param=error");
    else if(authenticatedUser.equals("blank"))
        response.sendRedirect("failedCreation.jsp?param=blank");
	else if(authenticatedUser.equals("taken"))
        response.sendRedirect("failedCreation.jsp?param=taken");
    else if(authenticatedUser.equals("diff")){
        response.sendRedirect("failedcreation.jsp?param=diff");
    } else
        response.sendRedirect("customer.jsp");
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session, String userType) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
        String password2 = request.getParameter("password2");
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");
		String retStr = null;

		if(username == null || password == null || firstname == null || lastname == null || email == null){
				return "blank";
        }
        int before = email.length();
        email += request.getParameter("domain");
		if((username.length() == 0) || (password.length() == 0) || (firstname.length() == 0) || (lastname.length() == 0) || (before == 0)){
            return "blank";
        }
        if(!password.equals(password2)){
            return "diff";
        }
                try
                {	// Load driver class
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                }
                catch (java.lang.ClassNotFoundException e)
                {
                    out.println("ClassNotFoundException: " +e);
                }
                
                String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String uid = "sa";
                String pw = "304#sa#pw";

		try(Connection con = DriverManager.getConnection(url, uid, pw);)
		{
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
				String SQL = "SELECT customerId FROM customer WHERE userId = ?";
				PreparedStatement pstmt = con.prepareStatement(SQL);
				pstmt.setString(1, username);

				ResultSet rst = pstmt.executeQuery();

				if(rst.next()){
					return "taken";
				}

                String sql2 = "INSERT INTO customer(firstName, lastName, email, userId, password) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement pstmt2 = con.prepareStatement(sql2);
                pstmt2.setString(1, firstname);
                pstmt2.setString(2, lastname);
                pstmt2.setString(3, email);
                pstmt2.setString(4, username);
                pstmt2.setString(5, password);
                pstmt2.executeUpdate();
                retStr = username;

                session.setAttribute("firstName", firstname);
					
		}  catch(Exception e){
            return "aaaaaaaaaa" + e.toString();
        }
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			if(userType.equals("customer"))
				session.setAttribute("authenticatedUser",username);
		}
		else
			session.setAttribute("loginMessage","Try Again.");

		return retStr;
	}
%>

