{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader – systemd-boot + EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Strefa czasowa i ustawienia regionalne (polskie formaty)
  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS      = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT  = "pl_PL.UTF-8";
    LC_MONETARY     = "pl_PL.UTF-8";
    LC_NAME         = "pl_PL.UTF-8";
    LC_NUMERIC      = "pl_PL.UTF-8";
    LC_PAPER        = "pl_PL.UTF-8";
    LC_TELEPHONE    = "pl_PL.UTF-8";
    LC_TIME         = "pl_PL.UTF-8";
  };

  # X11 + GNOME
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Eksperymentalne funkcje skalowania w GNOME (Wayland + XWayland)
  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.mutter]
    experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
  '';

  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  console.keyMap = "pl2";

  # Drukowanie
  services.printing.enable = true;

  # Dźwięk – PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # NVIDIA – sterownik beta + open kernel modules
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };

  # Użytkownik
  users.users.themis = {
    isNormalUser = true;
    description = "themis";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # thunderbird
    ];
  };

  # Firefox systemowo
  programs.firefox.enable = true;

  # Steam + otwarcie portów dla remote play / dedykowanego serwera
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Pozwalamy na pakiety unfree (nvidia, steam, brave itp.)
  nixpkgs.config.allowUnfree = true;

  # Najważniejsze programy systemowe
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.hide-top-bar
    gnomeExtensions.vitals
    gnomeExtensions.user-themes
    gnome-shell
    haruna
    ffmpeg
    ffmpegthumbnailer
    yt-dlp
    brave
    upscayl
    gallery-dl
    onlyoffice-desktopeditors
    qbittorrent
    fastfetch
  ];

  # Wersja stanu systemu – nie zmieniać bez przeczytania dokumentacji!
  system.stateVersion = "25.11";
}
