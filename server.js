var express = require("express");
var app = express();
var fs = require("fs");
const cors = require("cors");
app.use(cors());
app.use(express.json());


app.get("/listUsers", function (req, res) {
  fs.readFile(__dirname + "/" + "users.json", "utf8", function (err, data) {
    console.log(data);
    res.end(data);
  });
});
app.get("/listRestu", function (req, res) {
  fs.readFile(
    __dirname + "/" + "resturants.json",
    "utf8",
    function (err, data) {
      console.log(data);
      res.end(data);
    }
  );
});

var users = JSON.parse(fs.readFileSync("resturants.json", "UTF-8"));
app.get("/user/:product", function (req, res) {
  var name = req.params.name; // will contains data from :id, the + is to parse string to integer
  var user = users.find((u) => u.name === name); // find user from users using .find method
  res.send(user); // send the data
});

app.get("/listprodcut", function (req, res) {
  fs.readFile(__dirname + "/" + "products.json", "utf8", function (err, data) {
    console.log(data);
    res.end(data);
  });
});

var products = JSON.parse(fs.readFileSync("products.json", "UTF-8"));
app.get("/listprodcut/:name", function (req, res) {
  var name = req.params.name; // will contains data from :id, the + is to parse string to integer
  var product = products.filter((u) => u.name.includes(name)); // find user from users using .find method
  res.send(product); // send the data
});

app.post("/signUp/:email/:password", function (req, res) {
   var email = req.params.email
   var password = req.params.password

   console.log(email, password);
   // file system module to perform file operations
   if (req.params == {} || req.params == null) {
      res.status(404).send("Invalid input.");
   } else {
      fs.readFile(__dirname + "/" + "users.json", "utf8", function (err, data) {
         let users = JSON.parse(data);
         console.log(users);
         
     
         exists = users.find((u) => u.email === email);
         if (exists != null) {
           res.status(404).send("email is already taken");
         } else {
           users.push({ 
              "email" : email,
              "password" : password
           });
           var newData = JSON.stringify(users);
           fs.writeFile("users.json", newData, "utf8", function (err) {
             if (err) {
               console.log("An error occured while writing JSON Object to File.");
               return console.log(err);
             }
             console.log("JSON file has been saved.");
             res.send("Sign up successful");
           });
    
         }
       });
   }
   
 });
 
 app.post("/login/:email/:password", function (req, res) {
   email = req.params.email;
   password = req.params.password;
   fs.readFile(__dirname + "/" + "users.json", "utf8", function (err, data) {
     let user = JSON.parse(data);
     console.log(user);
 
     users = user.find((u) => u.email === email && u.password === password);
 
     if (users != null) {
       console.log(users);
       res.send(users);
     } else {
       res.sendStatus(404);
     }
   });
 });

var server = app.listen(80, "0.0.0.0", function () {
  var host = server.address().address;
  var port = server.address().port;
  console.log("Example app listening at http://%s:%s", host, port);
});


