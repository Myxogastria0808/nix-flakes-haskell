{
  description = "haskell flake sample";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        ghcVersion = "ghc9103";
        haskellPackages = with pkgs.haskell.packages.${ghcVersion}; [
          ghc
          haskell-language-server
          implicit-hie
        ];
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            stack
            cabal-install
          ] ++ haskellPackages;
        };
      });
}
