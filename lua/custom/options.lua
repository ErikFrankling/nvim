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

-- 80 column line marker
vim.opt.colorcolumn = '80'

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.termguicolors = true

-- Wrap lines on word boundaries
vim.opt.linebreak = true

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

--[=[

'tabstop' 'ts'		number	(default 8)
			local to buffer
	Number of spaces that a <Tab> in the file counts for.  Also see
	the |:retab| command, and the 'softtabstop' option.

	Note: Setting 'tabstop' to any other value than 8 can make your file
	appear wrong in many places.
	The value must be more than 0 and less than 10000.

	There are five main ways to use tabs in Vim:
	1. Always keep 'tabstop' at 8, set 'softtabstop' and 'shiftwidth' to 4
	   (or 3 or whatever you prefer) and use 'noexpandtab'.  Then Vim
	   will use a mix of tabs and spaces, but typing <Tab> and <BS> will
	   behave like a tab appears every 4 (or 3) characters.
	   This is the recommended way, the file will look the same with other
	   tools and when listing it in a terminal.
	2. Set 'softtabstop' and 'shiftwidth' to whatever you prefer and use
	   'expandtab'.  This way you will always insert spaces.  The
	   formatting will never be messed up when 'tabstop' is changed (leave
	   it at 8 just in case).  The file will be a bit larger.
	   You do need to check if no Tabs exist in the file.  You can get rid
	   of them by first setting 'expandtab' and using `%retab!`, making
	   sure the value of 'tabstop' is set correctly.
	3. Set 'tabstop' and 'shiftwidth' to whatever you prefer and use
	   'expandtab'.  This way you will always insert spaces.  The
	   formatting will never be messed up when 'tabstop' is changed.
	   You do need to check if no Tabs exist in the file, just like in the
	   item just above.
	4. Set 'tabstop' and 'shiftwidth' to whatever you prefer and use a
	   |modeline| to set these values when editing the file again.  Only
	   works when using Vim to edit the file, other tools assume a tabstop
	   is worth 8 spaces.
	5. Always set 'tabstop' and 'shiftwidth' to the same value, and
	   'noexpandtab'.  This should then work (for initial indents only)
	   for any tabstop setting that people use.  It might be nice to have
	   tabs after the first non-blank inserted as spaces if you do this
	   though.  Otherwise aligned comments will be wrong when 'tabstop' is
	   changed.

	The value of 'tabstop' will be ignored if |'vartabstop'| is set to
	anything other than an empty string.
--]=]
