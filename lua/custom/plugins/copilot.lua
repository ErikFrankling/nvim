return {
  {
    'zbirenbaum/copilot.lua',
    opts = {
      -- copilot_node_command = 'node',
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = '<C-Space>',
          accept_word = '<S-Tab>',
          accept_line = false,
          next = false,
          prev = false,
          dismiss = false,
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        help = true,
        gitcommit = true,
        gitrebase = true,
        hgcommit = true,
        svn = true,
        cvs = true,
        ['.'] = true,
      },
      -- logger = {
      --   file = vim.fn.stdpath 'log' .. '/copilot-lua.log',
      --   file_log_level = vim.log.levels.INFO,
      --   trace_lsp = 'verbose', -- "off" | "messages" | "verbose"
      --   trace_lsp_progress = true,
      --   log_lsp_messages = true,
      -- },
    },
  },
}
