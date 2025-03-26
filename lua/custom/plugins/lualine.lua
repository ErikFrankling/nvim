return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'AndreM222/copilot-lualine',
      'bercly0b/lualine-lsp-progress',
    },
    opts = {
      -- theme = 'onedark',
      theme = 'tokyonight',
      sections = {
        lualine_x = {
          {
            'lsp_progress',
            -- Display the lsp client name after initialization
            display_lsp_name_after_initialization = true,
            display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
            spinner_symbols = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
          },
          {
            'copilot',
            symbols = {
              status = {
                hl = {
                  sleep = '#50FA7B',
                },
              },
              spinners = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
            },
            show_colors = true,
          },
        },
        lualine_y = {
          -- 'encoding',
          -- 'fileformat',
          'filetype',
        },
      },
    },
  },
}
