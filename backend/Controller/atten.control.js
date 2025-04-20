// In your location.controller.js or a similar file

const mongoose = require("mongoose");
const Attendance = require("../model/atten.model"); // Your attendance model
 // adjust the path
// const locationModel = require("../models/location.model"); // not needed if hardcoded

const postAttendance = async (req, res) => {
  try {
    const { doctorId, address } = req.body;

    // Step 1: Validate inputs
    if (!doctorId) {
      return res.status(401).json({ message: "Unauthorized. Please log in." });
    }

    if (!address || !address.startsWith("Your current location:")) {
      return res.status(400).json({ message: "Invalid or missing location address." });
    }

    // Step 2: Hardcoded valid address check
    const validAddress = "Your current location:\nPonnar and Sankar Hostel, Perundurai, Erode, Tamil Nadu, 638052, India";

    if (address.trim() !== validAddress.trim()) {
      return res.status(403).json({ message: "Unauthorized location. Attendance not allowed." });
    }

    const date = new Date().toISOString().split("T")[0];
    const check_in = new Date(); // ✅ Correct: returns a Date object with current date and time


    // Step 3: Prevent duplicate check-in
    const existingAttendance = await Attendance.findOne({ doctorId, date });
    if (existingAttendance) {
      return res.status(400).json({ message: "Already checked in today" });
    }

    // Step 4: Save attendance
    const newAttendance = new Attendance({
      doctorId,
      address,
      date,
      check_in,
      timestamp: new Date(),
    });

    await newAttendance.save();

    console.log("✅ Attendance marked for doctor:", doctorId);
    res.status(200).json({
      message: "Check-in successful",
      attendance: newAttendance,
    });
  } catch (err) {
    console.error("❌ Error in postAttendance:", err);
    res.status(500).json({ message: "Error marking attendance" });
  }
};

const getatten = async(req,res) => {
    try{
      
        const loc = await Attendance.find(); 
        res.status(200).json(loc);
    } catch(err) {
        console.log(err);
        res.status(500).send("Error fetching location data");
    }
}

module.exports = { postAttendance ,getatten };
