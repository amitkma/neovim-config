local M = {}

function M.setup()
  local icon = require "amitkma.icons"
  local lualine = require "lualine"

  local filetype = { "filetype", icon_only = false }

  local lsp_status = {
    "lsp_status",
    icon = "", -- f013
    symbols = {
      spinner = icon.spinner,
      done = false,
      separator = " ",
    },
    -- List of LSP names to ignore (e.g., `null-ls`):
    ignore_lsp = {},
  }

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn", "info", "hint" },
    symbols = {
      error = icon.diagnostics.Error,
      hint = icon.diagnostics.Hint,
      info = icon.diagnostics.Info,
      warn = icon.diagnostics.Warning,
    },
    colored = true,
    update_in_insert = false,
    always_visible = false,
  }

  local nvimbattery = {
    function()
      return require("battery").get_status_line()
    end,
  }

  lualine.setup {
    options = {
      theme = "auto",
      globalstatus = true,
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
      disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { "filename", lsp_status },
      lualine_x = { "diff", diagnostics, filetype },
      lualine_y = { "progress" },
      lualine_z = { "location", nvimbattery },
    },
    winbar = {
      lualine_a = {},
      lualine_b = { { "filetype", icon_only = true } },
      lualine_c = { { "filename", path = 3 } },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { "datetime" },
    },
  }
end

return M
