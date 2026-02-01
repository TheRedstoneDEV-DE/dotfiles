{ pkgs, ... }:
{
  environment.systemPackages = (with pkgs; [
    blender-hip
    godot_4
  ]);
}
