-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  -- NOTE: nixCats: return true only if category is enabled, else false
  enabled = require('nixCatsUtils').enableForCategory 'kickstart-neo-tree',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    -- NOTE: `desc` belongs on the entry itself. lazy.nvim reads [1] as the lhs
    -- and [2] as the rhs and drops every other positional element, so a `desc`
    -- tucked into a third one never reaches the mapping.
    { '<leader>tr', ':Neotree reveal<CR>', desc = '[T]oggle the file t[r]ee' },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['<leader>tr'] = 'close_window',
        },
      },
    },
  },
}
