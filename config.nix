{ config, lib, pkgs, ... }:

{

  imports =
    [
      ./hardware-configuration.nix
      ./minecraft-server.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ ];
  
  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.kyd0 = {
    isNormalUser = true;
    description = "Denys";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      git
      qutebrowser
      htop
      rofi
      alacritty
      python3
      polybar
      bspwm
      sxhkd
      ranger
      fastfetch
      feh
      libnotify
      wget
      kotatogram-desktop
      bibata-cursors
      libreoffice
      scrot
      maim
      slop
      unzip
      obs-studio
      ffmpeg
      shotcut
      taterclient-ddnet
      flatpak
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.intel-media-driver
      pkgs.vulkan-tools
    ];
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = lib.mkForce true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; 
  };

  services.zerotierone.enable = true;
  services.xserver = {
    enable = true;

    libinput = {
      enable = true;

      mouse = {
        accelProfile = "flat";
	accelSpeed = "0.0";
      };
    };

    windowManager.bspwm.enable = true;
    
    displayManager.lightdm.enable = true;
    displayManager.lightdm.greeters.gtk.enable = true;
  };

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };
  
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "discord" ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      bs = "sudo nvim /home/kyd0/.config/bspwm/bspwmrc";
      sx = "sudo nvim /home/kyd0/.config/sxhkd/sxhkdrc";
      nx = "sudo nvim /etc/nixos/configuration.nix";
      rb = "sudo nixos-rebuild switch";
      ms = "sudo nvim /etc/nixos/minecraft-server.nix";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
 
  environment.systemPackages = with pkgs; [
    bspwm
    sxhkd
    polybar
    rofi
    python3
    vim
    feh
    ranger
    wget
    flatpak-builder
    curl
    jdk21_headless
    discord
    xorg.xinit
    xorg.xrandr
    xorg.xsetroot
    xclip
  ];

  fonts.packages = with pkgs; [
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.noto-fonts-color-emoji
    pkgs.font-awesome
    pkgs.nerd-fonts.jetbrains-mono
  ];
  
  services.tlp.enable = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  system.stateVersion = "25.11";
}
