{ pkgs, ... }:

{
  boot = {
    kernelParams = [
      "threadirqs" 
    ];
  };
  services.udev.extraRules = ''
    DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
  '';
  environment.systemPackages = (with pkgs; [
    surge-XT
    x42-plugins
    tap-plugins
    ardour
    calf
    lsp-plugins
    hydrogen
    mod-arpeggiator-lv2
    distrho-ports
    #tutka-qt6
    yabridge
    yabridgectl
    sfizz
    x42-gmsynth
    fluidsynth
    cardinal
    qsampler
    zrythm
    reaper
    reaper-sws-extension
    reaper-reapack-extension
    openbox
  ]);
  
  #++
  
  #(with pkgs-stable; [
  #  distrho
  #]);

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "core"; type="soft"; value = "0"; } 
    { domain = "@audio"; item = "core"; type="hard"; value = "0"; }
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "9999999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "9999999"; }
  ];
}
