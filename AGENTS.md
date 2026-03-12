# Agent Guidelines for nixCats Neovim Config

## Overview

This is a nixCats-based Neovim configuration. It uses Nix to manage dependencies and lazy.nvim for plugin loading. The configuration is based on kickstart.nvim but adapted for nixCats.

**IMPORTANT**: This is a flake added to the user's system config, not built directly. Do NOT suggest building the package with `nix build .`

Neovim is a tui so errors are not just printed to the terminal you might have to look at the healthcheck or messages buffers in neovim to understand issues and verfiy things work so not just running a new config is enough to understand if everything wroked or to find out why its not working.

use the internet or rethink your aproach you should never need to access nix sotre files that is off limits use the internet when you need a new aprouch dont hallucinate new shit you are very bad at neovim and nix so use hte internet

you are not alloowed to realy on system config this flake has to be slef contained

you always have to check :messages and the healthcheck before you know what issue you are dealing with and also to verify your solution

## Development Workflow

### Commands

```bash
# Enter the nix development shell (REQUIRED before testing)
nix develop

# Run Neovim with current Lua config for testing
nvim-debug

# Alternative: Run directly with nix (downloads deps via eval, slower)
# Useful when testing downloading new dependencies
nix run .
```

### Temp stuff

You might need to make temporary test files to see how neovim reacts when editing diffrent file types or maybe you need scripts or temporary extra lua config for testing then you do.

```shell
mkdir -p tmp
```

and put everything in `./tmp` dir that you then delete at end of seeesion so no extra shit is left before i make a commit.

also i general make sure to make everything you have worked on clean and neet when you are done.

DONT USE `/tmp/` use instead a local `./tmp/`

### Key Points

- Use `nvim-debug` (not `nvim`) to test the local Lua config
- `nvim-debug` is defined in `flake.nix` with `wrapRc = false` and points to this directory
- The purpose of `nvim-debug` is hot-reloading Lua code without waiting for slower Nix evaluation

### Nixpkgs Reference

- Look up packages at https://search.nixos.org/packages
- In nixpkgs, vim plugins are named `vimPlugins.<name>` (e.g., `vimPlugins.nvim-treesitter`)
- LSPs and runtime tools are regular nixpkgs packages (e.g., `lua-language-server`, `nixd`)

### Flake.nix Structure

The flake has two main dependency sections:

1. **`lspsAndRuntimeDeps`** - Runtime dependencies available in PATH
   - LSP servers (e.g., `lua-language-server`, `nixd`, `rust-analyzer`)
   - Formatters (e.g., `stylua`, `black`, `rustfmt`)
   - Other tools (e.g., `ripgrep`, `fd`, `nodePackages.cspell`)
   - Accessed as regular nixpkgs packages: `with pkgs; [ package1 package2 ]`

2. **`startupPlugins`** - Vim plugins loaded by lazy.nvim
   - Accessed as `with pkgs.vimPlugins; [ plugin1 plugin2 ]`
   - All plugins must be from `pkgs.vimPlugins` set
   - Custom plugins from inputs use overlay `utils.standardPluginOverlay`

### Dependency Management

- All dependencies specified in `flake.nix` are downloaded when entering the devshell
- **If new dependencies are added to `flake.nix`, you MUST exit the devshell and re-enter it** to download them

## Capturing Neovim Messages (for debugging)

To verify errors or issues, capture `:messages` output using this method:

```bash
# Capture all messages after startup
nix develop -c bash -c '
  nvim-debug --headless \\
    -c "lua vim.defer_fn(function() local m = vim.fn.execute(\"messages\"); vim.fn.writefile(vim.split(m, \"\\n\"), \"/tmp/nvim_msgs.txt\"); vim.cmd(\"qa!\") end, 2000)" \\
    2>&1
  sleep 3
  cat /tmp/nvim_msgs.txt
'
```

This works because:

1. `vim.fn.execute("messages")` captures the message history
2. `defer_fn` with delay ensures all startup messages are collected
3. Messages are written to a file before quitting
4. Both stderr and the message file can be checked for errors

### Validation Required

**NEVER stop attemting solutions until consider changes until you have validated they work:**

- Test all changes by running `nvim-debug` inside the devshell
- Verify plugins load correctly without errors
- Check that configurations apply as expected
- If fixing an issue, confirm the issue is resolved
- If adding functionality, verify it works as described
- **IMPORTANT** always confirm with some output from neovim that th eissue is resolved even if you hav eot add debugging code that is fine as long as you are copletely dure the problem is resolved
- **IMPORTANT** never assume what is wrong reproduce the exact error logs so you know for sure what the problem is before stating solutions

## Code Style

### Formatting (StyLua)

- Column width: 160
- Indent: 2 spaces
- Quote style: AutoPreferSingle
- Call parentheses: None (omit when possible)
- Unix line endings

### Lua Conventions

- Use single quotes for strings: `'string'`
- Omit parentheses for simple calls: `require 'module'`
- 2 space indentation
- No trailing whitespace

### Project Structure

```
init.lua              # Entry point
flake.nix             # Nix package definition
custom/               # User customizations
  options.lua         # Vim options
  keymaps.lua         # Key mappings
  autocomd.lua        # Autocommands
  plugins/            # Custom plugin configs
kickstart/            # Base kickstart plugins
nixCatsUtils/         # nixCats integration utilities
after/ftplugin/       # Filetype-specific settings
```

## Important Guidelines

### Minimal Changes

- This project is maintained in free time - keep changes minimal and focused
- Avoid unnecessary complexity
- Prefer simple, maintainable solutions

### Debug Code Policy

**REMOVE all temporary debug code before committing:**

- No `print()` statements for debugging
- No temporary logging
- No commented-out debug code
- No debug configuration files

Only keep debugging/logging code if it provides **genuine long-term value** (e.g., error reporting that users will actually see and need).

### Nix Integration

- Plugin availability is controlled via categories in `flake.nix`
- Check categories in Lua with: `nixCats 'category.name'`
- Use `require('nixCatsUtils').enableForCategory()` for conditional loading
- Keep the lazy-lock.json path logic in `init.lua`

## Documentation References

**ALWAYS read relevant documentation when working on this project:**

- **NEOVIM**: `:h` in Neovim orneovim.io/doc/user/
  - Understanding neovim is required.
- **nixCats**: `:h nixCats` in Neovim or https://github.com/BirdeeHub/nixCats-nvim
  - Understanding nixCats is essential for working with categories, plugin loading, and Nix integration
- **lazy.nvim**: https://github.com/folke/lazy.nvim
  - Plugin loading mechanism used by this config
  - Understanding lazy.nvim helps with plugin configuration and troubleshooting

- **kickstart.nvim**: https://github.com/nvim-lua/kickstart.nvim
  - Base configuration this project is adapted from
