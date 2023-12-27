<%@ page language="java" import="java.io.*,java.sql.*,java.util.*, java.text.*"%>
<%
	// Remove the user from the session to log them out
	


	// Get the current list of products
	@SuppressWarnings({"unchecked"})
	HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

	if(productList != null){
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();


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

        
        
                

		try(Connection con = DriverManager.getConnection(url, uid, pw);){

			String empty = "DELETE FROM incart WHERE customerId = ?";

			PreparedStatement emptyStmt = con.prepareStatement(empty);
			emptyStmt.setInt(1, Integer.parseInt((String)session.getAttribute("customerId")));

			emptyStmt.executeUpdate();


			double total =0;
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext()) 
			{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();

				//ASSUMPTION THAT IT HAS 4 THINGS
				// if (product.size() < 4)
				// {
				// 	out.println("Expected product with four entries. Got: "+product);
				// 	continue;
				// }

				String SQL = "INSERT INTO incart VALUES (?, ?, ?, ?, ?);";
				PreparedStatement pstmt = con.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt((String)session.getAttribute("customerId")));
				pstmt.setInt(2, Integer.parseInt(product.get(0).toString()));
				pstmt.setString(3, product.get(1).toString());
				pstmt.setInt(4, Integer.parseInt(product.get(3).toString()));
				pstmt.setDouble(5, Double.parseDouble(product.get(2).toString()));

				pstmt.executeUpdate();

				
				


			
			out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
					+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
			out.println("</table>");
			}

		}catch(Exception e){
			out.println("<script> alert('Issue with Adding cart to database!!!') </script>");
				

		}
	}

	session.setAttribute("authenticatedUser",null);
	session.setAttribute("firstName", null);
	session.setAttribute("customerId", null);
	session.setAttribute("productList", null);  //MAYBE MOVE????
	session.setAttribute("cartSize", null);
	session.setAttribute("userType", "customer");

	response.sendRedirect("listprod.jsp");		// Re-direct to main page
%>

