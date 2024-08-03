{ config, pkgs, inputs, ... }:

{
  imports = [
    #inputs.nixvim.homeManagerModules.nixvim
    ./programs
  ];

  home.username = "desktop";
  home.homeDirectory = "/home/desktop";

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
}
