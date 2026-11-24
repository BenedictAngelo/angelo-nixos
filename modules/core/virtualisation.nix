{pkgs, ...}: {
  virtualisation = {
    # Enable only one container engine
    docker.enable = true;
    podman.enable = false;

    libvirtd = {
      enable = true;
      #onBoot = "start";
      #onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
    };

    virtualbox.host = {
      enable = false;
      enableExtensionPack = true;
    };
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  networking.firewall.trustedInterfaces = ["virbr0"];

  environment.systemPackages = with pkgs; [
    virt-viewer
    virtiofsd
    spice
    spice-gtk
    swtpm
    lazydocker

    # Network emulation
    ubridge
    dynamips
    vpcs

    gns3-gui
    gns3-server

    cisco-packet-tracer

    # Useful utilities
    inetutils
    wireshark
  ];
  # Only uncomment if you want to autostart network bridge upon boot
  /*
  systemd.services.libvirt-default-network = {
  description = "Start libvirt default network";

  after = [ "libvirtd.service" ];
  wants = [ "libvirtd.service" ];
  wantedBy = [ "multi-user.target" ];

  serviceConfig.Type = "oneshot";

  script = ''
    ${pkgs.libvirt}/bin/virsh net-autostart default || true
    ${pkgs.libvirt}/bin/virsh net-start default || true
  '';
  };
  */
}
