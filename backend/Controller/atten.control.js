// In your location.controller.js or a similar file

const mongoose = require("mongoose");
const Attendance = require("../model/atten.model"); // Your attendance model

const postAttendance = async (req, res) => {
  try {
    const { doctorId, address } = req.body;

    // Validate inputs
    if (!doctorId) {
      return res.status(401).json({ message: "Unauthorized. Please log in." });
    }

    if (!address || !address.startsWith("Your current location:")) {
      return res.status(400).json({ message: "Invalid or missing location address." });
    }

    const validAddress = "Your current location:\nPonnar and Sankar Hostel, Perundurai, Erode, Tamil Nadu, 638052, India";

    if (address.trim() !== validAddress.trim()) {
      return res.status(403).json({ message: "Unauthorized location. Attendance not allowed." });
    }

    const date = new Date().toISOString().split("T")[0];
    const check_in = new Date();

    const existingAttendance = await Attendance.findOne({ doctorId, date });
    if (existingAttendance) {
      return res.status(400).json({ message: "Already checked in today" });
    }

    const newAttendance = new Attendance({
      doctorId,
      address,
      date,
      check_in,
    });

    await newAttendance.save();

    res.status(200).json({
      message: "Check-in successful",
      attendance: newAttendance,
    });
  } catch (err) {
    console.error("❌ Error in postAttendance:", err);
    res.status(500).json({ message: "Error marking attendance" });
  }
};

const postCheckOut = async (req, res) => {
  try {
    const { doctorId } = req.body;
    const date = new Date().toISOString().split("T")[0];
    const check_out = new Date();

    const existingAttendance = await Attendance.findOne({ doctorId, date });

    if (!existingAttendance) {
      return res.status(400).json({ message: "Please check-in first before checking out." });
    }

    if (existingAttendance.check_out) {
      return res.status(400).json({ message: "You have already checked out today." });
    }

    existingAttendance.check_out = check_out;
    existingAttendance.isCompleted = true; // Mark attendance as completed

    await existingAttendance.save();

    res.status(200).json({
      message: "Check-out successful",
      attendance: existingAttendance,
    });
  } catch (err) {
    console.error("❌ Error in postCheckOut:", err);
    res.status(500).json({ message: "Error marking check-out" });
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

module.exports = { postAttendance ,getatten ,postCheckOut};
