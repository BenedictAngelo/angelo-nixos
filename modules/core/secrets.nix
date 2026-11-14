{
  sops.age.keyFile = "/var/lib/sops-nix/keys.txt";

  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  sops.secrets.hello = {};
}
