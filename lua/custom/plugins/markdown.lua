-- https://linkarzu.com/posts/neovim/markdown-setup-2024/#markdown-plugins

return {
  'iamcco/markdown-preview.nvim',
  -- cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  -- ft = { 'markdown' },
  -- build = function()
  --   vim.fn['mkdp#util#install']()
  -- end,

  -- 'iamcco/markdown-preview.nvim',
  -- cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  -- build = 'cd app && yarn install',
  -- init = function()
  --   vim.g.mkdp_filetypes = { 'markdown' }
  -- end,
  -- ft = { 'markdown' },

  -- function OpenMarkdownPreview (url)
  --    execute "silent ! firefox --new-window " . a:url
  --  end
  --  vim.g.mkdp_browserfunc = 'OpenMarkdownPreview'
  --  end,

  -- { 'ellisonleao/glow.nvim', config = true, cmd = 'Glow' },
}
