local M = {}

M.run_test_command = function(test_cmd, spinner_msg, success_msg, fail_msg)
  local output = {}
  local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local spinner_index = 1
  local spinning = true

  local function spin()
    if not spinning then
      return
    end
    vim.api.nvim_echo({ { spinner_frames[spinner_index] .. " " .. spinner_msg, "ModeMsg" } }, false, {})
    spinner_index = (spinner_index % #spinner_frames) + 1
    vim.defer_fn(spin, 100)
  end

  spin()

  vim.fn.jobstart(test_cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,
    on_exit = function(_, code)
      spinning = false
      vim.schedule(function()
        vim.api.nvim_echo({ { "", "None" } }, false, {}) -- clear spinner

        local result = (code == 0) and ("✅ " .. success_msg) or ("❌ " .. fail_msg)
        vim.api.nvim_echo({ { result, (code == 0) and "MoreMsg" or "ErrorMsg" } }, false, {})

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
        vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.6),
          row = math.floor(vim.o.lines * 0.2),
          col = math.floor(vim.o.columns * 0.1),
          style = "minimal",
          border = "rounded",
        })
      end)
    end,
  })
end

return M
