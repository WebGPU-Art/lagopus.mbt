import * as Lagopus from "@webgpu-art/lagopus";
import { compFlatButton } from "@webgpu-art/lagopus/lib/comp/button";

/** TODO using component from index */
window.compFlatButton = compFlatButton;

window.Lagopus = Lagopus;

console.log("Lagopus loaded", Lagopus);

// load js code which Vite does not detect
import("../target/js/debug/build/main/main.js")
  .then((module) => {
    console.log("mbt app loaded", module);
  })
  .catch((error) => {
    console.error("mbt app loading error", error);
  });
