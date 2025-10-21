# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license

# This is an empty nixCats config.
# you may import this template directly into your nvim folder
# and then add plugins to categories here,
# and call the plugins with their default functions
# within your lua, rather than through the nvim package manager's method.
# Use the help, and the example config github:BirdeeHub/nixCats-nvim?dir=templates/example

# It allows for easy adoption of nix,
# while still providing all the extra nix features immediately.
# Configure in lua, check for a few categories, set a few settings,
# output packages with combinations of those categories and settings.

# All the same options you make here will be automatically exported in a form available
# in home manager and in nixosModules, as well as from other flakes.
# each section is tagged with its relevant help section.

{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    lualine-lsp-progress.url = "github:bercly0b/lualine-lsp-progress";
    lualine-lsp-progress.flake = false;

    # texpresso-vim.url = "github:ErikFrankling/texpresso.vim";
    # texpresso-vim.url = "/home/erikf/projects/personal/texpresso.vim";
    # texpresso-vim.inputs.nixpkgs.follows = "nixpkgs";

    # plugin-texpresso-vim = {
    #   url = "/home/erikf/projects/personal/texpresso.vim";
    #   flake = false;
    # };

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples

  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, nixCats, ... }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      # the following extra_pkg_config contains any values
      # which you want to pass to the config set of nixpkgs
      # import nixpkgs { config = extra_pkg_config; inherit system; }
      # will not apply to module imports
      # as that will have your system values
      extra_pkg_config = {
        # allowUnfree = true;
      };
      # management of the system variable is one of the harder parts of using flakes.

      # so I have done it here in an interesting way to keep it out of the way.
      # It gets resolved within the builder itself, and then passed to your
      # categoryDefinitions and packageDefinitions.

      # this allows you to use ${pkgs.system} whenever you want in those sections
      # without fear.

      # sometimes our overlays require a ${system} to access the overlay.
      # Your dependencyOverlays can either be lists
      # in a set of ${system}, or simply a list.
      # the nixCats builder function will accept either.
      # see :help nixCats.flake.outputs.overlays
      dependencyOverlays = /* (import ./overlays inputs) ++ */ [
        # This overlay grabs all the inputs named in the format
        # `plugins-<pluginName>`
        # Once we add this overlay to our nixpkgs, we are able to
        # use `pkgs.neovimPlugins`, which is a set of our plugins.
        (utils.standardPluginOverlay inputs)
        # add any other flake overlays here.
        # inputs.texpresso-vim.overlays.default

        # overlay for nvim-lint made here because it has no flake.nix 
        # (final: prev: {
        #   vimPlugins = prev.vimPlugins //
        #   {
        #     nvim-lint = prev.vimPlugins.nvim-lint.overrideAttrs (old: {
        #       version = "1.0.0";
        #       src = inputs.nvim-lint;
        #     });
        #   };
        # })

        (final: prev: {
          vimPlugins = prev.vimPlugins //
          {
            lualine-lsp-progress = prev.vimPlugins.lualine-lsp-progress.overrideAttrs (old: {
              version = "1.0.0";
              src = inputs.lualine-lsp-progress;
            });
          };
        })

        # when other people mess up their overlays by wrapping them with system,
        # you may instead call this function on their overlay.
        # it will check if it has the system in the set, and if so return the desired overlay
        # (utils.fixSystemizedOverlay inputs.codeium.overlays
        #   (system: inputs.codeium.overlays.${system}.default)
        # )
      ];

      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions = { pkgs, settings, categories, extra, name, mkNvimPlugin, ... }@packageDef: {
        # to define and use a new category, simply add a new list to a set here, 
        # and later, you will include categoryname = true; in the set you
        # provide when you build the package using this builder function.
        # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

        # lspsAndRuntimeDeps:
        # this section is for dependencies that should be available
        # at RUN TIME for plugins. Will be available to PATH within neovim terminal
        # this includes LSPs
        lspsAndRuntimeDeps = with pkgs; let 

          yuckls = buildDotnetModule {
            pname = "yuckls";
            version = "";
         
            src = fetchFromGitHub {
              owner = "Eugenenoble2005";
              repo = "YuckLS";
              rev = "ab4c0315cd6c77ef0ed3c620bde0ece48e4a5949";
              hash = "sha256-HhxFVX9BHNydguGFZMd5FNZB06KxF34A9CqTzwJijes=";
            };
         
            projectFile = "YuckLS/YuckLS.csproj";
         
            dotnet-sdk = dotnetCorePackages.dotnet_8.sdk;
            nugetDeps = ./deps.nix;
          };
        in {
          general = [
            nodejs
            universal-ctags
            ripgrep
            fd
            stdenv.cc.cc
            nix-doc
            parinfer-rust
          ];
          kickstart-debug = [
            delve
          ];
          kickstart-lint = [
            markdownlint-cli
            nodePackages.jsonlint
          ];
          kickstart-lsp = [
            lua-language-server
            nixd
            gopls
            go
            rust-analyzer
            pyright
            texlab
            typescript-language-server
            haskell-language-server
            clojure-lsp
            # should be handled by the project's devShell so that it is on the same commit as the compiler
            # zls
            phpactor
            vscode-langservers-extracted
          ];
          kickstart-autoformat = [
            stylua
            cljfmt
            pretty-php
            prettierd
          ];
          custom-latex = [
            texlive.combined.scheme-full
            texpresso
            zathura
          ];
          custom-yuckls = [
            yuckls
          ];
        };

        # This is for plugins that will load at startup without using packadd:
        startupPlugins = with pkgs.vimPlugins; {
          general = [
            vim-sleuth
            lazy-nvim
            comment-nvim
            gitsigns-nvim
            which-key-nvim
            telescope-nvim
            telescope-fzf-native-nvim
            telescope-ui-select-nvim
            nvim-web-devicons
            plenary-nvim
            nvim-lspconfig
            lazydev-nvim
            fidget-nvim
            todo-comments-nvim
            mini-nvim
            nvim-surround
            rainbow-delimiters-nvim
            parinfer-rust
            nvim-treesitter.withAllGrammars
            # This is for if you only want some of the grammars
            # (nvim-treesitter.withPlugins (
            #   plugins: with plugins; [
            #     nix
            #     lua
            #   ]
            # ))
          ];
          kickstart-debug = [
            nvim-dap
            nvim-dap-ui
            nvim-dap-go
            nvim-nio
          ];
          kickstart-indent_line = [
            indent-blankline-nvim
          ];
          kickstart-lint = [
            nvim-lint
          ];
          kickstart-autoformat = [
            conform-nvim
          ];
          kickstart-autopairs = [
            nvim-autopairs
          ];
          kickstart-neo-tree = [
            neo-tree-nvim
            nui-nvim
            # nixCats will filter out duplicate packages
            # so you can put dependencies with stuff even if they're
            # also somewhere else
            nvim-web-devicons
            plenary-nvim
          ];
          kickstart-autocompletion = [
            nvim-cmp
            luasnip
            cmp_luasnip
            cmp-nvim-lsp
            cmp-path
            cmp-buffer
            cmp-latex-symbols
          ];

          custom-copilot = [
            copilot-lua
          ];
          custom-lualine = [
            lualine-nvim
            nvim-web-devicons
            copilot-lualine
            lualine-lsp-progress
          ];
          custom-snacks = [
            snacks-nvim
          ];
          custom-markdown = [
            markdown-preview-nvim
          ];
          custom-theme = [
            # onedark-nvim
            tokyonight-nvim
          ];
          custom-latex = [
            vimtex
            texpresso-vim
          ];
        };

        # not loaded automatically at startup.
        # use with packadd and an autocommand in config to achieve lazy loading
        # NOTE: this template is using lazy.nvim so, which list you put them in is irrelevant.
        # startupPlugins or optionalPlugins, it doesnt matter, lazy.nvim does the loading.
        # I just put them all in startupPlugins. I could have put them all in here instead.
        optionalPlugins = { };

        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = {
          general = with pkgs; [
            # libgit2
          ];
        };

        # environmentVariables:
        # this section is for environmentVariables that should be available
        # at RUN TIME for plugins. Will be available to path within neovim terminal
        environmentVariables = {
          test = {
            CATTESTVAR = "It worked!";
          };
        };

        # If you know what these are, you can provide custom ones by category here.
        # If you dont, check this link out:
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
        extraWrapperArgs = {
          test = [
            '' --set CATTESTVAR2 "It worked again!"''
          ];
        };

        # lists of the functions you would have passed to
        # python.withPackages or lua.withPackages

        # populates $LUA_PATH and $LUA_CPATH
        extraLuaPackages = {
          test = [ (ps: with ps; [ cjson ]) ];
        };
      };



      # And then build a package with specific categories from above here:
      # All categories you wish to include must be marked true,
      # but false may be omitted.
      # This entire set is also passed to nixCats for querying within the lua.

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = let
        # These are the names of your packages
        # you can include as many as you wish.
        basePackage = { pkgs, ... }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            # wrapRc = builtins.getEnv "NIXCATS_UNWRAP_RC" != "true";
            # aliases = [ ( if wrapRc then "nvim" else "nvim-debug" ) ];
            # unwrappedCfgPath = "/home/erikf/projects/personal/nvim";
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          };

          # and a set of categories that you want
          # (and other information to pass to lua)
          categories = {
            general = true;
            gitPlugins = true;
            customPlugins = true;
            test = true;

            kickstart-autopairs = true;
            kickstart-neo-tree = true;
            kickstart-debug = true;
            kickstart-lint = true;
            kickstart-indent_line = true;
            kickstart-lsp = true;
            kickstart-autoformat = true;

            # this kickstart extra didnt require any extra plugins
            # so it doesnt have a category above.
            # but we can still send the info from nix to lua that we want it!
            kickstart-gitsigns = true;

            custom-copilot = true;
            custom-lualine = true;
            custom-markdown = true;
            custom-theme = true;
            custom-snacks = false;
            custom-latex = true;
            custom-yuckls = true;

            # we can pass whatever we want actually.
            have_nerd_font = true;

            example = {
              youCan = "add more than just booleans";
              toThisSet = [
                "and the contents of this categories set"
                "will be accessible to your lua with"
                "nixCats('path.to.value')"
                "see :help nixCats"
                "and type :NixCats to see the categories set in nvim"
              ];
            };
          };
        };
      in {
        nvim = { pkgs, ... }@inputs: basePackage {
          inherit pkgs;
          inherit inputs;
        } // {
          settings.wrapRc = true;
            hosts.python3.enable = true;
            hosts.node.enable = true;
        };
        nvim-debug = { pkgs, ... }@inputs: basePackage {
          inherit pkgs;
          inherit inputs;
        } // {
          # IMPORTANT:
          # your alias may not conflict with your other packages.
          settings.aliases = [ "nvim-debug" ];
          settings.wrapRc = false;
          settings.unwrappedCfgPath = "/home/erikf/projects/personal/nvim";
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
      };

      # In this section, the main thing you will need to do is change the default package name
      # to the name of the packageDefinitions entry you wish to use as the default.
      defaultPackageName = "nvim";
    in


    # see :help nixCats.flake.outputs.exports
    forEachSystem
      (system:
        let
          nixCatsBuilder = utils.baseBuilder luaPath
            {
              inherit nixpkgs system dependencyOverlays extra_pkg_config;
            }
            categoryDefinitions
            packageDefinitions;
          defaultPackage = nixCatsBuilder defaultPackageName;
          # this is just for using utils such as pkgs.mkShell
          # The one used to build neovim is resolved inside the builder
          # and is passed to our categoryDefinitions and packageDefinitions
          pkgs = import nixpkgs { inherit system; };
        in
        rec{
          # these outputs will be wrapped with ${system} by utils.eachSystem

          # this will make a package out of each of the packageDefinitions defined above
          # and set the default package to the one passed in here.
          packages = utils.mkAllWithDefault defaultPackage;

          # choose your package for devShell
          # and add whatever else you want in it.
          devShells = {
            default = pkgs.mkShell {
              name = defaultPackageName;
              # packages = [ defaultPackage packages.nvim-debug ];
              packages = [ packages.nvim-debug ];
              inputsFrom = [ ];
              shellHook = ''
              '';
            };
          };

        }) // (
      let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
      in
      {

        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath
          {
            inherit nixpkgs dependencyOverlays extra_pkg_config;
          }
          categoryDefinitions
          packageDefinitions
          defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
