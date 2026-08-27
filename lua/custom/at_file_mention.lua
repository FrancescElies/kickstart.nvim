-- Copilot-style "@file" mentions in Markdown buffers.
-- Press @ to insert "@<path-relative-to-cwd>".

local M = {}

local namespace = vim.api.nvim_create_namespace 'at_mention'

local function to_relative(path, cwd)
  path = vim.fn.fnamemodify(path, ':p')
  cwd = vim.fn.fnamemodify(cwd, ':p')

  local relative = vim.fs.relpath(cwd, path) or path
  return relative:gsub('\\', '/')
end

local function insert_text(buf, win, row, col, text)
  if not vim.api.nvim_buf_is_valid(buf) then return end

  if not vim.api.nvim_win_is_valid(win) then return end

  vim.api.nvim_set_current_win(win)

  vim.api.nvim_buf_set_text(buf, row - 1, col, row - 1, col, { text })

  vim.api.nvim_win_set_cursor(win, { row, col + #text })
  vim.cmd 'startinsert'
end

local function get_entry_path(entry)
  if not entry then return nil end

  return entry.path or entry.filename or entry.value or entry[1]
end

---Open a file picker and insert a mention.
---@param opts table|nil
function M.trigger(opts)
  opts = opts or {}

  local prefix = opts.prefix or '@'
  local cwd = opts.cwd or vim.fn.getcwd()

  local ok, builtin = pcall(require, 'telescope.builtin')
  if not ok then
    vim.notify('at_mention: telescope.nvim is not available', vim.log.levels.ERROR)
    return
  end

  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local row, col = unpack(vim.api.nvim_win_get_cursor(win))

  -- Track the insertion position if the buffer changes while Telescope is open.
  local mark = vim.api.nvim_buf_set_extmark(buf, namespace, row - 1, col, {
    right_gravity = false,
  })

  local handled = false

  local function place(text)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then return end

      local position = vim.api.nvim_buf_get_extmark_by_id(buf, namespace, mark, {})

      if #position == 0 then return end

      local mark_row, mark_col = position[1], position[2]

      insert_text(buf, win, mark_row + 1, mark_col, text)
      vim.api.nvim_buf_del_extmark(buf, namespace, mark)
    end)
  end

  local picker_opts = vim.tbl_deep_extend('force', {
    cwd = cwd,
    prompt_title = 'Insert file mention',

    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        handled = true

        local entry = action_state.get_selected_entry()
        local path = get_entry_path(entry)

        actions.close(prompt_bufnr)

        if path then
          place(prefix .. to_relative(path, cwd))
        else
          place(prefix)
        end
      end)

      -- Escape, Ctrl-C, q, or any other unhandled close inserts the prefix.
      vim.api.nvim_create_autocmd('BufWipeout', {
        buffer = prompt_bufnr,
        once = true,
        callback = function()
          if not handled then place(prefix) end
        end,
      })

      return true
    end,
  }, opts.picker or {})

  builtin.find_files(picker_opts)
end

---Set up the insert-mode trigger.
---@param opts table|nil
function M.setup(opts)
  opts = opts or {}

  local filetypes = opts.filetypes or { 'markdown' }
  local prefix = opts.prefix or '@'

  local group = vim.api.nvim_create_augroup('AtMention', {
    clear = true,
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = filetypes,
    callback = function(args)
      vim.keymap.set(
        'i',
        prefix,
        function()
          M.trigger {
            prefix = prefix,
            cwd = opts.cwd,
            picker = opts.picker,
          }
        end,
        {
          buffer = args.buf,
          desc = 'Insert file mention',
        }
      )
    end,
  })
end

return M
