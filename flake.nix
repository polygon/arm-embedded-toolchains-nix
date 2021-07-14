{
  description = "ARM embedded toolchains";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages.gcc-9-aarch64-none-linux = pkgs.callPackage ./gcc-aarch64-none-linux/9 { };
        packages.gcc-10-aarch64-none-linux = pkgs.callPackage ./gcc-aarch64-none-linux/10 { };
        packages.gcc-9-aarch64-none-elf = pkgs.callPackage ./gcc-aarch64-none-elf/9 { };
        packages.gcc-10-aarch64-none-elf = pkgs.callPackage ./gcc-aarch64-none-elf/10 { };
      }
    );
}
