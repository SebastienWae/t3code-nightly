{
  description = "T3 Code nightly server, packaged for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # For wrapBuddy (see package.nix), built below with the same nixpkgs as
    # the package: its loader starts the binary with that nixpkgs' ld.so,
    # which must come from the same glibc as the libc the binary finds.
    wrap-buddy = {
      url = "github:Mic92/wrap-buddy";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, wrap-buddy, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      t3code-nightly = pkgs.callPackage ./package.nix {
        wrapBuddy = pkgs.callPackage "${wrap-buddy}/nix/package.nix" { sources = "${wrap-buddy}"; };
      };
    in
    {
      packages.${system} = {
        inherit t3code-nightly;
        default = t3code-nightly;
      };

      formatter.${system} = pkgs.nixfmt-tree;
    };
}
