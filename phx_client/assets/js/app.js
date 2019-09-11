// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css";

// Import dependencies
//
import { init_todos } from "./todos.js";
import "./tailwind.js";

import "phoenix_html";
import LiveSocket from "phoenix_live_view";

let Hooks = {};
Hooks.Todos = {
  mounted() {
    init_todos();
  },
  updated() {
    init_todos();
    document.getElementsByClassName("text-input")[0].value = "";
  },
};

let liveSocket = new LiveSocket("/live", { hooks: Hooks });
liveSocket.connect();
