{
  description = "a collection of wallpapers";

  inputs.dotfiles.url = "github:abstrnoah/dotfiles/ecd8de5c692066ac9018f9cd4b18295b14e027d8";

  outputs =
    inputs@{ dotfiles, ... }:
    {
      packages =
        with dotfiles.lib.agnostic;
        let
          # Should support literally any system but yknow,,, flakes.
          supported_systems = dotfiles.lib.agnostic.supported_systems;
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
