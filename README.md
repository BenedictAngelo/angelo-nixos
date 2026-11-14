# angelo-nixos

A modular NixOS configuration built with Nix Flakes and Home Manager. The repository currently exposes one complete system configuration, `nixos-btw`, while retaining reusable hardware profiles and shared modules for other machine types.

This is a personal infrastructure project and a record of how the system is assembled. It is not presented as a universal, plug-and-play installer: hardware settings, user details, disk identifiers, and secret recipients must be reviewed before adapting it to another machine.

## Project status

- **Active configuration in this repository:** `nixos-btw`
- **System architecture:** `x86_64-linux`
- **NixOS release branch:** `nixos-26.05`
- **User environment:** Home Manager
- **Desktop configuration:** selectable through host variables; the checked-in host selects Noctalia on Niri
- **Secrets:** SOPS-Nix with Age

Other hardware profiles remain in `profiles/` as reusable starting points, but they are not currently exposed as flake configurations. Their presence does not imply that matching host-specific hardware files are included or tested.

## Highlights

- Flake-based NixOS system definition with a shared `mkSystem` helper.
- Host-specific settings separated from reusable system and Home Manager modules.
- Hardware profiles for NVIDIA laptops, NVIDIA systems, AMD, Intel, AMD/NVIDIA hybrid systems, and virtual machines.
- Home Manager-managed shell, terminal, editor, desktop, and development environments.
- NVIDIA/Intel Prime configuration for the current laptop profile.
- Niri/Noctalia and Hyprland-related configuration modules.
- Stylix theming, SOPS-Nix/Age secrets integration, and optional Flatpak support.
- Development tools for Python, C/C++, Rust, Web/TypeScript, and CSS.
- System services and virtualization configuration, including Docker and libvirt.

The modules contain additional optional configurations. A module's presence does not mean it is enabled on the current host; consult `hosts/nixos-btw/variables.nix` and the selected profile.

## Repository layout

```text
.
├── flake.nix                 # Flake inputs, system constructor, and outputs
├── flake.lock                # Locked input revisions
├── .sops.yaml                # Age recipients and SOPS creation rules
├── hosts/
│   └── nixos-btw/
│       ├── default.nix       # Host-specific imports
│       ├── hardware.nix      # Generated hardware and filesystem settings
│       ├── host-packages.nix # Host-specific packages and services
│       └── variables.nix     # User and desktop configuration choices
├── profiles/                 # Reusable hardware/system profiles
├── modules/
│   ├── core/                 # Shared NixOS system modules
│   ├── drivers/              # Optional GPU and VM driver modules
│   └── home/                 # Home Manager modules and user tooling
├── secrets/
│   └── secrets.yaml          # SOPS-encrypted secrets
└── wallpapers/               # Local wallpaper assets referenced by the config
```

## How the configuration is composed

`flake.nix` defines `nixosConfigurations.nixos-btw` through the local `mkSystem` helper. The helper passes shared arguments (`inputs`, `host`, `profile`, and `users`) into the NixOS module system, imports the selected profile, and adds the Nix Flatpak and SOPS-Nix modules.

The selected profile, `profiles/nvidia-laptop/`, imports:

1. `hosts/nixos-btw/` for machine-specific settings and hardware;
2. `modules/drivers/` for the custom driver options;
3. `modules/core/` for shared system configuration.

The core user module imports Home Manager and loads `modules/home/`. Home Manager modules then select the shell, terminal, desktop environment, and optional features using values from `hosts/nixos-btw/variables.nix`.

## Current host configuration

The checked-in host uses the `nvidia-laptop` profile. Its profile enables the NVIDIA driver and Intel/NVIDIA Prime offload, with PCI bus IDs supplied by `variables.nix`.

Host choices and toggles are centralized in `hosts/nixos-btw/variables.nix`. Review that file before rebuilding or adapting the configuration. In particular, it contains personal Git identity settings, display and keyboard choices, monitor settings, application defaults, and hardware identifiers.

`hosts/nixos-btw/hardware.nix` contains machine-specific filesystem UUIDs and generated hardware settings. **Do not copy this file unchanged to another computer.** Generate a new hardware configuration for the target machine and compare it carefully before applying it.

## Requirements

- A NixOS installation matching the configuration's supported architecture and NixOS release branch.
- Flakes enabled (`nix-command` and `flakes`).
- Access to the flake inputs referenced in `flake.nix`.
- Correct host-specific hardware configuration and Age private key before activation.

The configuration uses unfree packages. Some packages or upstream inputs may change over time; the lock file records the selected flake input revisions, but it does not guarantee that every future build will remain available.

## Inspect and build

From the repository root:

```sh
# Evaluate/check the flake outputs
nix flake check

# Build the current system configuration without activating it
nixos-rebuild build --flake .#nixos-btw

# Apply the configuration only after reviewing the changes
sudo nixos-rebuild switch --flake .#nixos-btw
```

The build command does not switch the running system. Review the diff and confirm hardware, boot, networking, and secrets settings before activation. Keep a working recovery path when changing boot or graphics configuration.

## Customize the host

Most host-level choices are in `hosts/nixos-btw/variables.nix`. Examples include:

- `shellChoice` and `terminalChoice`;
- `barChoice` for the desktop/window-manager path;
- `displayManager`;
- optional Flatpak, printing, Thunar, and application toggles;
- monitor layout and keyboard settings;
- NVIDIA/Intel PCI bus IDs.

