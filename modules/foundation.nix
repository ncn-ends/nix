{ machine, ...}:
{
  environment.variables = {
    NIX_HOME = machine.nixConfigRoot;
  };
}