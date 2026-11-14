{
  pkgs,
  self,
  lib,
  ...
}: {
  programs.yazi = {
    enable = true;

    # -------------------------
    # MAIN SETTINGS (yazi.toml)
    # -------------------------
    settings = {
      mgr = {
        ratio = [2 3 3];
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        sort_translit = false;
        sort_fallback = "alphabetical";
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
        scrolloff = 5;
        mouse_events = ["click" "scroll" "drag"];
      };

      preview = {
        wrap = "no";
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
        image_delay = 30;
        image_filter = "triangle";
        image_quality = 75;
        ueberzug_scale = 1;
        ueberzug_offset = [0 0 0 0];
      };

      tasks = {
        file_workers = 3;
        plugin_workers = 5;
        fetch_workers = 5;
        preload_workers = 2;
        process_workers = 5;
        bizarre_retry = 3;
        image_alloc = 536870912;
        image_bound = [10000 10000];
        suppress_preload = false;
      };

      plugin = {
        fetchers = [
          {
            url = "*/";
            run = "mime.dir";
            prio = "high";
            group = "mime";
          }
          {
            url = "local://*";
            run = "mime.local";
            prio = "high";
            group = "mime";
          }
          {
            url = "remote://*";
            run = "mime.remote";
            prio = "high";
            group = "mime";
          }
        ];

        spotters = [
          {
            mime = "multi/*";
            run = "multi";
          }
          {
            url = "*/";
            run = "folder";
          }
          {
            mime = "text/*";
            run = "code";
          }
          {
            mime = "application/{mbox,javascript,wine-extension-ini}";
            run = "code";
          }
          {
            mime = "image/{avif,hei?,jxl}";
            run = "magick";
          }
          {
            mime = "image/svg+xml";
            run = "svg";
          }
          {
            mime = "image/*";
            run = "image";
          }
          {
            mime = "video/*";
            run = "video";
          }
          {
            mime = "vfs/*";
            run = "vfs";
          }
          {
            mime = "null/*";
            run = "null";
          }
          {
            url = "*";
            run = "file";
          }
        ];

        preloaders = [
          {
            mime = "image/{avif,hei?,jxl}";
            run = "magick";
          }
          {
            mime = "image/svg+xml";
            run = "svg";
          }
          {
            mime = "image/*";
            run = "image";
          }
          {
            mime = "video/*";
            run = "video";
          }
          {
            mime = "application/pdf";
            run = "pdf";
          }
          {
            mime = "font/*";
            run = "font";
          }
          {
            mime = "application/ms-opentype";
            run = "font";
          }
        ];

        previewers = [
          {
            url = "*/";
            run = "folder";
          }
          {
            mime = "text/*";
            run = "code";
          }
          {
            mime = "application/{mbox,javascript,wine-extension-ini}";
            run = "code";
          }
          {
            mime = "application/{json,ndjson}";
            run = "json";
          }
          {
            mime = "image/{avif,hei?,jxl}";
            run = "magick";
          }
          {
            mime = "image/svg+xml";
            run = "svg";
          }
          {
            mime = "image/*";
            run = "image";
          }
          {
            mime = "video/*";
            run = "video";
          }
          {
            mime = "application/pdf";
            run = "pdf";
          }
          {
            mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
            run = "archive";
          }
          {
            mime = "application/{debian*-package,redhat-package-manager,rpm,android.package-archive}";
            run = "archive";
          }
          {
            url = "*.{AppImage,appimage}";
            run = "archive";
          }
          {
            mime = "application/{iso9660-image,qemu-disk,ms-wim,apple-diskimage}";
            run = "archive";
          }
          {
            mime = "application/virtualbox-{vhd,vhdx}";
            run = "archive";
          }
          {
            url = "*.{img,fat,ext,ext2,ext3,ext4,squashfs,ntfs,hfs,hfsx}";
            run = "archive";
          }
          {
            mime = "font/*";
            run = "font";
          }
          {
            mime = "application/ms-opentype";
            run = "font";
          }
          {
            mime = "inode/empty";
            run = "empty";
          }
          {
            mime = "vfs/*";
            run = "vfs";
          }
          {
            mime = "null/*";
            run = "null";
          }
          {
            url = "*";
            run = "file";
          }
        ];
      };

      opener = {
        edit = [
          {
            run = "\${EDITOR:-vi} %s";
            desc = "$EDITOR";
            for = "unix";
            block = true;
          }
          {
            run = "code %s";
            desc = "code";
            for = "windows";
            orphan = true;
          }
          {
            run = "code -w %s";
            desc = "code (block)";
            for = "windows";
            block = true;
          }
        ];

        play = [
          {
            run = "xdg-open %s1";
            desc = "Play";
            for = "linux";
            orphan = true;
          }
          {
            run = "open %s";
            desc = "Play";
            for = "macos";
          }
          {
            run = "start \"\" %s1";
            desc = "Play";
            for = "windows";
            orphan = true;
          }
          {
            run = "termux-open %s1";
            desc = "Play";
            for = "android";
          }
          {
            run = "mediainfo %s1; echo 'Press enter to exit'; read _";
            block = true;
            desc = "Show media info";
            for = "unix";
          }
          {
            run = "mediainfo %s1 & pause";
            block = true;
            desc = "Show media info";
            for = "windows";
          }
        ];

        open = [
          {
            run = "xdg-open %s1";
            desc = "Open";
            for = "linux";
          }
          {
            run = "open %s";
            desc = "Open";
            for = "macos";
          }
          {
            run = "start \"\" %s1";
            desc = "Open";
            for = "windows";
            orphan = true;
          }
          {
            run = "termux-open %s1";
            desc = "Open";
            for = "android";
          }
        ];

        reveal = [
          {
            run = "xdg-open %d1";
            desc = "Reveal";
            for = "linux";
          }
          {
            run = "open -R %s1";
            desc = "Reveal";
            for = "macos";
          }
          {
            run = "explorer /select,%s1";
            desc = "Reveal";
            for = "windows";
            orphan = true;
          }
          {
            run = "termux-open %d1";
            desc = "Reveal";
            for = "android";
          }
          {
            run = "clear; exiftool %s1; echo 'Press enter to exit'; read _";
            desc = "Show EXIF";
            for = "unix";
            block = true;
          }
        ];

        extract = [
          {
            run = "ya pub extract --list %s";
            desc = "Extract here";
          }
        ];

        download = [
          {
            run = "ya emit download --open %S";
            desc = "Download and open";
          }
          {
            run = "ya emit download %S";
            desc = "Download";
          }
        ];
      };

      open.rules = [
        {
          url = "*/";
          use = ["edit" "open" "reveal"];
        }
        {
          mime = "text/*";
          use = ["edit" "reveal"];
        }
        {
          mime = "image/*";
          use = ["open" "reveal"];
        }
        {
          mime = "audio/*";
          use = ["play" "reveal"];
        }
        {
          mime = "video/*";
          use = ["play" "reveal"];
        }
        {
          mime = "application/{json,ndjson,javascript,wine-extension-ini}";
          use = ["edit" "reveal"];
        }
        {
          mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
          use = ["extract" "reveal"];
        }
        {
          mime = "inode/empty";
          use = ["edit" "reveal"];
        }
        {
          mime = "vfs/{absent,stale}";
          use = "download";
        }
        {
          url = "*";
          use = ["open" "reveal"];
        }
      ];

      input.cursor_blink = false;

      confirm = {
        trash_title = "Trash {n} selected file{s}?";
        delete_title = "Permanently delete {n} selected file{s}?";
        overwrite_title = "Overwrite file?";
        overwrite_body = "Will overwrite the following file:";
        quit_title = "Quit?";
        quit_body = "There are unfinished tasks, quit anyway?\n(Open task manager with default key 'w')";
      };

      pick = {
        open_title = "Open with:";
      };

      which.sort_by = "none";
    };

    # -------------------------
    # KEYMAP (keymap.toml)
    # -------------------------
    keymap = {
      mgr = {
        keymap = [
          # Exit / quit
          {
            on = "<Esc>";
            run = "escape";
            desc = "Exit visual mode, clear selection, or cancel search";
          }
          {
            on = "<C-[>";
            run = "escape";
            desc = "Exit visual mode, clear selection, or cancel search";
          }
          {
            on = "q";
            run = "quit";
            desc = "Quit the process";
          }
          {
            on = "Q";
            run = "quit --no-cwd-file";
            desc = "Quit without outputting cwd-file";
          }
          {
            on = "<C-c>";
            run = "close";
            desc = "Close tab or quit";
          }
          {
            on = "<C-z>";
            run = "suspend";
            desc = "Suspend the process";
          }

          # Hopping
          {
            on = "k";
            run = "arrow prev";
            desc = "Previous file";
          }
          {
            on = "j";
            run = "arrow next";
            desc = "Next file";
          }

          {
            on = "<Up>";
            run = "arrow prev";
          }
          {
            on = "<Down>";
            run = "arrow next";
          }

          {
            on = "<C-u>";
            run = "arrow -50%";
          }
          {
            on = "<C-d>";
            run = "arrow 50%";
          }
          {
            on = "<C-b>";
            run = "arrow -100%";
          }
          {
            on = "<C-f>";
            run = "arrow 100%";
          }

          {
            on = "<PageUp>";
            run = "arrow -100%";
          }
          {
            on = "<PageDown>";
            run = "arrow 100%";
          }

          {
            on = "g g";
            run = "arrow top";
          }
          {
            on = "G";
            run = "arrow bot";
          }

          # Navigation
          {
            on = "h";
            run = "leave";
          }
          {
            on = "l";
            run = "enter";
          }

          {
            on = "<Left>";
            run = "leave";
          }
          {
            on = "<Right>";
            run = "enter";
          }

          {
            on = "H";
            run = "back";
          }
          {
            on = "L";
            run = "forward";
          }

          # Toggle
          {
            on = "<Space>";
            run = ["toggle" "arrow 1"];
          }
          {
            on = "<C-a>";
            run = "toggle_all --state=on";
          }
          {
            on = "<C-r>";
            run = "toggle_all";
          }

          # Visual
          {
            on = "v";
            run = "visual_mode";
          }
          {
            on = "V";
            run = "visual_mode --unset";
          }

          # Seek preview
          {
            on = "K";
            run = "seek -5";
          }
          {
            on = "J";
            run = "seek 5";
          }

          # Spot
          {
            on = "<Tab>";
            run = "spot";
          }

          # Open / file ops
          {
            on = "o";
            run = "open";
          }
          {
            on = "O";
            run = "open --interactive";
          }
          {
            on = "<Enter>";
            run = "open";
          }
          {
            on = "<S-Enter>";
            run = "open --interactive";
          }

          {
            on = "y";
            run = "yank";
          }
          {
            on = "x";
            run = "yank --cut";
          }
          {
            on = "p";
            run = "paste";
          }
          {
            on = "P";
            run = "paste --force";
          }

          {
            on = "-";
            run = "link";
          }
          {
            on = "_";
            run = "link --relative";
          }
          {
            on = "<C-->";
            run = "hardlink";
          }

          {
            on = "Y";
            run = "unyank";
          }
          {
            on = "X";
            run = "unyank";
          }

          {
            on = "d";
            run = "remove";
          }
          {
            on = "D";
            run = "remove --permanently";
          }

          {
            on = "a";
            run = "create";
          }
          {
            on = "r";
            run = "rename --cursor=before_ext";
          }

          {
            on = ";";
            run = "shell --interactive";
          }
          {
            on = ":";
            run = "shell --block --interactive";
          }

          {
            on = ".";
            run = "hidden toggle";
          }

          {
            on = "s";
            run = "search --via=fd";
          }
          {
            on = "S";
            run = "search --via=rg";
          }

          {
            on = "<C-s>";
            run = "escape --search";
          }

          {
            on = "z";
            run = "plugin fzf";
          }
          {
            on = "Z";
            run = "plugin zoxide";
          }

          # Linemode
          {
            on = "m s";
            run = "linemode size";
          }
          {
            on = "m p";
            run = "linemode permissions";
          }
          {
            on = "m b";
            run = "linemode btime";
          }
          {
            on = "m m";
            run = "linemode mtime";
          }
          {
            on = "m o";
            run = "linemode owner";
          }
          {
            on = "m n";
            run = "linemode none";
          }

          # Copy
          {
            on = "c c";
            run = "copy path";
          }
          {
            on = "c d";
            run = "copy dirname";
          }
          {
            on = "c f";
            run = "copy filename";
          }
          {
            on = "c n";
            run = "copy name_without_ext";
          }

          # Filter / find
          {
            on = "f";
            run = "filter --smart";
          }
          {
            on = "/";
            run = "find --smart";
          }
          {
            on = "?";
            run = "find --previous --smart";
          }
          {
            on = "n";
            run = "find_arrow";
          }
          {
            on = "N";
            run = "find_arrow --previous";
          }

          # Sorting
          {
            on = ", m";
            run = ["sort mtime --reverse=no" "linemode mtime"];
          }
          {
            on = ", M";
            run = ["sort mtime --reverse=yes" "linemode mtime"];
          }
          {
            on = ", b";
            run = ["sort btime --reverse=no" "linemode btime"];
          }
          {
            on = ", B";
            run = ["sort btime --reverse=yes" "linemode btime"];
          }
          {
            on = ", e";
            run = "sort extension --reverse=no";
          }
          {
            on = ", E";
            run = "sort extension --reverse=yes";
          }
          {
            on = ", a";
            run = "sort alphabetical --reverse=no";
          }
          {
            on = ", A";
            run = "sort alphabetical --reverse=yes";
          }
          {
            on = ", n";
            run = "sort natural --reverse=no";
          }
          {
            on = ", N";
            run = "sort natural --reverse=yes";
          }
          {
            on = ", s";
            run = ["sort size --reverse=no" "linemode size"];
          }
          {
            on = ", S";
            run = ["sort size --reverse=yes" "linemode size"];
          }
          {
            on = ", r";
            run = "sort random --reverse=no";
          }

          # Goto
          {
            on = "g h";
            run = "cd ~";
          }
          {
            on = "g c";
            run = "cd ~/.config";
          }
          {
            on = "g d";
            run = "cd ~/Downloads";
          }
          {
            on = "g <Space>";
            run = "cd --interactive";
          }
          {
            on = "g f";
            run = "follow";
          }

          # Tabs
          {
            on = "t t";
            run = "tab_create --current";
          }
          {
            on = "t r";
            run = "tab_rename --interactive";
          }

          {
            on = "1";
            run = "tab_switch 0";
          }
          {
            on = "2";
            run = "tab_switch 1";
          }
          {
            on = "3";
            run = "tab_switch 2";
          }
          {
            on = "4";
            run = "tab_switch 3";
          }
          {
            on = "5";
            run = "tab_switch 4";
          }
          {
            on = "6";
            run = "tab_switch 5";
          }
          {
            on = "7";
            run = "tab_switch 6";
          }
          {
            on = "8";
            run = "tab_switch 7";
          }
          {
            on = "9";
            run = "tab_switch 8";
          }

          {
            on = "[";
            run = "tab_switch -1 --relative";
          }
          {
            on = "]";
            run = "tab_switch 1 --relative";
          }

          {
            on = "{";
            run = "tab_swap -1";
          }
          {
            on = "}";
            run = "tab_swap 1";
          }

          # Tasks / help
          {
            on = "w";
            run = "tasks:show";
          }
          {
            on = "~";
            run = "help";
          }
          {
            on = "<F1>";
            run = "help";
          }
        ];
      };

      tasks = {
        keymap = [
          {
            on = "<Esc>";
            run = "close";
          }
          {
            on = "<C-[>";
            run = "close";
          }
          {
            on = "<C-c>";
            run = "close";
          }
          {
            on = "w";
            run = "close";
          }

          {
            on = "k";
            run = "arrow prev";
          }
          {
            on = "j";
            run = "arrow next";
          }

          {
            on = "<Up>";
            run = "arrow prev";
          }
          {
            on = "<Down>";
            run = "arrow next";
          }

          {
            on = "<Enter>";
            run = "inspect";
          }
          {
            on = "x";
            run = "cancel";
          }

          {
            on = "~";
            run = "help";
          }
          {
            on = "<F1>";
            run = "help";
          }
        ];
      };

      spot = {
        keymap = [
          {
            on = "<Esc>";
            run = "close";
          }
          {
            on = "<C-[>";
            run = "close";
          }
          {
            on = "<C-c>";
            run = "close";
          }
          {
            on = "<Tab>";
            run = "close";
          }

          {
            on = "k";
            run = "arrow prev";
          }
          {
            on = "j";
            run = "arrow next";
          }
          {
            on = "h";
            run = "swipe prev";
          }
          {
            on = "l";
            run = "swipe next";
          }

          {
            on = "<Up>";
            run = "arrow prev";
          }
          {
            on = "<Down>";
            run = "arrow next";
          }
          {
            on = "<Left>";
            run = "swipe prev";
          }
          {
            on = "<Right>";
            run = "swipe next";
          }

          {
            on = "c c";
            run = "copy cell";
          }

          {
            on = "~";
            run = "help";
          }
          {
            on = "<F1>";
            run = "help";
          }
        ];
      };

      pick = {
        keymap = [
          {
            on = "<Esc>";
            run = "close";
          }
          {
            on = "<C-[>";
            run = "close";
          }
          {
            on = "<C-c>";
            run = "close";
          }
          {
            on = "<Enter>";
            run = "close --submit";
          }

          {
            on = "k";
            run = "arrow prev";
          }
          {
            on = "j";
            run = "arrow next";
          }

          {
            on = "<Up>";
            run = "arrow prev";
          }
          {
            on = "<Down>";
            run = "arrow next";
          }

          {
            on = "~";
            run = "help";
          }
          {
            on = "<F1>";
            run = "help";
          }
        ];
      };

      input = {
        keymap = [
          {
            on = "<C-c>";
            run = "close";
          }
          {
            on = "<Enter>";
            run = "close --submit";
          }
          {
            on = "<Esc>";
            run = "escape";
          }
          {
            on = "<C-[>";
            run = "escape";
          }

          {
            on = "i";
            run = "insert";
          }
          {
            on = "I";
            run = ["move first-char" "insert"];
          }
          {
            on = "a";
            run = "insert --append";
          }
          {
            on = "A";
            run = ["move eol" "insert --append"];
          }

          {
            on = "v";
            run = "visual";
          }
          {
            on = "r";
            run = "replace";
          }

          {
            on = "V";
            run = ["move bol" "visual" "move eol"];
          }

          {
            on = "<C-a>";
            run = ["move eol" "visual" "move bol"];
          }
          {
            on = "<C-e>";
            run = ["move bol" "visual" "move eol"];
          }

          {
            on = "h";
            run = "move -1";
          }
          {
            on = "l";
            run = "move 1";
          }

          {
            on = "<Left>";
            run = "move -1";
          }
          {
            on = "<Right>";
            run = "move 1";
          }

          {
            on = "<C-b>";
            run = "move -1";
          }
          {
            on = "<C-f>";
            run = "move 1";
          }

          {
            on = "b";
            run = "backward";
          }
          {
            on = "w";
            run = "forward";
          }
          {
            on = "e";
            run = "forward --end-of-word";
          }

          {
            on = "0";
            run = "move bol";
          }
          {
            on = "$";
            run = "move eol";
          }

          {
            on = "<Backspace>";
            run = "backspace";
          }
          {
            on = "<Delete>";
            run = "backspace --under";
          }

          {
            on = "<C-u>";
            run = "kill bol";
          }
          {
            on = "<C-k>";
            run = "kill eol";
          }

          {
            on = "d";
            run = "delete --cut";
          }
          {
            on = "c";
            run = "delete --cut --insert";
          }
          {
            on = "x";
            run = ["delete --cut" "move 1 --in-operating"];
          }

          {
            on = "y";
            run = "yank";
          }
          {
            on = "p";
            run = "paste";
          }

          {
            on = "u";
            run = ["undo" "casefy lower"];
          }
          {
            on = "<C-r>";
            run = "redo";
          }

          {
            on = "~";
            run = "help";
          }
          {
            on = "<F1>";
            run = "help";
          }
        ];
      };

      confirm = {
        keymap = [
          {
            on = "<Esc>";
            run = "close";
          }
          {
            on = "<C-[>";
            run = "close";
          }
          {
            on = "<C-c>";
            run = "close";
          }
          {
            on = "<Enter>";
            run = "close --submit";
          }

          {
            on = "n";
            run = "close";
          }
          {
            on = "y";
            run = "close --submit";
          }

          {
            on = "k";
            run = "arrow prev";
          }
          {
            on = "j";
            run = "arrow next";
          }

          {
            on = "<Up>";
            run = "arrow prev";
          }
          {
            on = "<Down>";
            run = "arrow next";
          }

          {
            on = "~";
            run = "help";
          }
          {
            on = "<F1>";
            run = "help";
          }
        ];
      };

      cmp = {
        keymap = [
          {
            on = "<C-c>";
            run = "close";
          }
          {
            on = "<Tab>";
            run = "close --submit";
          }
          {
            on = "<Enter>";
            run = ["close --submit" "input:close --submit"];
          }

          {
            on = "<A-k>";
            run = "arrow prev";
          }
          {
            on = "<A-j>";
            run = "arrow next";
          }

          {
            on = "<Up>";
            run = "arrow prev";
          }
          {
            on = "<Down>";
            run = "arrow next";
          }

          {
            on = "<C-p>";
            run = "arrow prev";
          }
          {
            on = "<C-n>";
            run = "arrow next";
          }

          {
            on = "~";
            run = "help";
          }
          {
            on = "<F1>";
            run = "help";
          }
        ];
      };

      help = {
        keymap = [
          {
            on = "<Esc>";
            run = "escape";
          }
          {
            on = "<C-[>";
            run = "escape";
          }
          {
            on = "<C-c>";
            run = "close";
          }

          {
            on = "k";
            run = "arrow prev";
          }
          {
            on = "j";
            run = "arrow next";
          }

          {
            on = "<Up>";
            run = "arrow prev";
          }
          {
            on = "<Down>";
            run = "arrow next";
          }

          {
            on = "f";
            run = "filter";
          }
        ];
      };
    };

    plugins = {
      lazygit = pkgs.yaziPlugins.lazygit;
      full-border = pkgs.yaziPlugins.full-border;
      git = pkgs.yaziPlugins.git;
      smart-enter = pkgs.yaziPlugins.smart-enter;
    };

    initLua = ''
      require("full-border"):setup()
         require("git"):setup()
         require("smart-enter"):setup {
           open_multi = true,
         }
    '';

    # -------------------------
    # THEME / FLAVOR
    # -------------------------
  };

  home.sessionVariables = {
    FILE_MANAGER = "yazi";
  };
}
