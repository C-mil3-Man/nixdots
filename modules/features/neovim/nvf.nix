{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.nvf =
    { pkgs, config, ... }:
    {
      config.vim = {
        # parts of this taken from https://github.com/iynaix/dotfiles/blob/main/modules/shell/neovim/_settings.nix
        # large parts taken frm https://github.com/NotAShelf/nvf/blob/13c4ad4b4bb926c22945e2fb8862769fe51f27f1/configuration.nix

        # keybinds
        keymaps =
          let
            mkKeymap = mode: key: action: desc: {
              inherit
                mode
                key
                action
                desc
                ;
            };
            mkKeymapWithOpts =
              mode: key: action: desc: opts:
              (mkKeymap mode key action) // opts;
          in
          [
            (mkKeymap "n" "<leader>e" "<cmd>Neotree toggle<CR>" "Open Neo-tree")
            (mkKeymap "n" "<PageUp>" "<C-U>" "")
            (mkKeymap "n" "<PageDown>" "<C-D>" "")
            (mkKeymap "i" "<PageUp>" "<C-O><C-U>" "")
            (mkKeymap "i" "<PageDown>" "<C-O><C-D>" "")
          ];

        terminal = {
          toggleterm = {
            enable = true;
          };
        };

        viAlias = true;
        vimAlias = true;
        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
          transparent = true;
        };
        options = {
          tabstop = 2; # Number of spaces a <Tab> counts for
          shiftwidth = 2; # Number of spaces for auto-indent
          expandtab = true; # Convert tabs to spaces (highly recommended for Nix)
          smartindent = true;
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;
        autocomplete = {
          # nvim-cmp.enable = true;
          blink-cmp = {
            enable = true;
            # friendly-snippets.enable = true;
          };
        };

        snippets = {
          luasnip = {
            enable = true;
            providers = [ "friendly-snippets" ];
          };
        };

        # git
        git = {
          enable = true;
          neogit.enable = true;
        };
        # enable dashboard?
        # lazy.enable = false;
        dashboard = {
          # startify = {
          #   enable = true;
          #   changeToVCRoot = true;
          # };
          # dashboard-nvim.enable = true;
          alpha = {
            enable = true;
            theme = "theta";
          };
        };

        statusline.lualine.integrations = {
          breadcrumbs.nvim-navic.enable = true;
          breadcrumbs.navbuddy.enable = true;
        };

        ui = {
          colorizer.enable = true;
          borders.enable = true;
          # this adds the little vertical highlight column that shows you not to go too far ig
          smartcolumn = {
            enable = false;
            setupOpts.custom_colorcolumn = {
              # this is a freeform module, it's `buftype = int;` for configuring column position
              nix = "110";
              ruby = "120";
              java = "130";
              go = [
                "90"
                "130"
              ];
            };
          };
        };

        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;

          highlight-undo.enable = true;
          blink-indent.enable = true;
          indent-blankline.enable = false;

          # Fun
          # cellular-automaton.enable = false;
        };

        filetree = {
          neo-tree = {
            enable = true;
          };
        };

        tabline = {
          nvimBufferline = {
            enable = true;
            # default declaration can be found in https://github.com/NotAShelf/nvf/blob/main/modules/plugins/tabline/nvim-bufferline/nvim-bufferline.nix
            mappings = {
              cycleNext = "<S-l>";
              cyclePrevious = "<S-h>";
            };
            setupOpts.options.diagnostics = "nvim_lsp";
          };
        };

        treesitter = {
          enable = true;
          addDefaultGrammars = true;
          context.enable = true;
        };

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        minimap = {
          minimap-vim.enable = false;
          # codewindow.enable = true; # lighter, faster, and uses lua for configuration
        };

        utility = {
          ccc.enable = false;
          vim-wakatime.enable = false;
          diffview-nvim.enable = true;
          yanky-nvim.enable = false;
          qmk-nvim.enable = false; # requires hardware specific options
          icon-picker.enable = true;
          surround.enable = true;
          leetcode-nvim.enable = true;
          multicursors.enable = true;
          smart-splits.enable = true;
          undotree.enable = true;
          nvim-biscuits.enable = true;
          grug-far-nvim.enable = true;

          motion = {
            hop.enable = false;
            leap.enable = false;
            precognition.enable = false;
          };
          images = {
            image-nvim.enable = false;
            img-clip.enable = true;
          };
        };

        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers = {
            wl-copy.enable = true;
          };
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;

          bash.enable = true;
          lua.enable = true;
          html.enable = true;
          # typescript.enable = true;
          python.enable = true;

          markdown = {
            enable = true;
            extensions.render-markdown-nvim.enable = true;
          };

          nix = {
            enable = true;
            format = {
              enable = true;
              type = [ "nixfmt" ];
            };
            lsp.servers = [
              # "nil"
              "nixd"
            ];
          };
        };
        lsp = {
          enable = true;
          formatOnSave = true;
          # lightbulb.enable = true;
          lspkind.enable = true;
          otter-nvim.enable = true; # provide lsp for embedded languages
          trouble.enable = true;
          lightbulb.enable = true;
          lspsaga.enable = false;
          # lspSignature.enable = !true; # conflicts with blink in maximal
          nvim-docs-view.enable = true;
          presets.harper.enable = true;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        lazy = {
          enable = true;
        };

      };
    };

  perSystem =
    {
      self',
      pkgs,
      ...
    }:
    {
      packages.neovim-nvf =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            self.nixosModules.nvf
          ];
        }).neovim;
    };
}
