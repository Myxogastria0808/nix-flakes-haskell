# Haskell Tutorial

## Setup

0. set `flake.nix` and `.envrc`

- flake.nix

```nix
{
  description = "haskell-mytutorial";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            stack
            ghc
            haskell-language-server
          ];
        };
      }
    );
}
```

- .envrc

```
use flake
```

1. push the diff

```sh
git add .
git commit -m "setup haskell dev environment"
git push origin main
```

2. setup devShell

```sh
direnv allow
```

3. set `.vscode/settings.json`

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

4. create a stack project

```sh
stack new <project-name>
```

5. set `.gitignore`

```
# Nix
/.direnv

# Haskell
.stack-work/
*~

```

## Build and Exec

`stack exec` command require `<project-name>-exe`.

```sh
cd <project-name>
stack build
stack exec <project-name>-exe
```

## Test

```sh
cd <project-name>
stack test
```
