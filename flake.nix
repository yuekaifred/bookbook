{
  description = "bookbook dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            ruby_4_0
            postgresql_16
            pkg-config
            openssl
            libyaml
            zlib
            readline
            vips
            imagemagick
            git
          ];

          shellHook = ''
            export BUNDLE_PATH="$PWD/vendor/bundle"
            export PATH="$PWD/vendor/bundle/bin:$PATH"

            # Help pg gem find libpq during native extension build
            export PKG_CONFIG_PATH="${pkgs.postgresql_16}/lib/pkgconfig:$PKG_CONFIG_PATH"
            export LIBRARY_PATH="${pkgs.postgresql_16}/lib:$LIBRARY_PATH"
          '';
        };
      }
    );
}
