<%@ page language="java" import="java.io.*,java.sql.*,java.time.LocalDate,java.time.format.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String outcome = null;
	session = request.getSession(true);
	

	try
	{
		outcome = addProduct(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

    if(outcome == null || outcome.equals("error") || outcome.equals("blank")){
        response.sendRedirect("admin.jsp");
        session.setAttribute("addOutcome", "failure");
    }else if(outcome.equals("success")){
        session.setAttribute("addOutcome", "success");
        response.sendRedirect("admin.jsp");
    }else{
        
       session.setAttribute("addOutcome", outcome);
        response.sendRedirect("admin.jsp");
    }
    
%>


<%!
	String addProduct(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
        String retStr = null;
		String prodName = request.getParameter("prodName");
        String priceStr = request.getParameter("price");
        String imgURL = request.getParameter("imgURL");
        String desc = request.getParameter("desc");

      
        String dateStr = request.getParameter("date");
        String profIdStr = request.getParameter("profId");
        String inventoryStr = request.getParameter("inventory");

        

        if(prodName == null && priceStr == null && imgURL == null && desc == null && profIdStr == null && inventoryStr == null && dateStr == null){
				return "blank";
        }

        // if((prodName.length() == 0) && (imgURL.length() == 0) && (desc.length() == 0) && (profIdStr == 0) && (inventorySTr == 0)){
        //     return "blank";
        // }

        Date date;
        if(dateStr == null || dateStr.isEmpty()){
            date = null;
        }else{
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate localDate = LocalDate.parse(dateStr, formatter);
            date = java.sql.Date.valueOf(localDate);
        }

        
        double price = 0;
        if(priceStr == null || priceStr.isEmpty()){
            price = 0.0;
        }else{
		    price = Double.parseDouble(priceStr);
        }
        
        
        int profId = 0;
        if(profIdStr == null || profIdStr.isEmpty()){
            profId = 0;
        }else{
		    profId = Integer.parseInt(profIdStr);
        }
        int inventory = 0;
        if(inventoryStr == null || inventoryStr.isEmpty()){
            inventory = 0;
        }else{
		    inventory = Integer.parseInt(inventoryStr);
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
				String SQL = "INSERT INTO product VALUES (?,?,?,?,?,?,?);";
				PreparedStatement pstmt = con.prepareStatement(SQL);
				pstmt.setString(1, prodName);
                pstmt.setDouble(2, price);
                pstmt.setString(3, imgURL);
                pstmt.setString(4, desc);
                pstmt.setDate(5, new java.sql.Date(date.getTime()));
                pstmt.setInt(6, profId);
                pstmt.setInt(7, inventory);

				pstmt.executeUpdate();

				
                retStr = "success";
                

                
					
		}  catch(Exception e){
            retStr = "error";
            return e.toString();
        }
		
		

		return retStr;
	}

    
%>

