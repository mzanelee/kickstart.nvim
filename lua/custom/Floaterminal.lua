local M = {}
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

function create_floating_window(opts)
  opts = opts or {}
  local cols = vim.o.columns
  local lines = vim.o.lines
  local width = opts.width or math.floor(cols * 0.8)
  local height = opts.height or math.floor(lines * 0.8)
  local row = math.floor((lines - height) / 2)
  local col = math.floor((cols - width) / 2)

  local buf = nil
  if opts.buf ~= nil and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

M.toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
  vim.api.nvim_command 'startinsert'
end

return M
