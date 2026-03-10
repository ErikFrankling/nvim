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

  -- print('geting data ', vim.inspect(data))

  return data
end

vim.api.nvim_create_user_command('CopilotToggle', function()
  local datafilepath = getdatafilepath()
  local data = getdata()

  if data.COPILOT_ON then
    vim.cmd 'Copilot disable'
    -- print 'Toggle: Copilot OFF'
  else
    vim.cmd 'Copilot enable'
    -- print 'Toggle: Copilot ON'
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

local applied = false

vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  once = true,
  callback = function()
    vim.defer_fn(function()
      if applied then
        return
      end
      applied = true

      local copilot_exists = pcall(require, 'copilot')
      if not copilot_exists then
        return
      end

      local copilot = require 'copilot.client'
      copilot.use_client(function(client)
        local data = getdata()
        if data.COPILOT_ON then
          vim.cmd 'Copilot enable'
        else
          vim.cmd 'Copilot disable'
        end
      end)
    end, 500)
  end,
})
