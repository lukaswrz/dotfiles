{writeShellApplication}:
writeShellApplication {
  name = "codeinit";

  text = builtins.readFile ./codeinit.bash;
}
