<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String oldUsername = (String) session.getAttribute("authenticatedUser");
	session = request.getSession(true);
	String userType = (String)session.getAttribute("userType");
    String authenticatedUser = null;

	try
	{
		authenticatedUser = validateLogin(out,request,session, userType, oldUsername);
	}
	catch(IOException e)
	{	System.err.println(e); }

    if(authenticatedUser == null){
        response.sendRedirect("failedChange.jsp?param=itsnull");
    }else if(authenticatedUser.equals("error"))
        response.sendRedirect("failedChange.jsp?param=error");
    else if(authenticatedUser.equals("blank"))
        response.sendRedirect("failedChange.jsp?param=blank");
	else if(authenticatedUser.equals("taken"))
        response.sendRedirect("failedChange.jsp?param=taken");
    else if(authenticatedUser.equals("diff")){
        response.sendRedirect("failedChange.jsp?param=diff");
    } else
        response.sendRedirect("customer.jsp");
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session, String userType, String oldUsername) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
        String password2 = request.getParameter("password2");
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");
		String retStr = null;

        
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
                String get = "SELECT * FROM customer WHERE userId = ?";
                PreparedStatement pstmtGet = con.prepareStatement(get);
                pstmtGet.setString(1, oldUsername);
                ResultSet rstGet = pstmtGet.executeQuery();
                rstGet.next();

                String oldPass = rstGet.getString("password");
                String oldFirst = rstGet.getString("firstName");
                String oldLast = rstGet.getString("lastName");
                String oldEmail = rstGet.getString("email");
                boolean emailCheck = true;
                boolean userNameCheck = true;

                if(username == null){
                    username = oldUsername;
                    userNameCheck = false;
                }
                if(password == null){
                    password = oldPass;
                    password2 = oldPass;
                }
                if(password2 == null){
                    password = oldPass;
                    password2 = oldPass;
                }
                if(firstname == null){
                    firstname = oldFirst;
                }
                if(lastname == null){
                    lastname = oldLast;
                }
                if(email == null){
                    email = oldEmail;
                    emailCheck = false;
                }


                if(username.length() == 0){
                    username = oldUsername;
                    userNameCheck = false;
                }
                if(password.length() == 0){
                    password = oldPass;
                    password2 = oldPass;
                }
                if(password2.length() == 0){
                    password = oldPass;
                    password2 = oldPass;
                }
                if(firstname.length() == 0){
                    firstname = oldFirst;
                }
                if(lastname.length() == 0){
                    lastname = oldLast;
                }
                if(email.length() == 0){
                    email = oldEmail;
                    emailCheck = false;
                }
                // TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
                if(userNameCheck){
				String SQL = "SELECT customerId FROM customer WHERE userId = ?";
				PreparedStatement pstmt = con.prepareStatement(SQL);
				pstmt.setString(1, username);

				ResultSet rst = pstmt.executeQuery();
                

				if(rst.next()){
					return "taken";
				}
                }   
                if(emailCheck){
                    email += request.getParameter("domain");
                }
		
                if(!password.equals(password2)){
                    return "diff";
                }

                String sql2 = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, userid = ?, password = ? WHERE userid = ?";
                PreparedStatement pstmt2 = con.prepareStatement(sql2);
                pstmt2.setString(1, firstname);
                pstmt2.setString(2, lastname);
                pstmt2.setString(3, email);
                pstmt2.setString(4, username);
                pstmt2.setString(5, password);
                pstmt2.setString(6, oldUsername);
                pstmt2.executeUpdate();
                retStr = username;
					
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

