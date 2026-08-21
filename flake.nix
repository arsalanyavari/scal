{
  description = "Rust implementation of the classic jcal utilities";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        manifest = (pkgs.lib.importTOML ./Cargo.toml).package;
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "scal";
          version = manifest.version;
          src = pkgs.lib.cleanSource ./.;
          cargoLock.lockFile = ./Cargo.lock;

          doCheck = false;

          postInstall = ''
            install -Dm644 man/scal.1.roff $out/share/man/man1/scal.1
            install -Dm644 man/sdate.1.roff $out/share/man/man1/sdate.1
            install -Dm644 man/sstat.1.roff $out/share/man/man1/sstat.1
            install -Dm644 man/slib.3.roff $out/share/man/man3/slib.3
          '';

          meta = with pkgs.lib; {
            description = "Rust implementation of the classic jcal utilities";
            homepage = "https://github.com/arsalanyavari/scal";
            license = licenses.lgpl3;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cargo
            rustc
            rustfmt
            clippy
          ];
        };
      }
    );
}
