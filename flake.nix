{

  description = "A collection of wallpapers";

  inputs.dotfiles.url = "github:abstrnoah/dotfiles";
  inputs.dotfiles.inputs.wallpapers.follows = "";

  inputs.systems.follows = "dotfiles/systems";

  inputs.flake-utils.follows = "dotfiles/flake-utils";

  outputs = inputs@{ dotfiles, flake-utils, ... }:
    let
      cons = { metadata, store-symlink, bundle }:
        let
          mimetype-to-extension = {
            "image/jpeg" = "jpg";
            "image/png" = "png";
          };
          cons-wallpaper = wallpaper-info@{ name, mimetype, src, ... }:
            let extension = mimetype-to-extension.${mimetype};
            in (store-symlink "wallpaper-${name}.${extension}" src
              "").overrideAttrs (prev: {
                passthru = prev.passthru or { } // { inherit wallpaper-info; };
              });
          default = bundle {
            name = "wallpapers";
            inherit packages;
          };
          packages = builtins.mapAttrs (_: cons-wallpaper) metadata;
        in {
          packages = packages // { inherit default; };
          inherit metadata;
        };
    in flake-utils.lib.eachDefaultSystem (system:
      cons {
        inherit (dotfiles.config.${system}) store-symlink bundle;
        metadata = import ./.;
      });

}
