# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda3";
      preLVM = true;
    }
  ];
  boot.loader.grub.device = "/dev/sda";
  #networking.wireless.enable = true;
  networking.hostName = "dolores";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "208.67.222.222" "208.67.220.220" ];

  nix.extraOptions = "binary-caches-parallel-connections = 5";

  nix.binaryCaches = [ "https://cache.nixos.org/" "https://nixcache.reflex-frp.org" ];
  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget sublime htop tree keepassx2 curl emacs openssl which stack ghc git
    gnumake acpi google-chrome];

  # List services that you want to enable:

  hardware.bluetooth.enable = false;
  hardware.trackpoint.emulateWheel = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager.gnome3.enable = true;
    displayManager.gdm.enable = true;
  };

  i18n.consoleFont = "Lat2-Terminus16";
  i18n.consoleKeyMap = "us";

  programs.bash.shellAliases = {
    wtf = "git status"; wow = "git commit -a";
    gitrekt = "git push origin master";
    gitbent = "git pull origin master";
    ls = "ls --color --group-directories-first";
    such = "git";
    batty = "acpi";
  };

  services.redshift = { enable = true; } //
    { latitude = "30.2672"; longitude = "-97.7431"; } # austin
    #{ latitude = "43.6187"; longitude = "116.2146"; } # boise
    #{ latitude = "33.784190"; longitude = "-84.374263"; } # atlanta
    #{ latitude = "38.062373"; longitude = "-84.50178"; } # lexington
    #{ latitude = "37.56"; longitude = "-122.33"; } # san mateo
    ;

  # time.timeZone = "America/Chicago"; # Central
  time.timeZone = "America/New_York"; # Eastern
  # time.timeZone = "America/Denver"; # Mountain
  # time.timeZone = "Europe/Zurich";

  services.xserver.multitouch.invertScroll = false;

  fonts = {
    enableFontDir          = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts inconsolata lato symbola ubuntu_font_family
      fira-code monoid unifont vistafonts
    ];
  };


    nixpkgs.config = {
      allowUnfree = true;
    };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users.users.julie = {
    name = "julie";
    group = "users";
    extraGroups = ["wheel" "disk" "audio" "video" "networkmanager" "systemd-journal"];
    isNormalUser = true;
    uid = 1000;
    createHome = true;
    home = "/home/julie";
  };

  users.users.chris = {
    name = "chris";
    isNormalUser = true;
    extraGroups = ["wheel"];
    uid = 1001;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";

}
