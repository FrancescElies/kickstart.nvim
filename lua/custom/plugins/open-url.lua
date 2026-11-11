-- Open any http(s) link under the cursor in the browser (gx).

local function url_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local init = 1
  while true do
    local s, e = line:find('https?://[%w%-%._~:/%?#%[%]@!%$&%(%)%*%+,;=%%]+', init)
    if not s then return nil end
    -- trailing punctuation is usually not part of the link
    local url = line:sub(s, e):gsub('[%.,;:!%?%)%]]+$', '')
    if col >= s and col <= s + #url - 1 then return url end
    init = e + 1
  end
end

local function open_url_under_cursor()
  local url = url_under_cursor()
  if not url then
    vim.notify('No http(s) link under cursor', vim.log.levels.WARN)
    return
  end
  vim.ui.open(url)
  vim.notify('Opened: ' .. url)
end

vim.api.nvim_create_user_command('OpenUrl', open_url_under_cursor, {})
vim.keymap.set('n', 'gx', open_url_under_cursor, { desc = 'Open http(s) link under cursor' })

-- Open every unique http(s) link in the current buffer.
local function open_all_urls_in_buffer()
  local seen, urls = {}, {}
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    for url in line:gmatch 'https?://[%w%-%._~:/%?#%[%]@!%$&%(%)%*%+,;=%%]+' do
      url = url:gsub('[%.,;:!%?%)%]]+$', '')
      if not seen[url] then
        seen[url] = true
        table.insert(urls, url)
      end
    end
  end
  if #urls == 0 then
    vim.notify('No http(s) links in buffer', vim.log.levels.WARN)
    return
  end
  -- stagger launches: back-to-back browser starts on Windows can drop all but one
  for i, url in ipairs(urls) do
    vim.defer_fn(function() vim.ui.open(url) end, (i - 1) * 400)
  end
  vim.notify(('Opening %d link(s)'):format(#urls))
end

vim.api.nvim_create_user_command('OpenUrls', open_all_urls_in_buffer, {})
vim.keymap.set('n', '<leader>gX', open_all_urls_in_buffer, { desc = 'Open all http(s) links in buffer' })
