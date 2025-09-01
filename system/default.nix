{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  hardware.keyboard.qmk.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [ 
      sane-airscan 
      hplipWithPlugin 
    ];
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.modemmanager.enable = true;
  networking.firewall.allowedUDPPorts = [ 14550 14551 14552 ];

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT    = "pl_PL.UTF-8";
    LC_MONETARY       = "pl_PL.UTF-8";
    LC_NAME           = "pl_PL.UTF-8";
    LC_NUMERIC        = "pl_PL.UTF-8";
    LC_PAPER          = "pl_PL.UTF-8";
    LC_TELEPHONE      = "pl_PL.UTF-8";
    LC_TIME           = "pl_PL.UTF-8";
  };

  console.keyMap = "pl2";
  
  nix.settings = {
    allowed-users = [ "igorstankiewicz" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    displayManager.ly.enable = true;
    printing.enable = true;
    printing.drivers = with pkgs; [ 
      hplip 
      gutenprint 
    ];
    blueman.enable = true;
    flatpak.enable = true;
    upower.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    udev.packages = with pkgs; [ 
      sane-backends 
      via
    ];
    udev.extraRules = ''
      # 1. USB-LTE Modem  
      ATTR{idVendor}=="12d1", ATTR{idProduct}=="14fe", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 12d1 -p 14fe -M '55534243123456780000000000000011062000000100000000000000000000'"
    '';
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-gtk 
    ];
  };

  users.users.igorstankiewicz = {
    isNormalUser = true;
    description = "Igor Stankiewicz";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    packages = with pkgs; [
      gimp 
      chromium 
      neovim 
      git 
      simple-scan 
      freeoffice 
      libreoffice
      seafile-client 
      qtcreator 
      cmake 
      virtualbox 
      tela-icon-theme
      papirus-icon-theme 
      gruvbox-plus-icons 
      gruvbox-gtk-theme 
      simp1e-cursors
      adwsteamgtk
      heroic
    ];
  };

  environment.systemPackages = with pkgs; [
    neofetch 
    vscode 
    xfce.thunar 
    xfce.thunar-volman 
    xfce.thunar-media-tags-plugin
    waybar (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
    playerctl 
    brightnessctl 
    pavucontrol 
    mako 
    libnotify 
    hyprpaper 
    kitty
    rofi-wayland 
    nwg-look 
    hyprpolkitagent 
    file-roller 
    gparted 
    grim 
    slurp
    wl-clipboard 
    imv 
    zathura 
    udiskie 
    vlc 
    jq 
    gtop 
    qalculate-gtk 
    procps
    lm_sensors 
    fragments 
    system-config-printer 
    zenity 
    wine
    wineWowPackages.waylandFull 
    wineasio
    winetricks
    unixODBC
    bottles 
    corefonts 
    usbutils 
    usb-modeswitch
    via
    parted
    caligula
  ];

  programs.hyprland.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.yazi = {
    enable = true;
    settings.yazi = {
      manager = {
        show_hidden = true;
      };
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.agave
    nerd-fonts.iosevka
  ];

  system.stateVersion = "25.05";
  }
