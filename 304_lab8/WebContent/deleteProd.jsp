<%@ page language="java" import="java.io.*,java.sql.*,java.time.LocalDate,java.time.format.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String outcome = null;
	session = request.getSession(true);
	

	try
	{
		outcome = deleteProduct(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

    if(outcome == null || outcome.equals("error") || outcome.equals("blank")){
        response.sendRedirect("admin.jsp");
        session.setAttribute("deleteOutcome", "failure");
    }else if(outcome.equals("success")){
        session.setAttribute("deleteOutcome", "success");
        response.sendRedirect("admin.jsp");
    }else if(outcome.equals("noID")){
        session.setAttribute("deleteOutcome", "noID");
        response.sendRedirect("admin.jsp");
    }else{
        
       session.setAttribute("deleteOutcome", outcome);
        response.sendRedirect("admin.jsp");
    }
    
%>


<%!
	String deleteProduct(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
        String retStr = null;
        String prodIdStr = request.getParameter("prodId");
		

        
        if(prodIdStr == null || prodIdStr.isEmpty()){
            return "noID";
        }



        

        // if((prodName.length() == 0) && (imgURL.length() == 0) && (desc.length() == 0) && (profIdStr == 0) && (inventorySTr == 0)){
        //     return "blank";
        // }

        
        int prodId = 0;
        if(prodIdStr == null || prodIdStr.isEmpty()){
            prodId = 0;
        }else{
		    prodId = Integer.parseInt(prodIdStr);
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

            //Check if Product Id exists

            String prodExist = "SELECT productId FROM product WHERE productId = ?";


            PreparedStatement existStmt = con.prepareStatement(prodExist);
            existStmt.setInt(1, prodId);

            ResultSet rst = existStmt.executeQuery();

            if(rst.next()){


                String SQL = "DELETE FROM product WHERE productID = ?";


                PreparedStatement pstmt = con.prepareStatement(SQL);
                pstmt.setInt(1, prodId);

                pstmt.executeUpdate();

            

				
                retStr = "success";
            }else{
                return "invalidID";
            }
           
                

                
					
		}  catch(Exception e){
            retStr = "error";
            return e.toString();
        }
		
		

		return retStr;
	}

    
%>

