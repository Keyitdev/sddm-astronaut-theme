{
  pkgs,
}:
let
  inherit (pkgs)
    lib
    kdePackages
    stdenvNoCC
    ;
  themeNames = [
    "astronaut"
    "black-hole"
    "cyberpunk"
    "hyprland-kath"
    "jake-the-dog"
    "japanese-aesthetic"
    "pixel-sakura"
    "pixel-sakura-static"
    "post-apocalyptic-hacker"
    "purple-leaves"
  ];
  mkTheme =
    {
      name ? "astronaut",
    }:
    assert (lib.assertMsg (lib.elem name themeNames) "");
    stdenvNoCC.mkDerivation {
      name = "sddm-theme-${name}";
      pname = "sddm-theme-astronaut";
      version = "1.3.0";
      src = ./.;
      dontConfigure = true;
      buildPhase = "sed -i 's|ConfigFile=Themes/astronaut.conf|ConfigFile=Themes/${name}.conf|' metadata.desktop";
      OUTDIR = "share/sddm/themes/sddm-theme-astronaut";
      installPhase = ''
        mkdir -p $out/$OUTDIR/
        cp -r Components Assets Backgrounds Themes $out/$OUTDIR
        mv metadata.desktop Main.qml $out/$OUTDIR
      '';
      passthru.packages = with kdePackages; [
        qtmultimedia
        qtsvg
        qtvirtualkeyboard
      ];
    };
  themes =
    lib.listToAttrs (
      lib.forEach themeNames (name: {
        name = "sddm-theme-${name}";
        value = lib.makeOverridable mkTheme { inherit name; };
      })
    )
    // {
      default = lib.makeOverridable mkTheme { name = "astronaut"; };
    };
in
themes
