{

  description = "A collection of wallpapers";

  inputs.dotfiles.url = "github:abstrnoah/dotfiles";
  inputs.dotfiles.inputs.wallpapers.follows = "";

  inputs.systems.follows = "dotfiles/systems";

  inputs.flake-utils.follows = "dotfiles/flake-utils";

  outputs = inputs@{ dotfiles, flake-utils, ... }:
    let
      cons = { metadata, store-symlink, store-symlinks }:
        let
          mimetype-to-extension = {
            "image/jpeg" = "jpg";
            "image/png" = "png";
          };
          fullname = w@{ name, mimetype, ... }:
            "wallpaper-${name}.${mimetype-to-extension.${mimetype}}";
          # TODO Maybe just cp instead of symlink?
          cons-wallpaper = wallpaper-info@{ name, mimetype, src, ... }:
            let out = fullname wallpaper-info;
            in (store-symlink out src "").overrideAttrs (prev: {
              passthru = prev.passthru or { } // { inherit wallpaper-info; };
            });
          default = store-symlinks {
            name = "wallpapers";
            mapping = map (w: {
              source = w.src;
              destination = "/${fullname w}";
            }) (builtins.attrValues metadata);

          };
          packages = builtins.mapAttrs (_: cons-wallpaper) metadata;
        in {
          packages = packages // { inherit default; };
          inherit metadata;
        };
    in flake-utils.lib.eachDefaultSystem (system:
      cons {
        inherit (dotfiles.config.${system}) store-symlink store-symlinks;
        metadata = import ./.;
      });

}
