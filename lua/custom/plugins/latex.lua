return {
  -- {
  --   'lervag/vimtex',
  --   config = function()
  --     vim.g.vimtex_view_general_viewer = ''
  --     vim.g.vimtex_view_general_options = '--synctex-forward'
  --     vim.g.vimtex_view_general_options_latexmk = '--synctex-forward'
  -- -- vim.g.vimtex_compiler_method = 'latexmk'
  --     -- vim.g.vimtex_compiler_latexmk = {
  --     --   options = {
  --     --     '-pdf',
  --     --     '-file-line-error',
  --     --     '-synctex=1',
  --     --     '-interaction=nonstopmode',
  --     --   },
  --     -- }
  --     -- vim.g.vimtex_quickfix_mode = 0
  --     -- vim.g.vimtex_quickfix_open_on_warning = 0
  --     -- vim.g.vimtex_quickfix_open_on_error = 0
  --     -- vim.g.vimtex_quickfix_open_on_latex_error = 0
  --     -- vim.g.vimtex_quickfix_open_on_warning = 0
  --     -- vim.g.vimtex_quickfix_open_on_error = 0
  --   end,
  -- },
  {
    'lervag/vimtex',
    lazy = false,
    -- tag = "v2.15", -- uncomment to pin to a specific release
    config = function()
      --global vimtex settings
      vim.g.vimtex_imaps_enabled = 0 --i.e., disable them

      --vimtex_view_settings
      vim.g.vimtex_view_method = 'zathura'
      -- vim.g.vimtex_view_general_viewer = 'texpresso'
      -- vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'

      vim.g.vimtex_compiler_method = 'latexmk'
      -- let maplocalleader = '\\'

      --quickfix settings
      vim.g.vimtex_quickfix_open_on_warning = 0 --  don't open quickfix if there are only warnings
      vim.g.vimtex_quickfix_ignore_filters =
        { 'Underfull', 'Overfull', 'LaTeX Warning: .\\+ float specifier changed to', 'Package hyperref Warning: Token not allowed in a PDF string' }
    end,
  },
  {
    'let-def/texpresso.vim',
    lazy = false,
    setup = function()
      -- vim.g.texpresso_viewer = 'SumatraPDF'
      -- vim.g.texpresso_forward_search = 1
      -- vim.g.texpresso_open_cmd = 'silent !start SumatraPDF -reuse-instance'
    end,
  },
}
