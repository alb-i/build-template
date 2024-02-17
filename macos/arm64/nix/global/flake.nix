# global flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    unstable.url = "nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv/latest";

    # rust, see https://github.com/nix-community/fenix#usage
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = { self, nixpkgs, unstable, devenv, fenix }: {
    packages."aarch64-darwin".default = let
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      unstablePkgs = unstable.legacyPackages."aarch64-darwin";
      
      # see https://github.com/Mic92/nixos-wiki-test/blob/196aa6c3463bf52128d3ffb07218d0999b2ca617/PHP.md?plain=1#L38
      php-vips = pkgs.php81.buildPecl {
        pname = "vips";
        version = "1.0.13";
        sha256 = "TmVYQ+XugVDJJ8EIU9+g0qO5JLwkU+2PteWiqQ5ob48=";
        buildInputs = [ pkgs.vips pkgs.pkg-config ];
      };
      php81 = pkgs.php81.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
            xdebug
            opcache
            redis
            php-vips
        ]));
        extraConfig = "memory_limit = 2G";
      };
    in pkgs.buildEnv {
      name = "home-packages";
      paths = with pkgs; [

        # general tools
        git
        bitwarden-cli
        ffmpeg
        gnupg
        curl
        wget
        jq
        gnused
        ripgrep
        tmux
        pandoc

        # dev tools
        devenv.packages.aarch64-darwin.devenv
        #mitmproxy
        cfssl
        dive
        graphviz
        lnav # log file nav
        watchman
        vector
        kubectl
        httpie
        certstrap
        lima
        caddy
        mutagen
        mutagen-compose
        upx
        age
        dbmate
        gomplate
        jwt-cli
        ipcalc
        ncdu
        inetutils # telnet

        # infrastructure
        ansible
        k3d
        k9s
        natscli
        nats-server
        redis
        trivy


        # programming environments
        deno
        nodejs
        yarn
        php81
        symfony-cli
        fenix.packages."aarch64-darwin".minimal.toolchain # rust
        jdk17
        
        # go
        go
        unstablePkgs.goreleaser
        protobuf # TODO remove
        protoc-gen-go # TODO remove
        protoc-gen-go-grpc # TODO remove
        golangci-lint # TODO remove
        buf # TODO remove
        gum # TODO REMOVE


        #mariadb
        #postgresql
        
        
        # to remove
        awscli
        google-cloud-sdk
        platformio
        arduino-cli
        openfortivpn
        hcloud

        pgcli
    
        # mobile dev
        # TODO Flutter does not work
        cocoapods
        fastlane
        
      ];
    };
  };

}
