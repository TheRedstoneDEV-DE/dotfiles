{ pkgs, ...}:
let
  # Create a GHC environment with tidal included
  ghcWithTidal = pkgs.haskellPackages.ghcWithPackages (pkgs: [
    pkgs.tidal
  ]);
in {
 environment.systemPackages = with pkgs; [
    supercollider
    ghcWithTidal
 ];
}
