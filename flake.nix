{
  inputs.nixpkgs.url = "nixpkgs/nixos-20.09";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        texliveEnv = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-medium csquotes changepage;
        };

        mkPackage = isShell:
          let
            devPackages = with pkgs;
              lib.optionals isShell [ nixfmt fd texstudio ];

          in pkgs.stdenv.mkDerivation {
            name = "cv";
            src = if isShell then null else self;

            installPhase = ''
              install -D build/letter.pdf $out/letter.pdf
            '';

            buildInputs = with pkgs;
              [ gnumake which texliveEnv ] ++ devPackages;
          };
      in {
        packages = { letter = mkPackage false; };
        devShell = mkPackage true;
      });
}
