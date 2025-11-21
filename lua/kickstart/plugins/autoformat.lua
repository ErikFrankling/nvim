return {
  -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 1000,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      -- List of formatters: https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
      lua = { 'stylua' },
      clojure = { 'cljfmt' },
      zig = { 'zigfmt' },
      -- php = { 'pretty-php' },
      html = { 'prettierd' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      markdown = { 'prettierd' },
      yaml = { 'prettierd' },
      php = { 'php_cs_fixer' },
      nix = { 'nixfmt' },
      c = { 'clang_format' },
      cpp = { 'clang_format' },
      rust = { 'rustfmt' },

      -- Conform can also run multiple formatters sequentially
      -- python = { 'isort', 'black' },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      -- javascript = { { 'prettierd', 'prettier' } },
    },
  },
}
