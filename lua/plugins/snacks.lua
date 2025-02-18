return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      sections = {
        { section = "terminal", cmd = "colorscript -e square", height = 5, padding = 1 },
        { section = "keys", gap = 1, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
  },
}
