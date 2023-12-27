//define button and form//
const popUpForm = document.getElementsByClassName("popUpForm");
var addProd = document.getElementById("addProd");
//Form Pop-Up//
//button.onclick = () => {window.open('hello!')};//

//button function//
addProd.addEventListener("click", function() {
  document.getElementById("popUpAdd").style.display = "block";
 
});

var updateProd = document.getElementById("updateProd");
//Form Pop-Up//
//button.onclick = () => {window.open('hello!')};//

//button function//
updateProd.addEventListener("click", function() {
  document.getElementById("popUpUpdate").style.display = "block";
 
});

var deleteProd = document.getElementById("deleteProd");
//Form Pop-Up//
//button.onclick = () => {window.open('hello!')};//

//button function//
deleteProd.addEventListener("click", function() {
  document.getElementById("popUpDelete").style.display = "block";
 
});



// var addSubmit = document.getElementById("addSubmit");
// addSubmit.addEventListener("click", function() {
//     document.getElementById("popUpAdd").style.display = "none";
//     alert("Product Added to Database!")
   
//   });

// var updateSubmit = document.getElementById("updateSubmit");
// updateSubmit.addEventListener("click", function(){
//     document.getElementById("popUpUpdate").style.display = "none";
//     alert("Product Details Updated!")
// })