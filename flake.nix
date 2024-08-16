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
      }: 
      let hpkgs = pkgs.haskell.packages.ghc910.override {
          overrides = self: super: {
            # wherefrom-compat = pkgs.haskell.lib.markUnbroken super.wherefrom-compat;
            hashable = super.hashable.override {os-string = null;};
            tar = super.tar_0_6_3_0.override {os-string = null;};
            # nothunks = pkgs.lib.pipe super.nothunks_0_2_1_0 [ pkgs.haskell.lib.doJailbreak pkgs.haskell.lib.dontCheck ];
            auto-update = super.auto-update_0_2_1;
            attoparsec-aeson = super.attoparsec-aeson_2_2_2_0;
            http2 = super.http2_5_2_6;
            integer-conversion = super.integer-conversion_0_1_1;
            quickcheck-instances = super.quickcheck-instances_0_3_31;
            scientific = super.scientific_0_3_8_0;
            th-abstraction = super.th-abstraction_0_7_0_0;
            time-compat = super.time-compat_1_9_7;
            time-manager = super.time-manager_0_1_0;
            tasty = super.tasty_1_5_1;
            uuid-types = super.uuid-types_1_0_6;
            #attoparsec-aeson = pkgs.haskell.lib.doJailbreak super.attoparsec-aeson;
            bitvec = pkgs.haskell.lib.doJailbreak super.bitvec;
            dejafu = pkgs.haskell.lib.doJailbreak super.dejafu;
            tasty-coverage = pkgs.haskell.lib.doJailbreak super.tasty-coverage;
            aeson = pkgs.lib.pipe super.aeson_2_2_3_0 [ pkgs.haskell.lib.doJailbreak pkgs.haskell.lib.dontCheck ];
            aeson-pretty = pkgs.haskell.lib.dontCheck (pkgs.haskell.lib.overrideCabal super.aeson-pretty (drv: {buildTarget = "lib:aeson-pretty";}));
            bsb-http-chunked = pkgs.haskell.lib.dontCheck super.bsb-http-chunked;
            # tasty dep
            call-stack = pkgs.haskell.lib.dontCheck super.call-stack;
            network-control = pkgs.haskell.lib.dontCheck super.network-control_0_1_1;
            primitive = pkgs.haskell.lib.dontCheck super.primitive_0_9_0_0;
            retry = pkgs.haskell.lib.dontCheck super.retry;
            tasty-discover = pkgs.haskell.lib.dontCheck super.tasty-discover;
            unordered-containers = pkgs.haskell.lib.dontCheck super.unordered-containers;
            warp = pkgs.haskell.lib.dontCheck super.warp_3_4_1;
          };
        }; in {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
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
        packages.default = hpkgs.callCabal2nix "network-quick-bread" ./. {};
        devShells.default = hpkgs.shellFor {
          packages = hhpkgs: [config.packages.default];
          withHoogle = true;
        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
