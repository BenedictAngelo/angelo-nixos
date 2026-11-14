{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;

    # Use Zed as $EDITOR / $VISUAL.
    # Remove this if you want nvim to remain your default terminal editor.
    defaultEditor = false;

    # Keep Zed's settings editable from inside Zed.
    mutableUserSettings = true;
    mutableUserKeymaps = true;
    mutableUserTasks = true;
    mutableUserDebug = true;

    # Zed extensions.
    #
    # These are extension repository names from Zed's extension registry.
    extensions = [
      # Nix
      "nix"

      # Rust
      "rust"

      # Python
      "python"

      # C / C++
      "clangd"

      # Web
      "html"
      "css"
      "javascript"
      "typescript"

      # Data / config
      "sql"
      "toml"
      "yaml"
      "json"

      # Markdown
      "markdown"

      # Git
      "git-firefly"
    ];

    # Programs available to Zed through PATH.
    #
    # This is useful when Zed needs to spawn language servers,
    # formatters, linters, etc.
    extraPackages = with pkgs; [
      # Nix
      nixd
      nixfmt
      statix

      # C / C++
      clang
      clang-tools

      # Rust
      rust-analyzer
      rustfmt

      # Python
      pyright
      black

      # Web
      nodejs
      typescript
      prettier

      # SQL
      sqls

      # General
      git
      ripgrep
      fd
      jq
    ];

    userSettings = {
      ######################################################################
      # General
      ######################################################################

      # Use Vim-style editing.
      vim_mode = true;

      # Use system theme.
      /*
      theme = {
        mode = "system";
        dark = "One Dark";
        light = "One Light";
      };
      */

      # Font
      buffer_font_family = "JetBrainsMono Nerd Font Mono";
      buffer_font_size = 16;

      ui_font_family = "JetBrainsMono Nerd Font Mono";
      ui_font_size = 16;

      # Editor behavior
      relative_line_numbers = "disabled";

      cursor_blink = false;

      # Keep some context around the cursor.
      vertical_scroll_margin = 5;

      # Soft wrap
      soft_wrap = "editor_width";

      # Show whitespace when useful.
      show_whitespaces = "selection";

      # Bracket matching / highlighting.
      colorize_brackets = true;

      # Highlight the current line.
      current_line_highlight = "gutter";

      # Show indent guides.
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
        background_coloring = "disabled";
      };

      ######################################################################
      # Formatting
      ######################################################################

      # Format when saving.
      format_on_save = "on";

      ######################################################################
      # Completion
      ######################################################################

      show_completions_on_input = true;
      show_completion_documentation = true;

      ######################################################################
      # LSP
      ######################################################################

      # Richer syntax information from language servers.
      semantic_tokens = "combined";

      # Inlay hints.
      inlay_hints = {
        enabled = true;
      };

      ######################################################################
      # Terminal
      ######################################################################

      terminal = {
        shell = {
          program = "fish";
        };

        font_family = "JetBrainsMono Nerd Font Mono";
        font_size = 16;
      };

      ######################################################################
      # Git
      ######################################################################

      git = {
        inline_blame = {
          enabled = true;
        };
      };

      ######################################################################
      # Project / UI
      ######################################################################

      # Automatically restore the previous workspace.
      restore_on_startup = "last_session";

      # Don't hide the tab bar.
      tabs = {
        show_diagnostics = "errors";
      };

      ######################################################################
      # Language-specific configuration
      ######################################################################

      languages = {
        ####################################################################
        # Nix
        ####################################################################

        Nix = {
          tab_size = 2;
          hard_tabs = false;

          formatter = {
            external = {
              command = "nixfmt";
              arguments = [
                "--filename"
                "{buffer_path}"
              ];
            };
          };

          format_on_save = "on";
        };

        ####################################################################
        # C
        ####################################################################

        C = {
          tab_size = 4;
          hard_tabs = false;

          language_servers = [
            "clangd"
            "!nil"
          ];

          formatter = "language_server";

          format_on_save = "on";

          preferred_line_length = 100;
        };

        ####################################################################
        # C++
        ####################################################################

        "C++" = {
          tab_size = 4;
          hard_tabs = false;

          language_servers = [
            "clangd"
          ];

          formatter = "language_server";

          format_on_save = "on";

          preferred_line_length = 100;
        };

        ####################################################################
        # Rust
        ####################################################################

        Rust = {
          tab_size = 4;
          hard_tabs = false;

          language_servers = [
            "rust-analyzer"
          ];

          formatter = "language_server";

          format_on_save = "on";

          preferred_line_length = 100;
        };

        ####################################################################
        # Python
        ####################################################################

        Python = {
          tab_size = 4;
          hard_tabs = false;

          language_servers = [
            "pyright"
          ];

          formatter = {
            external = {
              command = "black";
              arguments = [
                "-"
              ];
            };
          };

          format_on_save = "on";

          preferred_line_length = 88;
        };

        ####################################################################
        # JavaScript
        ####################################################################

        JavaScript = {
          tab_size = 2;
          hard_tabs = false;

          formatter = {
            external = {
              command = "prettier";
              arguments = [
                "--stdin-filepath"
                "{buffer_path}"
              ];
            };
          };

          format_on_save = "on";

          preferred_line_length = 100;
        };

        ####################################################################
        # TypeScript
        ####################################################################

        TypeScript = {
          tab_size = 2;
          hard_tabs = false;

          formatter = {
            external = {
              command = "prettier";
              arguments = [
                "--stdin-filepath"
                "{buffer_path}"
              ];
            };
          };

          format_on_save = "on";

          preferred_line_length = 100;
        };

        ####################################################################
        # TSX
        ####################################################################

        "TSX" = {
          tab_size = 2;
          hard_tabs = false;

          formatter = {
            external = {
              command = "prettier";
              arguments = [
                "--stdin-filepath"
                "{buffer_path}"
              ];
            };
          };

          format_on_save = "on";

          preferred_line_length = 100;
        };

        ####################################################################
        # JSON
        ####################################################################

        JSON = {
          tab_size = 2;
          hard_tabs = false;

          formatter = "language_server";

          format_on_save = "on";
        };

        ####################################################################
        # YAML
        ####################################################################

        YAML = {
          tab_size = 2;
          hard_tabs = false;
        };

        ####################################################################
        # TOML
        ####################################################################

        TOML = {
          tab_size = 2;
          hard_tabs = false;
        };

        ####################################################################
        # SQL
        ####################################################################

        SQL = {
          tab_size = 2;
          hard_tabs = false;
        };

        ####################################################################
        # Markdown
        ####################################################################

        Markdown = {
          tab_size = 2;
          hard_tabs = false;

          soft_wrap = "editor_width";
        };
      };
    };

    ########################################################################
    # Keybindings
    ########################################################################

    userKeymaps = [
      # --------------------------------------------------------------------
      # Vim-style navigation / convenience
      # --------------------------------------------------------------------

      {
        context = "Editor";
        bindings = {
          "ctrl-s" = "workspace::Save";
          "ctrl-shift-s" = "workspace::SaveAs";
        };
      }

      # --------------------------------------------------------------------
      # Terminal
      # --------------------------------------------------------------------

      {
        context = "Workspace";
        bindings = {
          "ctrl-alt-t" = "terminal_panel::ToggleFocus";
        };
      }

      # --------------------------------------------------------------------
      # File navigation
      # --------------------------------------------------------------------

      {
        context = "Workspace";
        bindings = {
          "ctrl-p" = "file_finder::Toggle";
          "ctrl-shift-p" = "command_palette::Toggle";
        };
      }

      # --------------------------------------------------------------------
      # Format
      # --------------------------------------------------------------------

      {
        context = "Editor";
        bindings = {
          "ctrl-alt-f" = "editor::Format";
        };
      }
    ];

    ########################################################################
    # Tasks
    ########################################################################

    userTasks = [
      {
        label = "Nix Format";
        command = "nixfmt";
        args = [
          "$ZED_FILE"
        ];
      }

      {
        label = "Nix Flake Check";
        command = "nix";
        args = [
          "flake"
          "check"
        ];
        cwd = "$ZED_WORKTREE_ROOT";
      }

      {
        label = "NixOS Rebuild";
        command = "sudo";
        args = [
          "nixos-rebuild"
          "switch"
          "--flake"
          "$ZED_WORKTREE_ROOT"
        ];
        cwd = "$ZED_WORKTREE_ROOT";
      }

      {
        label = "Home Manager Switch";
        command = "home-manager";
        args = [
          "switch"
          "--flake"
          "$ZED_WORKTREE_ROOT"
        ];
        cwd = "$ZED_WORKTREE_ROOT";
      }

      {
        label = "Rust Check";
        command = "cargo";
        args = [
          "check"
        ];
        cwd = "$ZED_WORKTREE_ROOT";
      }

      {
        label = "Rust Test";
        command = "cargo";
        args = [
          "test"
        ];
        cwd = "$ZED_WORKTREE_ROOT";
      }

      {
        label = "C Build";
        command = "clang";
        args = [
          "-Wall"
          "-Wextra"
          "-Wpedantic"
          "-std=c23"
          "$ZED_FILE"
          "-o"
          "$ZED_DIRNAME/$ZED_STEM"
        ];
        cwd = "$ZED_WORKTREE_ROOT";
      }
    ];

    ########################################################################
    # Remote server
    ########################################################################

    installRemoteServer = true;
  };
}
