// const express = require('express');
// const router = express.Router();
// const multer = require('multer');
// const fs = require('fs');
// const canvas = require('canvas');
// const faceapi = require('face-api.js');
// const FaceModel = require('../model/face.model'); // optional
// const { Canvas, Image, ImageData } = canvas;

// faceapi.env.monkeyPatch({ Canvas, Image, ImageData });

// const MODEL_PATH = './models';

// // Load models
// Promise.all([
//   faceapi.nets.ssdMobilenetv1.loadFromDisk(MODEL_PATH),
// ]).then(() => console.log('FaceAPI models loaded'));

// // Multer setup
// const upload = multer({ dest: 'uploads/' });

// router.post('/detect-face', upload.single('image'), async (req, res) => {
//   try {
//     const img = await canvas.loadImage(req.file.path);
//     const detections = await faceapi.detectAllFaces(img);

//     // Optional: Save to DB
//     await FaceModel.create({
//       timestamp: new Date(),
//       faces: detections.map(d => d.box),
//     });

//     fs.unlinkSync(req.file.path); // Clean up
//     res.status(200).json({ faces: detections.map(d => d.box) });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ error: 'Face detection failed' });
//   }
// });

// module.exports = router;
