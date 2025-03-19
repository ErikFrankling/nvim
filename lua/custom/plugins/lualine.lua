return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'AndreM222/copilot-lualine',
    },
    opts = {
      -- theme = 'onedark',
      theme = 'tokyonight',
      sections = {
        lualine_x = {
          {
            'copilot',
            symbols = {
              status = {
                hl = {
                  sleep = '#50FA7B',
                },
              },
            },
            show_colors = true,
          },
          'encoding',
          'fileformat',
          'filetype',
        },
      },
    },
  },
}
