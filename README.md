# nix-flakes-haskell

## Setup

0. set `flake.nix` and `.envrc`

- flake.nix

```nix
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
        haskellPackages = with pkgs.haskell.packages.ghc9102; [
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
```

- .envrc

```
use flake
```

1. setup devShell

```sh
direnv allow
```

2. set `.vscode/settings.json`

`"haskell.manageHLS": "PATH",` is the most important setting.

```json
{
  "[haskell]": {
    "editor.defaultFormatter": "haskell.haskell",
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true
  },
  "haskell.manageHLS": "PATH",
  "haskell.plugin.semanticTokens.globalOn": true,
  "nixEnvSelector.nixFile": "${workspaceFolder}/flake.nix"
}
```

3. create a stack project

```sh
stack new <package-name> simple --bare
```

4. update `.gitignore`

```
# Nix
/.direnv

# Haskell
.stack-work/
*~
```

5. generate `hie.yaml`

> [!WARNING]
> Be aware that the project name in the generated hie.yaml file may sometimes be incorrect.

```sh
gen-hie > hie.yaml
```

- correct `hie.yaml`

```yaml
cradle:
  stack:
    - path: "./src/Main.hs"
      component: "<project-name>:exe:<package-name>"
```

## Build and Exec

`stack exec` command require `<package-name>-exe`.

```sh
stack build
stack exec <package-name>-exe
```

## Run

`stack exec` command require `<package-name>-exe`.

```sh
stack run <project-name>:exe:<package-name>-exe
```

## Test

```sh
stack test
```
