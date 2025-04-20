const mongoose = require("mongoose");

const attendanceSchema = new mongoose.Schema({
  doctorId: {
    type: String,
    required: true,
  },
  address: {
    type: String,
    required: true,
  },
  date: {
    type: String, // e.g., "2025-04-20"
    required: true,
  },
  check_in: {
    type: Date, // ✅ actual timestamp for check-in
    required: true,
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
});

const Attendance = mongoose.model("Atten", attendanceSchema);
module.exports = Attendance;
