const LAT= 50.4500336;
const LNG = 30.5241361; // kyiv center
const ZOOM = 15;
const SIZE = 48; // size of icons

let dprocessing, mprocessing;

$(function() {
  mprocessing = new MapProcessing();
  dprocessing = new DataProcessing();
 // dprocessing.getData();
 // mprocessing.makeLayer(0, dprocessing.waterData);
 // mprocessing.filter(0);
});


// Map Processing

