return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {
      'HiPhish/rainbow-delimiters.nvim',
      init = function()
        ---@type rainbow_delimiters.config
        vim.g.rainbow_delimiters = {
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
  config = function()
    local ts = require('nvim-treesitter')

    -- When not using nix, install parsers explicitly
    -- (nix provides all grammars via nvim-treesitter.withAllGrammars)
    if not require('nixCatsUtils').isNixCats then
      ts.install { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc' }
    end

    -- Enable treesitter highlighting and indentation per filetype
    local disabled_hl = { latex = true, tex = true }
    local disabled_indent = { ruby = true }

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-setup', { clear = true }),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match) or ev.match

        if not disabled_hl[ev.match] then
          pcall(vim.treesitter.start, ev.buf, lang)
        end

        if not disabled_indent[ev.match] then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

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
  end,
}
