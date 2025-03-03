vim.g.COPILOT_ON = true
vim.api.nvim_create_user_command('CopilotToggle', function()
  if vim.g.COPILOT_ON then
    vim.cmd 'Copilot disable'
    print 'Copilot OFF'
  else
    vim.cmd 'Copilot enable'
    print 'Copilot ON'
  end
  vim.g.COPILOT_ON = not vim.g.COPILOT_ON
end, { nargs = 0 })
