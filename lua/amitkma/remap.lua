vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

vim.keymap.set("n", "<leader>vwm", function()
  require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
  require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", function()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  local supports_formatting = false

  -- Check if any attached LSP supports formatting
  for _, client in ipairs(clients) do
    if client.server_capabilities.documentFormattingProvider then
      supports_formatting = true
      break
    end
  end

  if supports_formatting then
    vim.lsp.buf.format { async = true }
  else
    require("conform").format { async = true }
  end
end, { silent = true, noremap = true })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

vim.keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')

vim.keymap.set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')

vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')

vim.keymap.set("n", "<leader>ca", function()
  require("cellular-automaton").start_animation "make_it_rain"
end)

vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd "so"
end)

-- sets window size = ideal size for 2 buffers and 2 terms
vim.keymap.set("n", "<C-w>.", "<C-w>=z12<CR>")

-- for moving around windows
vim.keymap.set("n", "<leader>h", "<C-W><C-H>")
vim.keymap.set("n", "<leader>j", "<C-W><C-J>")
vim.keymap.set("n", "<leader>k", "<C-W><C-K>")
vim.keymap.set("n", "<leader>l", "<C-W><C-L>")

-- git diff
vim.keymap.set("n", "<leader>oo", "<cmd>DiffviewOpen<cr>")
vim.keymap.set("n", "<leader>oc", "<cmd>DiffviewClose<cr>")

-- Run python django tests
local test_runner = require "amitkma.test_runner"
vim.keymap.set("n", "<leader>tf", function()
  local word = vim.fn.expand "<cword>"
  local test_cmd = ""

  -- Check if manage.py exists in the current or parent directories
  if vim.fn.filereadable "manage.py" == 1 or vim.fn.findfile("manage.py", ".;") ~= "" then
    test_cmd = "python manage.py test -k " .. word
  else
    test_cmd = "pytest -k " .. word
  end
  test_runner.run_test_command(test_cmd, "Running test " .. word .. " ...", "Test passed", "Test failed")
end, { desc = "Run test under cursor (project-aware)", noremap = true })

vim.keymap.set("n", "<leader>tc", function()
  local word = vim.fn.expand "<cword>" -- assumes cursor is on class name
  local file_path = vim.fn.expand "%:p"
  local rel_path = vim.fn.fnamemodify(file_path, ":.")
  local module_name = rel_path:gsub("/", "."):gsub("%.py$", "")

  local test_cmd = ""

  if vim.fn.filereadable "manage.py" == 1 or vim.fn.findfile("manage.py", ".;") ~= "" then
    test_cmd = "python manage.py test " .. module_name .. "." .. word
  else
    test_cmd = "pytest " .. rel_path .. "::" .. word
  end
  test_runner.run_test_command(
    test_cmd,
    "Running module " .. module_name .. " tests...",
    "Module tests passed",
    "Module tests failed"
  )
end, { desc = "Run test class under cursor", noremap = true })

vim.keymap.set("n", "<leader>ta", function()
  local test_cmd = "make -f execute_tests.mk"
  test_runner.run_test_command(test_cmd, "Running all tests...", "All tests passed", "Some or all tests failed")
end, { desc = "Run test class under cursor", noremap = true })
