{writeShellApplication}:
writeShellApplication {
  name = "plow";

  text = builtins.readFile ./plow.bash;
}
