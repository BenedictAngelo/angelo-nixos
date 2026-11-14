{
  pkgs,
  lazyvim,
  ...
}: {
  #home.file.".config/nvim".source = self + /dotfiles/nvim;
  imports = [lazyvim.homeManagerModules.default];

  programs.vim = {
    enable = true;
    extraConfig = ''
      set number
      set norelativenumber

      set cursorline
      set signcolumn=yes
      set scrolloff=8
      set sidescrolloff=8

      set expandtab
      set shiftwidth=4
      set tabstop=4
      set softtabstop=4

      set ignorecase
      set smartcase
      set hlsearch
      set incsearch

      set splitbelow
      set splitright

      set mouse=a
      set clipboard+=unnamedplus

      set wrap
      set linebreak
    '';
  };
  programs.lazyvim = {
    enable = true;

    # Custom config directory (optional, defaults to "nvim")
    # appName = "lazyvim";  # Creates config in ~/.config/lazyvim/

    # Plugin source strategy
    pluginSource = "latest";

    # Option 1: Use a configuration directory (choose either this OR inline config below)
    # configFiles = ./lazyvim-config;

    # LazyVim extras
    extras = {
      lang = {
        nix.enable = true;
        python = {
          enable = true;
          installDependencies = true; # Install ruff (formatter/linter)
          installRuntimeDependencies = true; # Install python3, pip
          config = ''
            return {
              "neovim/nvim-lspconfig",
              opts = {
                servers = {
                  pyright = {
                    settings = {
                      python = {
                        analysis = {
                          typeCheckingMode = "basic",
                        },
                      },
                    },
                  },
                },
              },
            }
          '';
        };
        rust = {
          enable = true;
          installDependencies = true; # Install rust-analyzer, rustfmt
          installRuntimeDependencies = false; # Don't install rustc/cargo (assume already present)
          config = ''
            return {
              "neovim/nvim-lspconfig",
              opts = {
                servers = {
                  rust_analyzer = {
                    settings = {
                      ["rust-analyzer"] = {
                        cargo = { features = "all" },
                      },
                      procMacro = {
                        ignored = {
                          leptos_macro = {
                            -- optional: --
                            -- "component",
                            "server",
                          },
                        },
                      },
                    },
                  },
                },
              },
            }
          '';
        };
        clangd = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        go = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        typescript = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        json = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        tailwind = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        toml = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        markdown = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        yaml = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        sql = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        git = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        docker = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
      };

      ai = {
        claudecode.enable = true;
      };
      coding = {
        yanky.enable = true;
      };
      dap = {
        core.enable = true;
      };
      editor = {
        dial.enable = true;
        snacks-picker.enable = true;
        snacks-explorer.enable = true;
        inc-rename.enable = true;
      };
      formatting = {
        prettier.enable = true;
        black.enable = true;
      };
      test = {
        core.enable = true;
      };
      ui = {
        dashboard-nvim.enable = true;
        edgy.enable = true;
        smear-cursor.enable = true;
      };
      util = {
        dot.enable = true;
        gh.enable = true;
        gitui.enable = true;
        mini-hipatterns.enable = true;
        project.enable = true;
      };
    };

    # Tools and LSP servers
    extraPackages = with pkgs; [
      # Existing tools
      nixd
      pyright
      tree-sitter
      statix
      lazygit
      nodejs

      # HTML and CSS
      vscode-langservers-extracted

      # Tailwind CSS
      tailwindcss-language-server

      # Docker / Docker Compose
      dockerfile-language-server
      docker-compose-language-service
      hadolint

      # SQL / PostgreSQL
      sqls
      sqlfluff
      postgresql
    ];

    # Optional: Only needed for non-LazyVim languages
    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
      wgsl # WebGPU Shading Language
      templ # Go templ files
      fish
      bash
      cmake
      rust
      html
      css
      javascript
      typescript
      tsx
      sql
      yaml
      json
      toml
      dockerfile
    ];

    # Option 2: Inline LazyVim configuration (choose either this OR configFiles above)
    config = {
      options = ''
        vim.g.trouble_lualine = false
        vim.opt.relativenumber = false
        vim.opt.wrap = true
        vim.opt.conceallevel = 0
      '';

      keymaps = ''
        vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
        vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
      '';

      autocmds = ''
        vim.api.nvim_create_autocmd("FocusLost", {
          command = "silent! wa",
          desc = "Auto-save on focus loss",
        })
      '';
    };

    # Plugin configurations
    plugins = {
      snacks-explorer-hidden-files = ''
        return {
          {
            "folke/snacks.nvim",
            opts = {
              explorer = {
                hidden = true,
              },
            },
          },
        }
      '';
      snacks-hidden-files = ''
        return {
          {
            "folke/snacks.nvim",
            opts = {
              picker = {
                hidden = true,
                ignored = false,
              },
            },
          },
        }
      '';
      noice-pyright = ''
        return {
          {
            "folke/noice.nvim",
            opts_extend = { "routes" },
            opts = {
              routes = {
                {
                  filter = {
                    event = "lsp",
                    kind = "progress",
                    any = {
                      { find = "pyright" },
                      { find = "basedpyright" },
                    },
                  },
                  opts = {
                    skip = true,
                  },
                },
              },
            },
          },
        }
      '';
      smear-cursor = ''
        return {
          {
            "sphamba/smear-cursor.nvim",
            opts = {
              -- Follow the cursor across lines.
              smear_between_neighbor_lines = true,

              -- Make the head snap quickly while leaving a short tail.
              stiffness = 0.9,
              trailing_stiffness = 0.65,
              damping = 0.9,

              -- Keep the smear short and responsive.
              distance_stop_animating = 0.5,
              max_length = 18,

              -- Better blending / less blocky rendering.
              legacy_computing_symbols_support = true,
              use_diagonal_blocks = true,

              -- Particle / paintbrush effect.
              particles_enabled = true,
              particles_per_second = 70,
              particles_per_length = 1.5,
              particle_max_lifetime = 180,

              -- Keep particles concentrated around the cursor path.
              particle_spread = 0.25,
              particle_max_initial_velocity = 5,
              particle_velocity_from_cursor = 0.2,
              particle_random_velocity = 25,
              particle_damping = 0.35,
              particle_gravity = 0,

              -- Don't generate particles for tiny movements.
              min_distance_emit_particles = 1.5,

              -- Keep particles behind the actual cursor.
              particles_over_text = false,
              never_draw_over_target = true,
            },
          },
        }
      '';
      codecompanion = ''
        return {
          {
            "olimorris/codecompanion.nvim",
            dependencies = {
              "nvim-lua/plenary.nvim",
            },
            opts = {
              interactions = {
                chat = {
                  adapter = {
                    name = "ollama",
                    model = "qwen3:8b",
                  },
                },
                inline = {
                  adapter = {
                    name = "ollama",
                    model = "qwen3:8b",
                  },
                },
              },
            },
            keys = {
              {
                "<leader>ao",
                "<cmd>CodeCompanionChat<cr>",
                desc = "Ollama Chat",
              },
              {
                "<leader>aI",
                "<cmd>CodeCompanion<cr>",
                mode = { "n", "v" },
                desc = "Ollama Inline",
              },
            },
          },
        }
      '';
      copilot = ''
        return {
          {
            "github/copilot.vim",
            event = "InsertEnter",

            config = function()
              vim.g.copilot_no_tab_map = true

              -- Toggle Copilot inline suggestions for the current buffer.
              vim.keymap.set("n", "<leader>uc", function()
                local enabled = vim.b.copilot_enabled ~= false

                vim.b.copilot_enabled = not enabled

                if vim.b.copilot_enabled then
                  vim.notify("Copilot enabled", vim.log.levels.INFO)
                else
                  vim.notify("Copilot disabled", vim.log.levels.INFO)
                end
              end, {
                desc = "Toggle Copilot inline suggestions",
              })

              vim.keymap.set("i", "<M-l>", 'copilot#Accept("<CR>")', {
                expr = true,
                replace_keycodes = false,
                silent = true,
              })

              vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", {
                silent = true,
              })

              vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", {
                silent = true,
              })

              vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", {
                silent = true,
              })

              vim.keymap.set("i", "<M-\\>", "<Plug>(copilot-suggest)", {
                silent = true,
              })

              vim.keymap.set("i", "<M-'>", "<Plug>(copilot-accept-word)", {
                silent = true,
              })

              vim.keymap.set("i", "<M-\">", "<Plug>(copilot-accept-line)", {
                silent = true,
              })

              vim.keymap.set("i", "<M-/>", "<Plug>(copilot-dismiss)", {
                silent = true,
              })
            end,
          },
        }
      '';
      colorscheme = ''
        local function get_noctalia_theme()
          local handle = io.popen("noctalia msg theme-mode-get")
          if not handle then
            return "dark"
          end

          local result = handle:read("*a")
          handle:close()

          result = result:gsub("%s+", "")

          return result == "light" and "light" or "dark"
        end

        -- ============================================
        -- Change this whenever you want another theme
        -- ============================================
        local theme = "gruvbox"
        -- local theme = "tokyonight" or "gruvbox"

        local background = get_noctalia_theme()

        if theme == "gruvbox" then
          return {
            {
              "ellisonleao/gruvbox.nvim",
              lazy = false,
              priority = 1000,
              config = function()
                vim.o.background = background

                require("gruvbox").setup({})

                vim.cmd.colorscheme("gruvbox")
              end,
            },
          }
        end

        if theme == "tokyonight" then
          return {
            {
              "folke/tokyonight.nvim",
              lazy = false,
              priority = 1000,
              opts = {
                style = background == "light" and "day" or "moon",
              },
              config = function(_, opts)
                require("tokyonight").setup(opts)
                vim.cmd.colorscheme("tokyonight")
              end,
            },
          }
        end

        return {}
      '';
      lsp-config = ''
        return {
          {
            "neovim/nvim-lspconfig",
            opts = {
              servers = {
                html = {},
                cssls = {},
                sqls = {},

                tailwindcss = {
                  filetypes_include = { "rust" },

                  settings = {
                    tailwindCSS = {
                      experimental = {
                        classRegex = {
                          'class\\s*=\\s*"([^"]*)"',
                        },
                      },
                    },
                  },
                },
              },
            },
          },
        }
      '';
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
