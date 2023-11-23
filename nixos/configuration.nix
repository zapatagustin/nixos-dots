{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "dvorak";
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.desktop = {
    isNormalUser = true;
    description = "Desktop";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  firefox
    #  kate
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # hyprland
  programs.hyprland.enable = true;

  # flakes and optimize storage
    nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    };

  # enable zram
  zramSwap.enable = true;

  # Enable bluethooth
  hardware = {
    bluetooth = {
        enable = true;
        settings.General.Experimental = true;
    };
  };

  #docker
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  # Enable flatpak support
  services.flatpak.enable = true;

  # kdeconnect
  programs.kdeconnect.enable = true;

  # enable custom fonts
  	fonts.fontDir.enable = true;

  fonts = {
  	packages = with pkgs; [
		jetbrains-mono
		cascadia-code
 	 	(nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
	];
  };

  programs.steam = {
  	enable = true;
  	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "electron-24.8.6"
  ];

  # enable auto update
  system.autoUpgrade.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # elemental
    git
    xclip
    wl-clipboard
    btop
    unzip
    curl
    wget
    fd
    ripgrep
    fd
    kitty
    wezterm

    # languages
    nodejs_20
    python3
    poetry
    go
    gopls
    gcc
    lua
    luarocks
    stylua
    luajitPackages.jsregexp

    # browsers
    (librewolf.override { nativeMessagingHosts = [ libsForQt5.plasma-browser-integration ]; })
    ungoogled-chromium
    brave

    # editors
    neovim
    lazygit
    vscode
    jetbrains.idea-community
    jetbrains.pycharm-community

    # comunication
    thunderbird
    webcord

    #utils
    nwg-look
    gnome.nautilus
    blueberry
    jq
    socat

    # extra
    zathura
    qbittorrent

    # gaming
    gamescope
    wineWow64Packages.waylandFull
    lutris
    heroic
    protonup-qt
    protontricks

    # rice
    eww-wayland
    hyprpaper
    wofi
    waybar
    dunst
    cliphist
    rofi-wayland
    grimblast
    slurp
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
