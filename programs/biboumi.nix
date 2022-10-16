{config, ...}: {
  age.secrets.biboumi.file = ../secrets/biboumi.age;

  services.biboumi = {
    enable = true;
    credentialsFile = config.age.secrets.biboumi.path;
    settings = {
      admin = ["buffet@buffet.sh"];
      hostname = "biboumi.localhost";
      password = null; # set in secret
    };
  };
}
