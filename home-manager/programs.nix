{
  config,
  pkgs,
  inputs,
  ...
}:
let
  neovimconfig = import ../vim;
  nvim = inputs.nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule {
    inherit pkgs;
    module = neovimconfig;
  };
in 
{
  home.packages = with pkgs; [
    nvim
    # ...
  ];


  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    # ...
  };
}
