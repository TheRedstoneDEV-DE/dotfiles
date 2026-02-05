{ config, pkgs, ... }:

{
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        #CPU_SCALING_MIN_FREQ_ON_AC=0;
        #CPU_SCALING_MAX_FREQ_ON_AC=9999999;
        #CPU_SCALING_MIN_FREQ_ON_BAT=0;
        #CPU_SCALING_MAX_FREQ_ON_BAT=800;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 60; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
  };
}
