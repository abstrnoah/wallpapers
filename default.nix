let
  cons-metadata = spec@{ sha256, ... }:
    spec // {
      src = ./store + "/${sha256}";
    };

in builtins.mapAttrs (_: cons-metadata) {

  mount-fuji-jpg = {
    name = "mount-fuji";
    mimetype = "image/jpeg";
    sha256 = "132d9a34db0e1cd79435eeee52da1ef09fc7083beaf85bbed2a9788d2f25ef55";
  };

  rivendell-png = {
    name = "rivendell";
    mimetype = "image/png";
    sha256 = "a13b5f146749e5be3d261d6a48c08419e879cd5abcdb013b223b74cf3457b96d";
  };

  solarized-disks-png = {
    name = "solarized-disks";
    mimetype = "image/png";
    sha256 = "180dff6bee85ff28efa0a8412a99b357666bfdc2a26e769c6ac2e35ab4b9ba3b";
  };

  solarized-stars-png = {
    name = "solarized-stars";
    mimetype = "image/png";
    sha256 = "72c7735e5a50b16c576df8b84bd6efc03ba202b7820ee00f7dede83392f168e7";
  };

  wintroll-png = {
    name = "wintroll";
    mimetype = "image/png";
    sha256 = "380301fd8719a82be6f4e4aab2ac11c10e9540b3ab3c395c5345635f24a953d2";
  };

}
