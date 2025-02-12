// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");

module.exports = {
  content: ["./js/**/*.js", "../lib/jwb_web.ex", "../lib/jwb_web/**/*.*ex"],
  theme: {},
  plugins: [require("@tailwindcss/forms"), require("@tailwindcss/typography")],
};
