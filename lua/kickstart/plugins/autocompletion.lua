return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      -- NOTE: nixCats: nix downloads it with a different file name.
      -- tell lazy about that.
      name = 'luasnip',
      build = require('nixCatsUtils').lazyAdd((function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)()),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        -- {
        --   'rafamadriz/friendly-snippets',
        --   config = function()
        --     require('luasnip.loaders.from_vscode').lazy_load()
        --   end,
        -- },
      },
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    -- https://github.com/topics/nvim-cmp
    -- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'kdheepak/cmp-latex-symbols',
    'hrsh7th/cmp-buffer',
    'f3fora/cmp-spell',
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert {
        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ['<C-y>'] = cmp.mapping.confirm { select = true },

        -- force llm completion
        ['<A-y>'] = require('minuet').make_cmp_map(),

        -- Scroll the documentation window
        ['<A-j>'] = cmp.mapping.scroll_docs(-4),
        ['<A-k>'] = cmp.mapping.scroll_docs(4),

        ['<C-j>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        -- Select the [n]ext item
        -- ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        -- ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- If you prefer more traditional completion keymaps,
        -- you can uncomment the following lines
        --['<CR>'] = cmp.mapping.confirm { select = true },
        --['<Tab>'] = cmp.mapping.select_next_item(),
        --['<S-Tab>'] = cmp.mapping.select_prev_item(),

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        -- ['<C-Space>'] = cmp.mapping.complete {},

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        -- ['<C-l>'] = cmp.mapping(function()
        --   if luasnip.expand_or_locally_jumpable() then
        --     luasnip.expand_or_jump()
        --   end
        -- end, { 'i', 's' }),
        -- ['<C-h>'] = cmp.mapping(function()
        --   if luasnip.locally_jumpable(-1) then
        --     luasnip.jump(-1)
        --   end
        -- end, { 'i', 's' }),

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },
      sources = {
        { name = 'nvim_lsp', priority = 20 },
        {
          name = 'buffer',
          priority = 9,
          -- use all opened buffers but not larger than 1Mb
          -- From: https://www.reddit.com/r/neovim/comments/16o22w0/comment/k1j8g62/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
          option = {
            indexing_interval = 1000,
            max_indexed_line_length = 512,
            get_bufnrs = function()
              local bufs = vim.api.nvim_list_bufs()

              local result = {}
              for _, v in ipairs(bufs) do
                local byte_size = vim.api.nvim_buf_get_offset(v, vim.api.nvim_buf_line_count(v))
                if byte_size < 1024 * 1024 then
                  result[#result + 1] = v
                end
              end

              return result
            end,
          },
        },
        { name = 'latex-latex-symbols' },
        { name = 'luasnip' },
        { name = 'path' },
        {
          name = 'spell',
          option = {
            keep_all_entries = false,
            enable_in_context = function()
              return true
            end,
            preselect_correct_word = true,
          },
        },
      },
    }
  end,
}
