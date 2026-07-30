-- The desktop shell (quickshell) publishes the palette it is currently showing
-- to ~/.cache/wal/ in pywal's layout. `colors-base16.yaml` is the base16 form,
-- which carries the whole scheme rather than just the 16 ANSI slots. If that
-- file is there, tokyonight is rebuilt from it; if it is not, everything below
-- is a no-op and tokyonight looks exactly as it ships.
local uv = vim.uv or vim.loop
local base16_file = vim.fn.expand '~/.cache/wal/colors-base16.yaml'

local slots = {
  'base00',
  'base01',
  'base02',
  'base03',
  'base04',
  'base05',
  'base06',
  'base07',
  'base08',
  'base09',
  'base0A',
  'base0B',
  'base0C',
  'base0D',
  'base0E',
  'base0F',
}

--- base00..base0F from the shell's file, or nil if the shell never ran here.
--- The shell writes the file with `cat >`, so a read can land between the
--- truncate and the write; anything short of all sixteen slots is treated as
--- no palette at all rather than as a palette with holes in it.
local function system_palette()
  if vim.fn.filereadable(base16_file) ~= 1 then
    return nil
  end
  local ok, lines = pcall(vim.fn.readfile, base16_file)
  if not ok then
    return nil
  end
  local palette = {}
  for _, line in ipairs(lines) do
    local slot, hex = line:match '^%s*(base%x%x)%s*:%s*"(#%x%x%x%x%x%x)"'
    if slot then
      palette['base' .. slot:sub(5):upper()] = hex
    end
  end
  for _, slot in ipairs(slots) do
    if not palette[slot] then
      return nil
    end
  end
  return palette
end

--- base16 slot -> tokyonight palette entry. Only the raw palette is mapped;
--- tokyonight derives the statusline, floats, visual selection, diffs and
--- `:terminal` colours from these itself, so those follow along too.
local function as_tokyonight(p)
  local blend = require('tokyonight.util').blend
  return {
    bg = p.base00,
    bg_dark = p.base00,
    bg_dark1 = p.base00,
    bg_highlight = p.base02,
    fg = p.base05,
    fg_dark = p.base04,
    fg_gutter = p.base02,
    -- base03 is Comments and Invisibles: a foreground that has to stay readable
    -- against base00. base04 is the brighter dark foreground above it, which is
    -- what tokyonight calls dark5.
    comment = p.base03,
    dark3 = p.base03,
    dark5 = p.base04,
    -- ANSI bright black, which is base03 in the mapping the shell publishes.
    terminal_black = p.base03,
    red = p.base08,
    red1 = p.base08,
    orange = p.base09,
    yellow = p.base0A,
    green = p.base0B,
    green1 = p.base0C,
    green2 = p.base0B,
    cyan = p.base0C,
    teal = p.base0C,
    blue = p.base0D,
    blue0 = blend(p.base0D, 0.45, p.base00), -- search / visual background
    blue1 = p.base0C,
    blue2 = p.base0D,
    blue5 = p.base0C,
    blue6 = p.base06,
    blue7 = blend(p.base0D, 0.25, p.base00),
    magenta = p.base0E,
    magenta2 = p.base08,
    purple = p.base0E,
    git = { add = p.base0B, change = p.base0D, delete = p.base08 },
  }
end

return {
  {
    -- 'navarasu/onedark.nvim',
    -- opts = {
    --   style = 'warmer',
    -- },

    -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      -- tokyonight looks its style up in this table on every `:colorscheme` and
      -- calls it if it finds a function there, so the palette file is re-read on
      -- every reload. `colors.styles` is an extension point rather than a
      -- documented API, so nothing here assumes it is there: if a future
      -- tokyonight drops it the block is skipped and the shipped night palette
      -- loads untouched, and the same holds if the palette file is missing or
      -- half-written, or if the mapping trips over a palette that has moved on.
      local ok, colors = pcall(require, 'tokyonight.colors')
      local night = ok and type(colors) == 'table' and type(colors.styles) == 'table' and colors.styles.night or nil
      if night ~= nil then
        colors.styles.night = function(opts)
          local base = type(night) == 'function' and night(opts) or vim.deepcopy(night)
          local p = system_palette()
          if not p then
            return base
          end
          local mapped, overrides = pcall(as_tokyonight, p)
          if not mapped then
            return base
          end
          return vim.tbl_deep_extend('force', base, overrides)
        end
      end

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'onedark-warmer'
      vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'

      -- Follow the shell live. It rewrites the file in place, so the inode
      -- survives and a watch on the path itself keeps working. The timer is
      -- re-armed on every event, so the truncate and the write behind it
      -- coalesce into a single reload of the finished file.
      local watcher = uv.new_fs_event()
      local timer = uv.new_timer()
      if watcher and timer and vim.fn.filereadable(base16_file) == 1 then
        local reload = vim.schedule_wrap(function()
          if vim.g.colors_name then
            pcall(vim.cmd.colorscheme, vim.g.colors_name)
            pcall(vim.cmd.hi, 'Comment gui=none')
          end
        end)
        watcher:start(base16_file, {}, function()
          timer:start(120, 0, reload)
        end)
      end
    end,
  },
}
