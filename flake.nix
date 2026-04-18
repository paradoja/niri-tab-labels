{
  description = "Niri Tab Labels — Noctalia plugin dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # QML tooling: qml, qmlls, qmllint, qmlformat, qmltestrunner
            qt6.qtbase
            qt6.qtdeclarative

            # lsps
            nil
          ];
        };
      }
    );
}
