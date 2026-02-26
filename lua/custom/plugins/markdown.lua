-- https://linkarzu.com/posts/neovim/markdown-setup-2024/#markdown-plugins

return {
  'iamcco/markdown-preview.nvim',
  -- cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'markdown' },
  -- build = function()
  --   vim.fn['mkdp#util#install']()
  -- end,
  -- build = 'cd app && yarn install',
  init = function()
    vim.cmd [[
      function OpenMarkdownPreview (url)
        "" execute "silent ! firefox --new-window " . a:url
        call jobstart(['qutebrowser', '--target', 'window', a:url])
      endfunction
    ]]

    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_theme = 'dark'
    -- vim.g.mkdp_auto_start = 1
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_browserfunc = 'OpenMarkdownPreview'
  end,

  -- { 'ellisonleao/glow.nvim', config = true, cmd = 'Glow' },
}
