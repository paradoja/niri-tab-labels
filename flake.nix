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

        # Wrap system qmllint / qmlls6 so they always consult QML_IMPORT_PATH
        # (-E). Unlike most Qt tools, these two only read QML_IMPORT_PATH when
        # explicitly told to — so Emacs' LSP (qmlls6) would otherwise miss
        # qs.* imports even with the env var set in its process environment.
        # Pre-commit, manual invocations, and editor tooling all benefit.
        qmllint = pkgs.writeShellScriptBin "qmllint" ''
          exec /usr/lib/qt6/bin/qmllint -E "$@"
        '';
        qmlls6 = pkgs.writeShellScriptBin "qmlls6" ''
          exec /usr/bin/qmlls6 -E "$@"
        '';
        # Some LSP clients probe for the unsuffixed name first (including
        # Doom's qml-ls-portable in config.el), so expose qmlls as an alias
        # that points at the same wrapped system binary.
        qmlls = pkgs.writeShellScriptBin "qmlls" ''
          exec /usr/bin/qmlls6 -E "$@"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          # Qt6 / QML tooling is intentionally *not* pulled from nixpkgs.
          #
          # Noctalia's Quickshell fork (noctalia-qs, installed via paru) ships
          # its QML modules under /usr/lib/qt6/qml/Quickshell/ and its
          # .qmltypes are built against Arch's Qt6. A nix-provided qmlls /
          # qmllint from qt6.qtdeclarative doesn't see that directory and its
          # Qt version can drift from Arch's, producing a flood of bogus
          # "module not found" / "type is used but not resolved" warnings.
          #
          # Instead, the shellHook appends /usr/lib/qt6/bin to PATH so editor
          # tooling picks up the system qmlformat. qmllint and qmlls6 are the
          # exceptions: the wrappers above shadow the system binaries so -E is
          # always passed, hence the devShell packages win in PATH order.
          packages = [
            pkgs.nil
            pkgs.pre-commit
            qmllint
            qmlls6
            qmlls
          ];
          shellHook = ''
            export PATH="$PATH:/usr/lib/qt6/bin"
            # Synthesize qmldir stubs so qmllint / qmlls resolve qs.* imports
            # (see scripts/regen-qml-stubs)
            if [ -x "$PWD/scripts/regen-qml-stubs" ]; then
              "$PWD/scripts/regen-qml-stubs" || true
            fi
            export QML_IMPORT_PATH="$PWD/.qml-cache''${QML_IMPORT_PATH:+:$QML_IMPORT_PATH}"
          '';
        };
      }
    );
}
