{ pkgs, config, ... }:

{
  stylix = {
     enable = true;
     image = ../assets/Kojiro.png;
     polarity = "dark";
 
     base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

     fonts = {
        monospace = {
	 package = pkgs.fira-code-nerdfont;
         name = "Fira Code Nerd Font";
        };

     serif = config.stylix.fonts.monospace;
     sansSerif = config.stylix.fonts.monospace;
     emoji = config.stylix.fonts.monospace;
     };
   };
}
