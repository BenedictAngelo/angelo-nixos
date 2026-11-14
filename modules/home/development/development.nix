{
  pkgs,
  unstable,
  ...
}: {
  home.packages = [
    # ─────────────────────────────────────────────
    # Python
    # ─────────────────────────────────────────────
    pkgs.python3Packages.pip
    pkgs.python3Packages.virtualenv
    pkgs.python3Packages.setuptools
    pkgs.python3Packages.black
    pkgs.python3Packages.flake8
    pkgs.python3Packages.mypy
    pkgs.python3Packages.requests
    pkgs.python3Packages.scipy
    pkgs.python3Packages.numpy
    pkgs.python3Packages.pandas
    pkgs.python3Packages.matplotlib
    pkgs.python3Packages.torch
    pkgs.python3Packages.scikit-learn
    pkgs.python3Packages.jupyterlab
    pkgs.python3Packages.django
    pkgs.python3Packages.flask
    pkgs.python3Packages.fastapi
    pkgs.python3Packages.sqlalchemy
    pkgs.python3Packages.pydantic
    pkgs.python3Packages.uvicorn
    pkgs.uv

    # ─────────────────────────────────────────────
    # C / C++
    # ─────────────────────────────────────────────
    pkgs.clang
    pkgs.gnumake
    pkgs.cmake
    pkgs.pkg-config

    # ─────────────────────────────────────────────
    # Rust
    # ─────────────────────────────────────────────
    unstable.rustc
    unstable.cargo
    unstable.rustfmt
    unstable.clippy
    unstable.cargo-leptos
    unstable.cargo-watch
    unstable.cargo-edit
    unstable.cargo-generate
    unstable.wasm-pack
    unstable.leptosfmt
    unstable.lld
    unstable.wasm-bindgen-cli_0_2_129
    unstable.topcoat-cli
    (unstable.trunk.overrideAttrs (old: {
      buildInputs =
        (old.buildInputs or [])
        ++ [
          pkgs.zstd.dev
        ];
    }))
    (unstable.dioxus-cli.overrideAttrs (old: {
      buildInputs =
        (old.buildInputs or [])
        ++ [
          unstable.zstd.dev
        ];
    }))
    # ─────────────────────────────────────────────
    # Web / TypeScript
    # ─────────────────────────────────────────────
    pkgs.nodejs
    pkgs.typescript
    pkgs.typescript-language-server

    # Formatting / linting
    pkgs.prettier

    # ─────────────────────────────────────────────
    # CSS
    # ─────────────────────────────────────────────
    pkgs.tailwindcss
    pkgs.sass
    # ─────────────────────────────────────────────
    # AI
    # ─────────────────────────────────────────────
    pkgs.claude-code
  ];

  services.ollama = {
    enable = true;
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "32768";
    };
  };

  # pip
  home.file.".config/pip/pip.conf".text = ''
    [global]
    user = true
  '';

  home.sessionVariables = {
    PIP_USER = "1";
  };

  # Weather.py wrapper
  home.file.".local/bin/weather" = {
    text = ''
      #!/bin/sh
      exec ${
        pkgs.python3.withPackages (p: [p.requests])
      }/bin/python3 "$HOME/.config/waybar/scripts/Weather.py" "$@"
    '';
    executable = true;
  };

  home.sessionPath = [
    "${pkgs.python3}/bin"
    "$HOME/.cargo/bin"
  ];
}
