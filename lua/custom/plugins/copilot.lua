return {
  {
    'zbirenbaum/copilot.lua',
    opts = {
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
      logger = {
        file = vim.fn.stdpath 'log' .. '/copilot-lua.log',
        file_log_level = vim.log.levels.INFO,
        trace_lsp = 'verbose', -- "off" | "messages" | "verbose"
        trace_lsp_progress = true,
        log_lsp_messages = true,
      },
      should_attach = function(_, _)
        print 'Checking if Copilot should be attached'
        local data = require('copilot_toggle').getdata()

        if data.COPILOT_ON then
          print 'Attaching Copilot'
        else
          print 'Not attaching Copilot'
        end

        return data.COPILOT_ON
      end,
    },
    -- config = function()
    --   local cjson = require 'cjson'
    --
    --   local function getdatafilepath()
    --     return vim.fn.stdpath 'data' .. '/data.json'
    --   end
    --
    --   vim.api.nvim_create_user_command('CopilotToggle', function()
    --     local data = {}
    --     local datafilepath = getdatafilepath()
    --     local f = io.open(datafilepath, 'r')
    --     if f then
    --       data = cjson.decode(f:read '*a')
    --       f:close()
    --     else -- if file does not exist initialize it
    --       data = { COPILOT_ON = true }
    --     end
    --
    --     if data.COPILOT_ON then
    --       vim.cmd 'Copilot disable'
    --       print 'Copilot OFF'
    --     else
    --       vim.cmd 'Copilot enable'
    --       print 'Copilot ON'
    --     end
    --
    --     data.COPILOT_ON = not data.COPILOT_ON
    --
    --     f = io.open(datafilepath, 'w')
    --     if not f then
    --       print('Could not open file: ' .. datafilepath)
    --       return
    --     end
    --
    --     f:write(cjson.encode(data))
    --     f:close()
    --   end, { nargs = 0 })
    --
    --   local data = {}
    --   local datafilepath = getdatafilepath()
    --   local f = io.open(datafilepath, 'r')
    --   if f then
    --     data = cjson.decode(f:read '*a')
    --     f:close()
    --   else -- if file does not exist initialize it
    --     data = { COPILOT_ON = true }
    --   end
    --
    --   if data.COPILOT_ON then
    --     vim.cmd 'Copilot enable'
    --     print 'Copilot ON'
    --   else
    --     vim.cmd 'Copilot disable'
    --     print 'Copilot OFF'
    --   end
    --
    --   require('copilot').setup {
    --     suggestion = {
    --       enabled = true,
    --       auto_trigger = true,
    --       hide_during_completion = true,
    --       debounce = 75,
    --       keymap = {
    --         accept = '<C-Space>',
    --         accept_word = '<S-Tab>',
    --         accept_line = false,
    --         next = false,
    --         prev = false,
    --         dismiss = false,
    --       },
    --     },
    --     filetypes = {
    --       yaml = true,
    --       markdown = true,
    --       help = true,
    --       gitcommit = true,
    --       gitrebase = true,
    --       hgcommit = true,
    --       svn = true,
    --       cvs = true,
    --       ['.'] = true,
    --     },
    --   }
    -- end,
  },
}
