{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./gruvbox.nix
      #inputs.nixvim.nixosModules.nixvim
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
  services = {
    libinput = {
      enable = true;

      # disabling mouse acceleration
      mouse = {
        accelProfile = "flat";
      };
  };
  };

  # Enable the Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
   enable = true;
    xkb = {
        layout = "us";
        variant = "dvorak";
      };
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/alsa.conf" ''
        monitor.alsa.rules = [
          {
            matches = [
              {
                device.name = "~alsa_card.*"
              }
            ]
            actions = {
              update-props = {
                # Device settings
                api.alsa.use-acp = true
              }
            }
          }
          {
            matches = [
              {
                node.name = "~alsa_input.pci.*"
              }
              {
                node.name = "~alsa_output.pci.*"
              }
            ]
            actions = {
            # Node settings
              update-props = {
                session.suspend-timeout-seconds = 0
              }
            }
          }
        ]
      '')
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.desktop = {
    isNormalUser = true;
    description = "Desktop";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
    packages = with pkgs; [
    #  firefox
    #  kate
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # hyprland
  #programs.hyprland.enable = true;
  # Optional, hint electron apps to use wayland:
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";

  systemd.targets.hibernate.enable = false;
  
  #security.pam.services.swaylock = {};

  # flakes and optimize storage
    nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    };

  # enable zram
  zramSwap.enable = true;

  #docker
  #virtualisation.docker.enable = true;
  #virtualisation.podman.enable = true;

  #vm
   #virtualisation.virtualbox.host.enable = true;
   #virtualisation.virtualbox.guest.enable = true;
   #users.extraGroups.vboxusers.members = [ "desktop" ];
   #virtualisation.virtualbox.host.enable = true;
   #virtualisation.virtualbox.host.enableExtensionPack = true;

  # Enable flatpak support
  services.flatpak.enable = true;

  # kdeconnect
  programs.kdeconnect.enable = true;

  # enable custom fonts
  fonts.fontDir.enable = true;

  programs.steam = {
  	enable = true;
  	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.steam.gamescopeSession.enable = true;

  # enable auto update
  #system.autoUpgrade.enable = true;

  #programs.java.enable = true; 
  #programs.steam.package = pkgs.steam.override { withJava = true; };

  programs.partition-manager.enable = true;

  #programs.nixvim.enable = true;

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
    ranger
    delta
    grcov

    gnumake
    cmake
    nixpkgs-fmt
    clang
    gcc
    libtool

    # gnome
    #gnome.gnome-tweaks
    #gnome-extension-manager
    #gtk-engine-murrine
    #gnome.gnome-themes-extra

    # browsers
    #firefox
    floorp
    brave

    # editors
    vscode
    emacs
    #jetbrains.idea-community
    #jetbrains.pycharm-community
    #obsidian

    (aspellWithDicts (dicts: with dicts; [
      en
      en-computers
      en-science
      es
    ]))

    strawberry-qt6

    # develop
    #godot_4

    # comunication
    thunderbird
    vesktop

    # utils
    #bitwarden
    nvtopPackages.amd
    ventoy-full
    jq
    socat
    #pamixer
    #brightnessctl

    # extra
    zathura
    qbittorrent

    # gaming
    wineWow64Packages.waylandFull
    lutris
    heroic
    protonup-qt
    protontricks
    rpcs3
    pcsx2
    #retroarch

    # rice
    #simp1e-cursors
    #yaru-theme
    #wlogout
    #envsubst
    #swww
    #wofi
    #dunst
    #cliphist
    #rofi-wayland
    #swappy
    #grimblast
    pokemon-colorscripts-mac
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?
}
