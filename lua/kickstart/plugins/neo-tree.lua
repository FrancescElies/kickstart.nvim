-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          -- diff
          ['D'] = {
            function(state)
              local node = state.tree:get_node()
              local log = require 'neo-tree.log'
              state.clipboard = state.clipboard or {}
              if DIFF_NODE and DIFF_NODE ~= tostring(node.id) then
                local current_Diff = node.id
                require('neo-tree.utils').open_file(state, DIFF_NODE)
                vim.cmd('vert diffs ' .. current_Diff)
                log.info('Diffing ' .. DIFF_NAME .. ' against ' .. node.name)
                DIFF_NODE = nil
                current_Diff = nil
                state.clipboard = {}
                require('neo-tree.ui.renderer').redraw(state)
              else
                local existing = state.clipboard[node.id]
                if existing and existing.action == 'diff' then
                  state.clipboard[node.id] = nil
                  DIFF_NODE = nil
                  require('neo-tree.ui.renderer').redraw(state)
                else
                  state.clipboard[node.id] = { action = 'diff', node = node }
                  DIFF_NAME = state.clipboard[node.id].node.name
                  DIFF_NODE = tostring(state.clipboard[node.id].node.id)
                  log.info('Diff source file ' .. DIFF_NAME)
                  require('neo-tree.ui.renderer').redraw(state)
                  vim.cmd 'norm! j'
                end
              end
            end,
            desc = 'diff files',
          },
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
