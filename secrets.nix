let
  buffet = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOA928bjB90FwkTLtQcPW1mP+QLViVfEVdMHg+7/8Fxh";
in {
  "secrets/bitwarden.age".publicKeys = [buffet];
  "secrets/borgpassword.age".publicKeys = [buffet];
}
