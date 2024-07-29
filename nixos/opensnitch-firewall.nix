{ config, pkgs, lib, ... }:

{
  services.opensnitch = {
    enable = true;
    rules = {
      systemd-timesyncd = {
        name = "systemd-timesyncd";
        enabled = true;
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
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          data = "[{\"type\": \"simple\", \"operand\": \"process.path\", \"data\": \"${lib.getBin pkgs.supersonic-wayland}/bin/supersonic-wayland\", \"sensitive\": false}, {\"type\": \"network\", \"operand\": \"dest.network\", \"data\": \"192.168.0.0/24\", \"sensitive\": false}]";
          list = [
            {
              type = "simple";
              operand = "process.path";
              sensitive = false;
              list = null;
              data = "${lib.getBin pkgs.supersonic-wayland}/bin/supersonic-wayland";
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
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          data = "[{\"type\": \"simple\", \"operand\": \"process.path\", \"data\": \"${lib.getBin pkgs.openssh }/bin/ssh\", \"sensitive\": false}, {\"type\": \"simple\", \"operand\": \"dest.port\", \"data\": \"22\", \"sensitive\": false}, {\"type\": \"network\", \"operand\": \"dest.network\", \"data\": \"192.168.0.0/24\", \"sensitive\": false}]";
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
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          data = "[{\"type\": \"simple\", \"operand\": \"process.path\", \"data\": \"${lib.getBin pkgs.curl }/bin/curl\", \"sensitive\": false}, {\"type\": \"network\", \"operand\": \"dest.network\", \"data\": \"192.168.0.0/24\", \"sensitive\": false}]";
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
        action = "allow";
        duration = "always";
        operator = {
          type = "regexp";
          sensitive = false;
          operand = "dest.host";
          data = "[A-Za-z]+\.nixos\.org";
        };
      };
    };
  };
}
