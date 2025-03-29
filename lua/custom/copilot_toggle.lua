local cjson = require 'cjson'

local function getdatafilepath()
  return vim.fn.stdpath 'data' .. '/data.json'
end

-- @return table
local function getdata()
  local data = {}
  local datafilepath = getdatafilepath()

  local f = io.open(datafilepath, 'r')
  if f then
    data = cjson.decode(f:read '*a')
    f:close()
  else -- if file does not exist initialize it
    data = { COPILOT_ON = true }

    f = io.open(datafilepath, 'w')
    if not f then
      print('Could not open file: ' .. datafilepath)
      return
    end

    f:write(cjson.encode(data))
    f:close()
  end

  print('geting data ', vim.inspect(data))

  return data
end

vim.api.nvim_create_user_command('CopilotToggle', function()
  local datafilepath = getdatafilepath()
  local data = getdata()

  if data.COPILOT_ON then
    vim.cmd 'Copilot disable'
    print 'Copilot OFF'
  else
    vim.cmd 'Copilot enable'
    print 'Copilot ON'
  end

  data.COPILOT_ON = not data.COPILOT_ON

  local f = io.open(datafilepath, 'w')
  if not f then
    print('Could not open file: ' .. datafilepath)
    return
  end

  f:write(cjson.encode(data))
  f:close()
end, { nargs = 0 })

-- local cjson = require 'cjson'
--
-- local function getdatafilepath()
--   return vim.fn.stdpath 'data' .. '/data.json'
-- end
--
-- vim.api.nvim_create_user_command('CopilotToggle', function()
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
--     vim.cmd 'Copilot disable'
--     print 'Copilot OFF'
--   else
--     vim.cmd 'Copilot enable'
--     print 'Copilot ON'
--   end
--
--   data.COPILOT_ON = not data.COPILOT_ON
--
--   f = io.open(datafilepath, 'w')
--   if not f then
--     print('Could not open file: ' .. datafilepath)
--     return
--   end
--
--   f:write(cjson.encode(data))
--   f:close()
-- end, { nargs = 0 })
--
-- -- actually turn copilot on or off by reading the data file with an autocomand
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'VimEnter' }, {
--   desc = 'CopilotToggle',
--   -- group = 'CopilotToggle',
--   pattern = '*',
--   callback = function()
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
--       vim.cmd 'Copilot enable'
--       print 'Copilot ON'
--     else
--       vim.cmd 'Copilot disable'
--       print 'Copilot OFF'
--     end
--   end,
-- })

-- Old: cant get shada to work
--
-- -- enable shada for persistent setting between sessions
-- vim.o.shada = "!,'300,<50,s10,h"
-- vim.cmd 'rsh! ~/.local/share/nvim/main.shada'
--
-- vim.api.nvim_create_user_command('CopilotToggle', function()
--   vim.cmd 'rsh! ~/.local/share/nvim/main.shada'
--
--   if vim.g.COPILOT_ON then
--     vim.cmd 'Copilot disable'
--     print 'Copilot OFF'
--   else
--     vim.cmd 'Copilot enable'
--     print 'Copilot ON'
--   end
--
--   vim.g.COPILOT_ON = not vim.g.COPILOT_ON
--   vim.cmd 'wsh! ~/.local/share/nvim/main.shada'
-- end, { nargs = 0 })
