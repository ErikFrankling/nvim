-- https://linkarzu.com/posts/neovim/markdown-setup-2024/#markdown-plugins

return {
  'iamcco/markdown-preview.nvim',
  -- cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  -- ft = { 'markdown' },
  -- build = function()
  --   vim.fn['mkdp#util#install']()
  -- end,
  -- build = 'cd app && yarn install',
  -- cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  init = function()
    vim.g.mkdp_auto_start = 0
    vim.cmd [[
    function OpenMarkdownPreview (url)
      execute "silent ! firefox --new-window " . a:url
    endfunction
    let g:mkdp_browserfunc = 'OpenMarkdownPreview'
  ]]
    --   vim.g.mkdp_filetypes = { 'markdown' }
  end,
  -- ft = { 'markdown' },

  -- { 'ellisonleao/glow.nvim', config = true, cmd = 'Glow' },
}
