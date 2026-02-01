{ pkgs, lib, ... }:

{
  environment.systemPackages = (with pkgs; [
    opensnitch-ui
  ]);
  services.opensnitch = {
    enable = true;
    rules = {
      systemd-timesyncd = {
        name = "systemd-timesyncd";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
        };
      };
      systemd-resolved = {
        name = "systemd-resolved";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-resolved";
        };
      };
      blender = {
        name = "blender-update check";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          data =  "[{\"type\": \"simple\", \"operand\": \"process.path\", \"data\": \"${lib.getBin pkgs.blender}/bin/blender\", \"sensitive\": false}, {\"type\": \"simple\", \"operand\": \"dest.host\", \"data\": \"api.github.com\", \"sensitive\": false}]";
          list = [
            {
              type = "simple";
              operand = "process.path";
              data = "${lib.getBin pkgs.blender}/bin/blender";
              sensitive = false;
              list = null;
            }
            {
              type = "simple";
              operand = "dest.host";
              data = "api.github.com";
              sensitive = false;
              list = null;
            }
          ];
        };
      };
      allow-supersonic = {
        name = "allow-supersonic";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          data = "[{\"type\": \"simple\", \"operand\": \"process.path\", \"data\": \"${lib.getBin pkgs.feishin}/bin/feishin\", \"sensitive\": false}, {\"type\": \"network\", \"operand\": \"dest.network\", \"data\": \"192.168.0.0/24\", \"sensitive\": false}]";
          list = [
            {
              type = "simple";
              operand = "process.path";
              sensitive = false;
              list = null;
              data = "${lib.getBin pkgs.feishin}/bin/feishin";
            }
            {
              type = "network";
              operand = "dest.network";
              data = "192.168.0.0/24";
              sensitive = false;
              list = null;
            }
          ];
        };
      };
      sshfs = {
        name = "allow-sshfs";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          data = "[{\"type\": \"simple\", \"operand\": \"process.path\", \"data\": \"${lib.getBin pkgs.openssh}/bin/ssh\", \"sensitive\": false}, {\"type\": \"simple\", \"operand\": \"dest.port\", \"data\": \"22\", \"sensitive\": false}, {\"type\": \"network\", \"operand\": \"dest.network\", \"data\": \"192.168.0.0/24\", \"sensitive\": false}]";
         list = [
            {
              type = "simple";
              operand = "process.path";
              sensitive = false;
              list = null;
              data = "${lib.getBin pkgs.openssh}/bin/ssh";
            }
            {
              type = "simple";
              operand = "dest.port";
              data = "22";
              sensitive = false;
              list = null;
            }
            {
              type = "network";
              operand = "dest.network";
              data = "192.168.0.0/24";
              sensitive = false;
              list = null;
            }
          ];
        };
      };
      curl = {
        name = "allow-curl";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          data = "[{\"type\": \"simple\", \"operand\": \"process.path\", \"data\": \"${lib.getBin pkgs.curl}/bin/curl\", \"sensitive\": false}, {\"type\": \"network\", \"operand\": \"dest.network\", \"data\": \"192.168.0.0/24\", \"sensitive\": false}]";
          list = [
            {
              type = "simple";
              operand = "process.path";
              sensitive = false;
              list = null;
              data = "${lib.getBin pkgs.curl}/bin/curl";
            }
            {
                type = "network";
              operand = "dest.network";
              data = "192.168.0.0/24";
              sensitive = false;
              list = null;
            }
          ];
        };
      };
      syncthing = {
        name = "allow syncthing";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.syncthing}/bin/syncthing";
        };
      };
      nixos-updates = {
        name = "allow nixos.org";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "regexp";
          sensitive = false;
          operand = "dest.host";
          data = "[A-Za-z]+\\.nixos\\.org";
        };
      };
      local-cache = {
        name = "local nixos cache";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "dest.host";
          data = "archives.citadel.space";
        };
      };
      pipewire-rtp = {
        name = "pipewire-rtp";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            {
              type = "simple";
              operand = "dest.port";
              sensitive = false;
              data = "10001";
            }
            {
              type = "network";
              operand = "dest.network";
              data = "192.168.0.0/24";
              sensitive = false;
            }
          ];
        };
      };
      nsncd = {
        name = "nsncd";
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          operand = "process.path";
          data = "${lib.getBin pkgs.nsncd}/bin/nsncd";
        };
      };
      librewolf = {
        name = "librewolf";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          operand = "process.path";
          data = "${lib.getBin pkgs.librewolf}/lib/librewolf/librewolf";
        };
      };
      avahi-daemon = {
        name = "avahi-daemon";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          operand = "process.path";
          data = "${lib.getBin pkgs.avahi}/bin/avahi-daemon";
        };
      };
      discord = {
        name = "allow discord";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "regexp";
          operand = "dest.host";
          sensitive = false;
          data = "^([a-z0-9-]+\\.)?(discord(app)?\\.com|discord\\.gg|vencord\\.dev)$";
        };
      };
      steam = {
        name = "allow steam client";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            {
              type = "regexp";
              operand = "process.path";
              sensitive = false;
              data = ".*/steam$"; # Matches any path ending in /steam
            }
            {
              type = "regexp";
              operand = "dest.host";
              sensitive = false;
              data = "^([a-z0-9-]+\\.)*(steampowered\\.com|steamcommunity\\.com|steamstatic\\.com|steamcontent\\.com|steamusercontent\\.com|steam-chat\\.com|steamserver\\.net)$";
            }
          ];
        };
      };      
      heroic = {
        name = "allow heroic launcher";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            {
              type = "regexp";
              operand = "process.path";
              sensitive = false;
              data = ".*(heroic|HeroicGamesLauncher|Heroic.*\\.AppImage|com\\.heroicgameslauncher\\.hgl|electron|chrome-sandbox)$";
            }
            {
              type = "regexp";
              operand = "dest.host";
              sensitive = false;
              data = "^([a-z0-9-]+\\.)*(heroicgameslauncher\\.com|epicgames\\.com|unrealengine\\.com|gog\\.com|gog-statics\\.com|amazon\\.com|s3\\.amazonaws\\.com|cdn\\.epicgames\\.com|cdn\\.gog\\.com|cdn\\.amazon\\.com|localhost|127\\.0\\.0\\.1|::1)$";
            }
          ];
        };
      };
      electron-localhost = {
        name = "allow electron localhost (heroic)";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "regexp";
          operand = "process.path";
          sensitive = false;
          data = "^\\/nix\\/store\\/.*\\/electron.*$";
        };
      };
      allow-localhost = {
        name = "allow localhost";
        enabled = true;
        created = "2026-02-01T10:37:54Z";
        updated = "2026-02-01T10:37:54Z";
        action = "allow";
        duration = "always";
        operator = {
          type = "regexp";
          operand = "dest.ip";
          sensitive = false;
          data = "^(?:(127.\\d{1,3}.\\d{1,3}.\\d{1,3}|::1)(?::\\d+)?)$";
        };
      };
    };
  };
}
