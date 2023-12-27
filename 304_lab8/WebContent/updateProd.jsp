<%@ page language="java" import="java.io.*,java.sql.*,java.time.LocalDate,java.time.format.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String outcome = null;
	session = request.getSession(true);
	

	try
	{
		outcome = updateProduct(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

    if(outcome == null || outcome.equals("error") || outcome.equals("blank")){
        response.sendRedirect("admin.jsp");
        session.setAttribute("updateOutcome", "failure");
    }else if(outcome.equals("success")){
        session.setAttribute("updateOutcome", "success");
        response.sendRedirect("admin.jsp");
    }else if(outcome.equals("noID")){
        session.setAttribute("updateOutcome", "noID");
        response.sendRedirect("admin.jsp");
    }else{
        
       session.setAttribute("updateOutcome", outcome);
        response.sendRedirect("admin.jsp");
    }
    
%>


<%!
	String updateProduct(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
        String retStr = null;
        String prodIdStr = request.getParameter("prodId");
		String prodName = request.getParameter("prodName");
        String priceStr = request.getParameter("price");
        String imgURL = request.getParameter("imgURL");
        String desc = request.getParameter("desc");
        String dateStr = request.getParameter("date");
        String profIdStr = request.getParameter("profId");
        String inventoryStr = request.getParameter("inventory");

        
        if(prodIdStr == null || prodIdStr.isEmpty()){
            return "noID";
        }



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

        int prodId = 0;
        if(prodIdStr == null || prodIdStr.isEmpty()){
            prodId = 0;
        }else{
		    prodId = Integer.parseInt(prodIdStr);
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

            //Check if Product Id exists

            String prodExist = "SELECT productId FROM product WHERE productId = ?";


            PreparedStatement existStmt = con.prepareStatement(prodExist);
            existStmt.setInt(1, prodId);

            ResultSet rst = existStmt.executeQuery();

            if(rst.next()){

                boolean[] update = new boolean[7];
                int[] index = new int[7];
                int curr = 0;
            
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
				String SQL = "UPDATE product SET ";
                

                if(!(prodName == null || prodName.isEmpty())){
                    SQL += "productName = ?, ";
                    update[0] = true;
                    curr++;
                    index[0] = curr;
                }
                if(!(price == 0 )){
                    SQL += "productPrice = ?, ";
                    update[1] = true;
                    curr++;
                    index[1] = curr;
                }
                if(!(imgURL == null || imgURL.isEmpty())){
                    SQL += "profImageURL = ?, ";
                    update[2] = true;
                    curr++;
                    index[2] = curr;
                }
                if(!(desc == null || desc.isEmpty())){
                    SQL += "productDesc = ?, ";
                    update[3] = true;
                    curr++;
                    index[3] = curr;
                }
                if(!(date == null)){
                    SQL += "productDate = ?, ";
                    update[4] = true;
                    curr++;
                    index[4] = curr;
                }
                if(!(profId == 0)){
                    SQL += "profId = ?, ";
                    update[5] = true;
                    curr++;
                    index[5] = curr;
                }
                if(!(inventory == 0)){
                    SQL += "inventory = ?, ";
                    update[6] = true;
                    curr++;
                    index[6] = curr;
                }
                int len = SQL.length();
                SQL = SQL.substring(0, len - 2);
                SQL += " WHERE productId = ?";
				PreparedStatement pstmt = con.prepareStatement(SQL);


                if(update[0] == true){
                    pstmt.setString(index[0], prodName);
                }
                if(update[1] == true){
                    pstmt.setDouble( index[1], price);
                }
                if(update[2] == true){
                    pstmt.setString( index[2], imgURL);
                }
                if(update[3] == true){
                    pstmt.setString(index[3], desc);
                }
                if(update[4] == true){
                    pstmt.setDate( index[4], new java.sql.Date(date.getTime()));
                }
                if(update[5] == true){
                    pstmt.setInt( index[5], profId);
                }
                if(update[6] == true){
                    pstmt.setInt( index[6], inventory);
                }

                pstmt.setInt(++curr, prodId);
				

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

