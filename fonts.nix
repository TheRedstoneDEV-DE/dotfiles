{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    # nerd-fonts.jetbrains-mono  --  Just needed for unstable - not yet for stable
    # nerd-fonts.hack
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    jetbrains-mono
    hack-font
  ];
}
