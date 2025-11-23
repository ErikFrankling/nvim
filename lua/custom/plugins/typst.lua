return {
  'chomosuke/typst-preview.nvim',
  -- lazy = false, -- or ft = 'typst'
  ft = 'typst',
  version = '1.*',
  opts = {
    open_cmd = 'qutebrowser %s',
    debug = true,
    port = 8765, -- Use a fixed port
    -- point to binaries if you manage them via Mason or system PATH
    dependencies_bin = { tinymist = 'tinymist', websocat = 'websocat' },
    follow_cursor = true,
  },
  config = function(_, opts)
    require('typst-preview').setup(opts)

    -- auto-start the preview (and thus open qutebrowser) when entering a typst buffer
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'typst',
      callback = function()
        pcall(vim.cmd, 'TypstPreview')
      end,
    })
  end,
  -- 'al-kot/typst-preview.nvim',
  -- opts = {
  --   -- your config here
  -- },
}
