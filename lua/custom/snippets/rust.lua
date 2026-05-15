local ls = require 'luasnip'
local f = ls.function_node
local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local snippet_from_nodes = ls.sn

local function inside_impl()
  local node = vim.treesitter.get_node()
  while node do
    if node:type() == "impl_item" then return true end
    node = node:parent()
  end
  return false
end

ls.add_snippets('rust', {
  s('backtrace', {
    t { 'eprintln!("BACKTRACE: {}:{}\\n{}", file!(), line!(), std::backtrace::Backtrace::capture());' },
  }),
})



-- Simple plot
-- use eframe::egui;
-- use egui_plot::{Line, Plot, PlotPoints};
--
-- struct App {
--     data: Vec<[f64; 2]>,
--     t: f64,
-- }
--
-- impl eframe::App for App {
--
--     fn ui(&mut self, ui: &mut egui::Ui, frame: &mut eframe::Frame) {
--         // Simulate incoming data
--         self.data.push([self.t, self.t.sin()]);
--         self.t += 0.05;
--
--         egui::CentralPanel::default().show_inside(ui, |ui| {
--             Plot::new("streaming_plot")
--                 .show(ui, |plot_ui| {
--                     plot_ui.line(Line::new("aline", PlotPoints::from(self.data.clone())));
--                 });
--         });
--
--         ui.request_repaint(); // keep updating
--     }
-- }
--
-- fn main() {
--     let app = App {
--         data: vec![],
--         t: 0.0,
--     };
--
--     eframe::run_native(
--         "Streaming Plot",
--         eframe::NativeOptions::default(),
--         Box::new(|_| Ok(Box::new(app))),
--     )
--     .unwrap();
-- }
