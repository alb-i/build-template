# Macos base dev environment

{
    description = "General build environment";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";

        sbt.url = "github:zaninime/sbt-derivation";
        sbt.inputs.nixpkgs.follows = "nixpkgs";
    };



    outputs = { 
        self, 
        nixpkgs, 
        sbt,
        }: {
        packages."aarch64-darwin".default = let 
                pkgs = nixpkgs.legacyPackages."aarch64-darwin";
        in pkgs.buildEnv {
            name = "home-packages";
            paths = with pkgs; [
                git
                sbt
            ];
        };
    };
}