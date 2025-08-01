return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {
      'HiPhish/rainbow-delimiters.nvim',
      init = function()
        ---@type rainbow_delimiters.config
        vim.g.rainbow_delimiters = {
          -- strategy = {
          --   [''] = 'rainbow-delimiters.strategy.global',
          --   vim = 'rainbow-delimiters.strategy.local',
          -- },
          -- query = {
          --   [''] = 'rainbow-delimiters',
          --   lua = 'rainbow-blocks',
          --   go = 'rainbow-blocks',
          -- },
          -- priority = {
          --   [''] = 110,
          --   -- lua = 210,
          -- },
          highlight = {
            'RainbowDelimiterWhite',
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
          },
        }
      end,
    },
  },
  build = require('nixCatsUtils').lazyAdd ':TSUpdate',
  opts = {
    -- NOTE: nixCats: use lazyAdd to only set these 2 options if nix wasnt involved.
    -- because nix already ensured they were installed.
    ensure_installed = require('nixCatsUtils').lazyAdd { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
    auto_install = require('nixCatsUtils').lazyAdd(true, false),

    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
      disable = { 'latex' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
  config = function(_, opts)
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

    -- Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)

    vim.filetype.add {
      extension = {
        gotmpl = 'gotmpl',
      },
      pattern = {
        ['.*/templates/.*%.tpl'] = 'helm',
        ['.*/templates/.*%.ya?ml'] = 'helm',
        ['helmfile.*%.ya?ml'] = 'helm',
      },
    }

    -- local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    -- -- Ensure gotmpl only applies to helm templates
    -- parser_config.gotmpl.used_by = { 'gohtmltmpl', 'gotexttmpl', 'gotmpl', 'helm' }

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  end,
}
