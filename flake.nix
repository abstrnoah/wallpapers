{
  description = "a collection of wallpapers";

  inputs.dotfiles.url = "github:abstrnoah/dotfiles/c801d944cd89bbf4b210891e1eb2c4e01761ecc3";

  outputs =
    inputs@{ dotfiles, ... }:
    {
      packages =
        with dotfiles.lib.agnostic;
        let
          # Should support literally any system but yknow,,, flakes.
          supported_systems = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
          paths = list_dir ./wallpapers;
          path_to_name =
            path: builtins.replaceStrings [ "." ] [ "_" ] (baseNameOf path);
        in
        for_all supported_systems
        (system:
        builtins.listToAttrs
        (map
        (path: {
          name = path_to_name path;
          value = dotfiles.lib.${system}.store_file (./wallpapers + "/${path}") "";
        })
        paths));
    };
}