The reusable profiles in `profiles/` are intended to be paired with a matching directory under `hosts/`. Only `nixos-btw` is currently wired into `flake.nix`; the other profiles are retained as module templates and are not ready-to-build host configurations on their own.

## Secrets management: SOPS-Nix and Age

Secrets are intended to be stored encrypted with [SOPS](https://github.com/getsops/sops) and decrypted at runtime by [sops-nix](https://github.com/Mic92/sops-nix). The repository's `.sops.yaml` defines an Age recipient for YAML files under `secrets/`.

The encrypted `secrets/secrets.yaml` file is included in this repository. It contains SOPS-encrypted values and is intended to be version-controlled. The configuration expects the encrypted file and an authorized Age private key to be available before secrets can be decrypted. Never commit the Age private key or plaintext credentials.

### 1. Generate an Age key

On the target machine:

```sh
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
age-keygen -y ~/.config/sops/age/keys.txt
```

The output of the second command is the Age **public** key. The private key remains in `keys.txt`; never commit or share it.

Install the private key at the path configured by `modules/core/secrets.nix`:

```sh
sudo install -d -m 700 /var/lib/sops-nix
sudo install -m 600 \
  ~/.config/sops/age/keys.txt \
  /var/lib/sops-nix/keys.txt
```

Keep a secure backup of the private key. A machine cannot decrypt secrets encrypted for a key that has been lost.

### 2. Configure recipients

`.sops.yaml` currently defines a recipient for `secrets/*.yaml`. To authorize another machine, add its Age public key to the appropriate `key_groups` entry. Public keys may be committed; private keys must not be.

After changing recipients, update the encrypted file on a machine that can already decrypt it:

```sh
sops updatekeys -y secrets/secrets.yaml
```

### 3. Create or edit the encrypted file

From the repository root:

```sh
mkdir -p secrets
sops secrets/secrets.yaml
```

Edit the YAML in the SOPS editor. SOPS encrypts the file when it is saved. Do not edit the encrypted file with a normal editor or paste decrypted values into Nix expressions.

The encrypted SOPS file is intentionally included in version control. Do not add the entire `secrets/` directory to `.gitignore` if the encrypted file is meant to be versioned. Never commit Age private keys or plaintext secret files.

### 4. Declare runtime secrets

`modules/core/secrets.nix` configures the Age key path and default encrypted file, then declares individual secrets under `sops.secrets`. Add declarations that match the keys in your encrypted YAML file. For example:

```nix
{
  sops.age.keyFile = "/var/lib/sops-nix/keys.txt";
  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  sops.secrets.example_secret = { };

  sops.secrets.api_token = {
    owner = "angelo";
    mode = "0400";
  };
}
```

The owner should be the account that needs access. Decrypted files are made available under `/run/secrets/` by default. Keep the declarations synchronized with the keys in the encrypted YAML file.

### 5. Consume a secret at runtime

For example, a Fish shell can read a runtime secret without embedding its contents in the Nix store:

```nix
{ ... }:
{
  programs.fish = {
    enable = true;
    shellInit = ''
      if test -r /run/secrets/api_token
        set -gx API_TOKEN (cat /run/secrets/api_token)
      end
    '';
  };
}
```

Verify that the variable is set without printing the value:

```fish
test -n "$API_TOKEN"; and echo "API token loaded"
```

Environment variables may be visible to processes running as the same user. Prefer passing runtime file paths directly to applications when they support that pattern.

### 6. Rebuild and verify

After restoring the encrypted file, installing the private key, and declaring the matching secret names:

```sh
sudo nixos-rebuild build --flake .#nixos-btw
sudo nixos-rebuild switch --flake .#nixos-btw
sudo test -s /run/secrets/example_secret \
  && echo "Secret is available"
```

Avoid printing real secret contents in terminal logs, screenshots, or support requests.

### Secrets safety checklist

- Never commit an Age private key, `keys.txt`, plaintext credentials, or decrypted secret files.
- Keep `.sops.yaml` and the encrypted SOPS YAML under version control when appropriate.
- Use `sops` to edit encrypted files and `sops updatekeys` after changing recipients.
- Do not use `builtins.readFile` to embed plaintext secrets into Nix expressions.
- Keep file ownership and permissions as restrictive as the consuming service allows.
- Back up private keys securely and ensure each target machine is an authorized recipient.

## Repository hygiene

The `.gitignore` excludes local build outputs, development state, editor files, local environment files, and common private-key filenames. It intentionally does not ignore the encrypted SOPS YAML or the wallpaper directory, because the configuration references wallpaper assets.

Before publishing, review at least:

- `hosts/nixos-btw/variables.nix` for your personal Git email and local preferences;
- `hosts/nixos-btw/hardware.nix` for filesystem UUIDs and machine-specific details;
- `modules/home/hyprland/face.jpg` and other image assets for suitability for public distribution;
- `.sops.yaml` and the encrypted secrets file to confirm that no private key or plaintext secret is present.

The Git history in an existing clone is separate from the working tree. Removing a large file from the current directory or adding it to `.gitignore` does not remove it from previous commits. Review repository history separately before publishing.

## License

No license is declared in this repository. Add a license only after deciding how you want others to use, modify, and redistribute the project.
