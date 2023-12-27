<%@ page language="java" import="java.io.*,java.sql.*,java.util.*, java.text.*"%>
<%

    HashMap<String, ArrayList<Object>> productList = new HashMap<String, ArrayList<Object>>();
    


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

            
			String SQL = "SELECT * FROM incart WHERE customerId = ?";
            PreparedStatement pstmt = con.prepareStatement(SQL);
            

            String custId = (String)session.getAttribute("customerId");
            

            int customerId = Integer.parseInt(custId);
            
            pstmt.setInt(1,customerId);

            ResultSet rst = pstmt.executeQuery();
           

            while(rst.next()){
                
                int id = rst.getInt("productId");
                String name = rst.getString("productName");
                double price = rst.getDouble("price");
                int quantity = rst.getInt("quantity");

                

                ArrayList<Object> product = new ArrayList<Object>();
                product.add(id);
                product.add(name);
                product.add(price);
                product.add(quantity);

                if (productList.containsKey(id))
                {	product = (ArrayList<Object>) productList.get(id);
                    int curAmount = ((Integer) product.get(3)).intValue();
                    product.set(3, new Integer(curAmount+1));
                }
                else
                    productList.put(id + "",product);

                
            }
		}catch(Exception e){
			out.println("<script> alert('Issue with Adding cart to database!!!') </script>");
            session.setAttribute("firstName", "ISSUE");
            
		}

        session.setAttribute("productList", productList);
        session.setAttribute("cartSize", productList.size() + "");
        response.sendRedirect("listprod.jsp");




%>