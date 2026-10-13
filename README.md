# t3code-nightly

[T3 Code](https://github.com/pingdotgg/t3code) nightly server (`t3`) for Nix,
x86_64-linux, from upstream's prebuilt Linux archive.

An hourly GitHub Action pins the newest nightly in `source.json` (with
upstream's checksum). Every commit here is one nightly version.

```nix
# flake.nix
inputs.t3code-nightly.url = "github:SebastienWae/t3code-nightly";
# Stay on one version: use the commit of that version instead.
# inputs.t3code-nightly.url = "github:SebastienWae/t3code-nightly/<commit>";

# then: inputs.t3code-nightly.packages.x86_64-linux.default
```

`nix flake update t3code-nightly` moves to the newest nightly.

To build it with your own nixpkgs instead of the pinned one (wrapBuddy is
built with it too):

```nix
inputs.t3code-nightly.inputs.nixpkgs.follows = "nixpkgs";
```
