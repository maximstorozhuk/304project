<%@ page import="java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

<%
// TODO: Include files auth.jsp and jdbc.jsp

%>

<%@ include file="adminAuth.jsp" %>
<%@ include file="jdbc.jsp" %>



<%-- navbar --%>
<%-- <nav class="navbar">
		<div class="container">
			<div class="logo"><a href = "index.jsp">Pay-To-Win</a></div>
			<ul class="nav">

			
				<li>
					
					<p><%= session.getAttribute("authenticatedUser") != null? (String)session.getAttribute("firstName") + "'s" : ""%> </p>
					<a href="customer.jsp">Account</a>
				</li>
				<li>
				
					<a href="order.jsp">Orders</a>
				</li>
				<li>
					<a href="showcart.jsp">Cart</a>
				</li>
			</ul>
		</div>
	</nav> --%>


    <div class = "header">
        <div class = "side-nav">
            <div class = "user">
                <h2><%= session.getAttribute("adminName") %></h2>
            </div>

            <ul>
                <li><a href = 'listprod.jsp'>Products</a></li>
                <li><a href = 'listorder.jsp'>All Orders</a></li>
                <li><a href = 'admin.jsp'>Settings</a></li>
            </ul>

            <ul>
                <li><a href = 'adminLogout.jsp'>Logout</a></li>
            </ul>


        </div>
    
        


        <div class = "dashboard">
            <%
            // TODO: Write SQL query that prints out total order amount by day

            

            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";

            try(Connection con = DriverManager.getConnection(url, uid, pw);){
                NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                String sql = "SELECT CAST(orderDate AS DATE) AS day, SUM(totalAmount) " +
                                "FROM orderSummary " +
                                "GROUP BY CAST(orderDate AS DATE);";
                                

                PreparedStatement pstmt = con.prepareStatement(sql);
                ResultSet rst = pstmt.executeQuery();

                out.println("<div class = 'dashItem'>");
                out.println("<div class = 'dashData'>");
                out.println("<h2>Administrator Sales Report by Day</h2>");

                out.println("<table><tr><th>Order Date</th> <th>Total Order Amount</th></tr>");
                while(rst.next()){
                    Date orderDate = rst.getDate(1);
                    double totalAmount = rst.getDouble(2);

                    out.println("<tr><td>" + orderDate + "</td><td>" + currFormat.format(totalAmount) + "</td></tr>");

                }

                out.println("</table>");
                out.println("</div>");
                out.println("</div>");

                String sql2 = "SELECT customerId, firstName, lastName " +
                                "FROM customer;";
                Statement pstmt2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rst2 = pstmt2.executeQuery(sql2);

                rst2.last();
                int custCount = rst2.getRow();
                rst2.beforeFirst();

                out.println("<div class = 'dashItem'>");
                out.println("<div class = 'dashData'>");
                out.println("<h2>Total Customers</h2>");
                out.println("<h1>" + custCount + "</h1>");
                
                

                

                
                
                out.println("<table><tr><th>Customer ID</th> <th>Name</th></tr>");
                
                
                while(rst2.next()){
                    int custId = rst2.getInt("customerId");
                    String first = rst2.getString("firstName");
                    String last = rst2.getString("lastName");

                    out.println("<tr><td>" + custId + "</td><td>" + first + " " + last + "</td></tr>");
                    

                }
                out.println("</table>");
                out.println("</div>");
                out.println("</div>");

                

                    

            } 	catch(Exception e){
                out.println("<h1>" + e.toString() + "</h1>");
            }




            %>
        </div>

        <div class = "productModule">
            <h1>Product Module</h1>
            <div class = "moduleContainer">
                <div class = "moduleItem">
                    <h3>Add a new Product to your Store</h3>
                    <button type = "button" class = "addProd" id = "addProd">Add Product</button>

                    <div class="form-popup" id="popUpAdd">
                    <form action="addProd.jsp" class="form-container" method = "POST">
                        <input type="text" name="prodName" placeholder="Product Name">
                        <input type="number" min = "1" step = "any" name="price" placeholder="Price">
                        <input type="url" name="imgURL" placeholder="Image URL">
                        <input type="text" name="desc" placeholder="Description">
                        <input type="date" name="date" placeholder="Date">
                        <input type="number" name = "profId" placeholder="Prof. ID">
                        <input type="number" min = "1" name="inventory" placeholder="Inventory">
                        
                        
                        <button type="submit" id = "addSubmit">Submit</button>
                    </form>
                    </div>
                </div>


                


                <div class = "moduleItem">
                    <h3>Update/Delete a Product in your Store</h3>
                    <button type = "button" class = "updateProd" id = "updateProd">Update Product</button>
                    <button type = "button" class = "deleteProd" id = "deleteProd">Delete Product</button>
                

                    <div class="form-popup" id="popUpUpdate">
                        <form action="updateProd.jsp" class="form-container" method = "POST">
                        <input type="number" name="prodId" placeholder="Product ID">
                        <input type="text" name="prodName" placeholder="Product Name">
                        <input type="number" min = "1" step = "any" name="price" placeholder="Price">
                        <input type="url" name="imgURL" placeholder="Image URL">
                        <input type="text" name="desc" placeholder="Description">
                        <input type="date" name="date" placeholder="Date">
                        <input type="text" name="desc" placeholder="Description">
                        <input type="number" min = "1" name="inventory" placeholder="Inventory">
                        
                        <button type="submit" id = "updateSubmit">Submit</button>
                        </form>
                    </div>


                    <div class="form-popup" id="popUpDelete">
                        <form action="deleteProd.jsp" class="form-container" method = "POST">
                        <input type="number" name="prodId" placeholder="Product ID">
                        
                        <button type="submit" id = "updateSubmit">Submit</button>
                        </form>
                    </div>
                </div>

                <%-- <div class = "moduleItem">
                    <h3>Add a Image to a Product</h3>
                    <span> File Uploader
                    <input type="file" id="photo" name="photo" accept=" image/png, image/jpeg"></span>
                </div> --%>

                
            </div>

            <%
                out.println("<script>");
                String addOutcome = (String)session.getAttribute("addOutcome");
                String updateOutcome = (String)session.getAttribute("updateOutcome");
                String deleteOutcome = (String)session.getAttribute("deleteOutcome");
                if(addOutcome != null){
                    if(addOutcome.equals("success")){
                        out.println("alert('Product Added Sucessfully!')");
                        session.setAttribute("addOutcome", null);
                    }else if(addOutcome.equals("failure")){
                        out.println("alert('Error! Product Not Added!')");
                         session.setAttribute("addOutcome", null);
                    }else{
                        out.println("alert('" + addOutcome + "')");
                        session.setAttribute("addOutcome", null);
                    }
                }
                if(updateOutcome != null){
                    if(updateOutcome.equals("success")){
                        out.println("alert('Product Updated Sucessfully!')");
                        session.setAttribute("updateOutcome", null);
                    }else if(updateOutcome.equals("failure")){
                        out.println("alert('Error! Product Not Updated!')");
                        session.setAttribute("updateOutcome", null);
                    }else if(updateOutcome.equals("noID")){
                        out.println("alert('No Product Id Specified!')");
                        session.setAttribute("updateOutcome", null);
                    }else if(updateOutcome.equals("invalidID")){
                        out.println("alert('No Such Product Exists!')");
                        session.setAttribute("updateOutcome", null);
                    }else{
                        out.println("alert('" + updateOutcome + "')");
                        session.setAttribute("updateOutcome", null);
                    }
                }

                if(deleteOutcome != null){
                    if(deleteOutcome.equals("success")){
                        out.println("alert('Product Deleted Sucessfully!')");
                        session.setAttribute("deleteOutcome", null);
                    }else if(deleteOutcome.equals("failure")){
                        out.println("alert('Error! Product Not Deleted!')");
                         session.setAttribute("deleteOutcome", null);
                    }else{
                        out.println("alert('" + deleteOutcome + "')");
                        session.setAttribute("deleteOutcome", null);
                    }
                }


                out.println("</script>");
            %>
        </div>
    </div>
<script src = "showForm.js"></script>
</body>
</html>

