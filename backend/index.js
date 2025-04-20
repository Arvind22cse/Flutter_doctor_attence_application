const express = require("express");
const app = express();
var cors = require("cors");
const mongoose = require("mongoose");
const dotenv = require("dotenv").config();
const router = require("./routes/route.js");
const session = require("express-session");
const multer = require('multer');
const Attendance = require("./model/attendance.model.js");
const Doctor = require("./model/doctor.model.js");
const uploadRoutes = require('./routes/upload.js');



app.use(express.json());
app.use(express.urlencoded({ extended: true }));



app.use(cors());


app.use(
  session({
    secret: process.env.SESSION_SECRET, // Use a strong secret key
    resave: false,
    saveUninitialized: false, // Do not save uninitialized sessions
    cookie: {
      secure: false, // Set to true if using HTTPS
      httpOnly: true, // Prevent client-side JS from accessing the cookie
      maxAge: 1000 * 60 * 60 * 24, // Session duration (e.g., 1 day)
    },
  })
);

app.use("/api", router);
app.use("/uploads", uploadRoutes);

mongoose
  .connect("mongodb+srv://arvindm22cse:31-Aug-04@hospital.jyifl.mongodb.net/?retryWrites=true&w=majority&appName=Hospital")
  .then((result) => {
    console.log("connected to mongodb");
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });





  app.listen(3000, '0.0.0.0', () => {
    console.log('Server is running on port 3000');
  });
  