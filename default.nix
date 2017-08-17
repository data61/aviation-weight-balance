{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  sources = {
    papa = pkgs.fetchFromGitHub {
      owner = "qfpl";
      repo = "papa";
      rev = "97ef00aa45c70213a4f0ce348a2208e3f482a7e3";
      sha256 = "0qm0ay49wc0frxs6ipc10xyjj654b0wgk0b1hzm79qdlfp2yq0n5";
    };

    aviation-units = pkgs.fetchFromGitHub {
      owner = "data61";
      repo = "aviation-units";
      rev = "c67a8ed7af0218316a308abbbfa804b896319956";
      sha256 = "0jhhc4q2p7kg07bl7hk0571rp8k5qg02mgnfy0cm51hj5fd2lihx";
    };
  };

  modifiedHaskellPackages = haskellPackages.override {
    overrides = self: super: import sources.papa self // {
      aviation-units = import sources.aviation-units {};
      parsers = pkgs.haskell.lib.dontCheck super.parsers;        
    };
  };

  aviation-weight-balance = modifiedHaskellPackages.callPackage ./aviation-weight-balance.nix {};

in

  aviation-weight-balance

