{pkgs, ...}:
{
  systemd.services.nvidia-prime-busid = {
    description = "Detect Intel/NVIDIA PCI bus IDs for PRIME sync";
    wantedBy = [ "display-manager.service" ];
    before   = [ "display-manager.service" ];
    serviceConfig = { Type = "oneshot"; RemainAfterExit = true; };
    path = [ pkgs.pciutils pkgs.gawk ];
    script = ''
      set -eu
      out=/run/xorg-prime
      mkdir -p "$out"
  
      to_xorg() {                       # "01:00.0" -> "PCI:1:0:0"
        local b="''${1%%:*}" r="''${1#*:}"
        printf 'PCI:%d:%d:%d' "$((16#$b))" "$((16#''${r%%.*}))" "$((16#''${r#*.}))"
      }
  
      nvidia_bdf=$(lspci -d 10de:: -mm | awk '/"(VGA|3D|Display)/{print $1; exit}')
      igpu_bdf=$(lspci -mm | awk -F'"' '/VGA|3D|Display/ && (/Intel/||/AMD|ATI/){print}' \
                   | awk '{print $1; exit}')
  
      if [ -z "''${nvidia_bdf:-}" ] || [ -z "''${igpu_bdf:-}" ]; then
        echo "No hybrid NVIDIA+iGPU combo found; leaving stock config."
        : > "$out/10-prime-busid.conf"     # empty, harmless
        exit 0
      fi
  
      nv=$(to_xorg "$nvidia_bdf")
      ig=$(to_xorg "$igpu_bdf")
  
      cat > "$out/10-prime-busid.conf" <<EOF
      Section "ServerLayout"
          Identifier "layout"
          Screen 0 "iscreen"
          Inactive "nvidia"
          Option "AllowNVIDIAGPUScreens"
      EndSection
  
      Section "Device"
          Identifier "igpu"
          Driver "modesetting"
          BusID "$ig"
      EndSection
  
      Section "Screen"
          Identifier "iscreen"
          Device "igpu"
      EndSection
  
      Section "Device"
          Identifier "nvidia"
          Driver "nvidia"
          BusID "$nv"
          Option "AllowEmptyInitialConfiguration"
          Option "PrimaryGPU" "yes"
      EndSection
      EOF
      echo "Wrote PRIME sync config: iGPU=$ig NVIDIA=$nv"
    '';
  };
  services.xserver.displayManager.lightdm.extraConfig = ''
    [Seat:*]
    xserver-command = X -configdir /run/xorg-prime
  '';
}
