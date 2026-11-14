{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;

    shellAliases = {
      homecheck = "echo \"Home manager working great\"";

      cat = "bat --paging=never";
      man = "batman";
      ga = "git add -A";
      gc = ''git commit -m "Quick Commit and Push"'';
      gph = "git push origin main";
      gpl = "git pull";
      gs = "git status";
    };

    shellAbbrs = {
      n = "nvim";
      y = "yazi";
      e = "exit";
      c = "clear";
    };
    shellInit = ''
      function fish_greeting
        fastfetch
      end

      function fish_prompt
        echo ""

        set dir (string replace -r "^$HOME" "~" $PWD)
        echo $dir

        echo "> "
      end
    '';

    functions = {
      gitquick = ''
        git add -A
        git commit -m "nixos: $(date '+%Y-%m-%d %H:%M')"
      '';

      gitfull = ''
        gitquick && git push origin main
      '';

      y = ''
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        command yazi $argv --cwd-file="$tmp"

        if read -z cwd <"$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"
          builtin cd -- "$cwd"
        end

        rm -f -- "$tmp"
      '';

      update = ''
        pushd ~/angelo-nixos/ >/dev/null
        gitfull
        if nix flake update
          echo "✅ Update successful"
        else
          echo "❌ Update failed"
        end

        popd >/dev/null
      '';
      home-rebuild = ''

        set HOST (hostname)

        pushd ~/angelo-nixos/ >/dev/null

        gitfull

        if home-manager switch --flake .#$HOST
            echo "✅ Home rebuild successful"
            gitfull
        else
            echo "❌ Home rebuild failed, not pushing"
        end

        popd >/dev/null
      '';
      rebuild = ''
        set HOST (hostname)

        pushd ~/angelo-nixos/ >/dev/null

        gitfull

        if sudo nixos-rebuild switch --flake .#$HOST
          echo "✅ Rebuild successful"
          gitfull
        else
          echo "❌ Rebuild failed, not pushing"
        end

        popd >/dev/null
      '';

      upgrade = ''
        update
        rebuild
      '';

      clean = ''
        sudo nix-collect-garbage -d --delete-older-than 3d
        nix-collect-garbage -d --delete-older-than 3d
      '';

      optimise = ''
        nix store gc && nix store optimise && sudo nix store optimise
      '';

      fullclean = ''
        clean && optimise
      '';
    };

    # Environment variables
    interactiveShellInit = ''

      # PATH (Nix-safe way)
      fish_add_path $HOME/.cargo/bin

    '';
  };
}
