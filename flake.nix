{
  description = "T3 Code nightly server, packaged for Nix";

  inputs = {
    # For wrapBuddy (see package.nix).
    llm-agents.url = "github:numtide/llm-agents.nix";
    nixpkgs.follows = "llm-agents/nixpkgs";
  };

  outputs =
    { nixpkgs, llm-agents, ... }:
    let
      system = "x86_64-linux";
      t3code-nightly = nixpkgs.legacyPackages.${system}.callPackage ./package.nix {
        inherit (llm-agents.packages.${system}) wrapBuddy;
      };
    in
    {
      packages.${system} = {
        inherit t3code-nightly;
        default = t3code-nightly;
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
