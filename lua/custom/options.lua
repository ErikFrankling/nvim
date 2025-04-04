-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '→ ', trail = '·', nbsp = '␣', space = '⋅' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.termguicolors = true

-- Wrap lines on word boundaries
vim.opt.linebreak = true
-- Show a break character at start of line for wrapped lines
vim.opt.showbreak = '↪ '

-- Make a line a culumn of characters
vim.opt.colorcolumn = '80'

-- make nvim read after/ftplugin/*
vim.opt.filetype = 'on'

-- Only indent as far as the next indent level not the next entire tabwidth
vim.opt.smarttab = true

-- Create an augroup for the autocmd
local override_tabstop_group = vim.api.nvim_create_augroup('OverrideTabstop', { clear = true })

-- Create an autocmd that sets tabstop to 4 on every buffer entry overriding vim-sleuth
vim.api.nvim_create_autocmd('BufEnter', {
  group = override_tabstop_group,
  pattern = '*',
  callback = function()
    vim.opt_local.tabstop = 4
  end,
})
