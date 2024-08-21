{
  description = "Network Quick Bread development flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    haskell-flake.url = "github:srid/haskell-flake";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.pre-commit-hooks-nix.flakeModule
        inputs.haskell-flake.flakeModule
        inputs.devshell.flakeModule
      ];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        hpkgs = pkgs.haskell.packages.ghc910.override {
          overrides = self: super: {
            ## os-string
            hashable = super.hashable.override {os-string = null;};
            tar = super.tar_0_6_3_0.override {os-string = null;};
            ## Cabal-syntax
            #hackage-security = super.hackage-security.override {Cabal-syntax = null;};
            #cabal-install = super.cabal-install.override {Cabal-syntax = null;};
            #Cabal = super.Cabal.override {Cabal-syntax = null;};
            #
            ## version changes
            #
            auto-update = super.auto-update_0_2_1;
            attoparsec-aeson = super.attoparsec-aeson_2_2_2_0;
            base64 = super.base64_1_0;
            Cabal = super.Cabal_3_12_1_0;
            Cabal-syntax = super.Cabal-syntax_3_12_1_0;
            commutative-semigroups = super.commutative-semigroups_0_2_0_1;
            fourmolu = super.fourmolu_0_16_2_0;
            ghc-lib-parser = super.ghc-lib-parser_9_10_1_20240511;
            ghc-lib-parser-ex = super.ghc-lib-parser-ex_9_10_0_0;
            http2 = super.http2_5_2_6;
            integer-conversion = super.integer-conversion_0_1_1;
            lens = super.lens_5_3_2;
            lukko = super.lukko_0_1_2;
            ormolu = super.ormolu_0_7_7_0;
            quickcheck-instances = super.quickcheck-instances_0_3_31;
            scientific = super.scientific_0_3_8_0;
            th-abstraction = super.th-abstraction_0_7_0_0;
            time-compat = super.time-compat_1_9_7;
            time-manager = super.time-manager_0_1_0;
            tasty = super.tasty_1_5_1;
            uuid-types = super.uuid-types_1_0_6;
            #
            ## Jailbreaks
            #
            cabal-install-solver = pkgs.haskell.lib.doJailbreak super.cabal-install-solver;
            bitvec = pkgs.haskell.lib.doJailbreak super.bitvec;
            dejafu = pkgs.haskell.lib.doJailbreak super.dejafu;
            floskell = pkgs.haskell.lib.doJailbreak super.floskell;
            lucid = pkgs.haskell.lib.doJailbreak super.lucid;
            resolv = pkgs.haskell.lib.doJailbreak super.resolv;
            socket = pkgs.haskell.lib.doJailbreak super.socket;
            tasty-coverage = pkgs.haskell.lib.doJailbreak super.tasty-coverage;
            tree-diff = pkgs.haskell.lib.doJailbreak super.tree-diff;
            #
            ## turning off tests
            #
            #
            aeson = pkgs.lib.pipe super.aeson_2_2_3_0 [pkgs.haskell.lib.doJailbreak pkgs.haskell.lib.dontCheck];
            #
            aeson-pretty = pkgs.haskell.lib.dontCheck (pkgs.haskell.lib.overrideCabal super.aeson-pretty (drv: {buildTarget = "lib:aeson-pretty";}));
            #
            bsb-http-chunked = pkgs.haskell.lib.dontCheck super.bsb-http-chunked;
            #
            call-stack = pkgs.haskell.lib.dontCheck super.call-stack;
            # rebase
            deferred-folds = pkgs.haskell.lib.dontCheck super.deferred-folds;
            #
            extensions = pkgs.haskell.lib.dontCheck super.extensions_0_1_0_2;
            # rebase
            focus = pkgs.haskell.lib.dontCheck super.focus;
            #
            hinotify = pkgs.haskell.lib.dontCheck super.hinotify;
            #
            hw-fingertree = pkgs.haskell.lib.dontCheck super.hw-fingertree;
            #
            hw-prim = pkgs.haskell.lib.dontCheck super.hw-prim;
            #
            list-t = pkgs.haskell.lib.dontCheck super.list-t;
            #
            network-control = pkgs.haskell.lib.dontCheck super.network-control_0_1_1;
            # rebase
            neat-interpolation = pkgs.haskell.lib.dontCheck super.neat-interpolation;
            #
            primitive = pkgs.haskell.lib.dontCheck super.primitive_0_9_0_0;
            # rebase
            primitive-extras = pkgs.haskell.lib.dontCheck super.primitive-extras;
            #
            primitive-unlifted = pkgs.haskell.lib.dontCheck super.primitive-unlifted;
            #
            relude = pkgs.haskell.lib.dontCheck super.relude;
            #
            retry = pkgs.haskell.lib.dontCheck super.retry;
            #
            stan = pkgs.haskell.lib.dontCheck super.stan;
            # rebase
            stm-containers = pkgs.haskell.lib.dontCheck super.stm-containers;
            # rebase
            stm-hamt = pkgs.haskell.lib.dontCheck super.stm-hamt;
            #
            slist = pkgs.haskell.lib.dontCheck super.slist;
            #
            tasty-discover = pkgs.haskell.lib.dontCheck super.tasty-discover;
            #
            tomland = pkgs.haskell.lib.dontCheck super.tomland;
            #
            trial = pkgs.haskell.lib.dontCheck super.trial;
            #
            unordered-containers = pkgs.haskell.lib.dontCheck super.unordered-containers;
            #
            validation-selective = pkgs.haskell.lib.dontCheck super.validation-selective;
            #
            warp = pkgs.haskell.lib.dontCheck super.warp_3_4_1;
            #
            ## adding dependencies
            #
            ghc-exactprint = super.callHackageDirect {
              pkg = "ghc-exactprint";
              ver = "1.9.0.0";
              sha256 = "sha256-f+ctUR/h7+S/97ppOxa30GH98v5kw34AyURlt9A0z/U=";
            } {};
          };
        };
      in {
        treefmt.programs = {
          alejandra.enable = true;
          cabal-fmt.enable = true;
          ormolu = {
            enable = true;
            package = pkgs.haskellPackages.fourmolu;
          };
        };
        treefmt.projectRootFile = "flake.nix";
        pre-commit.settings = {
          hooks = {
            treefmt.enable = true;
            commitizen.enable = true;
            editorconfig-checker.enable = true;
            typos = {
              enable = true;
              settings = {
                ignored-words = ["wheres"];
              };
            };
          };
        };
        packages.default =
          pkgs.lib.pipe (hpkgs.callCabal2nix "network-quick-bread" ./. {})
          [
            #(drv: pkgs.haskell.lib.addBuildTools drv [hpkgs.tasty-autocollect])
            (drv: pkgs.haskell.lib.addBuildDepends drv (with hpkgs; [socket network]))
          ];
        devShells.default = hpkgs.shellFor {
          packages = hhpkgs: [config.packages.default];
          nativeBuildInputs = [
            hpkgs.haskell-debug-adapter
            hpkgs.cabal-install
            (
              pkgs.lib.pipe (hpkgs.haskell-language-server.override {
                apply-refact = null;
                retrie = null;
                hlint = null;
                stylish-haskell = null;
              })
              (with pkgs.haskell.lib; [
                (drv: disableCabalFlag drv "retrie")
                (drv: disableCabalFlag drv "hlint")
                (drv: disableCabalFlag drv "stylish-haskell")
              ])
            )
          ];
          withHoogle = true;
          shellHook = config.pre-commit.installationScript;
        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
