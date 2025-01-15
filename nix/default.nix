{
  stdenvNoCC,
  qt6,
  lib,
  fetchFromGitHub,
  formats,
  themeName ? "astronaut",
  themeConfig ? null,
}: let
  user-cfg = (formats.ini {}).generate "${themeName}.conf.user" themeConfig;
in
  stdenvNoCC.mkDerivation rec {
    name = "sddm-astronaut-theme";

    src = fetchFromGitHub {
      owner = "Keyitdev";
      repo = "sddm-astronaut-theme";
      rev = "11c0bf6147bbea466ce2e2b0559e9a9abdbcc7c3";
      hash = "sha256-gBSz+k/qgEaIWh1Txdgwlou/Lfrfv3ABzyxYwlrLjDk=";
    };

    propagatedUserEnvPkgs = with qt6; [qtsvg qtmultimedia qtvirtualkeyboard];

    dontBuild = true;

    dontWrapQtApps = true;

    installPhase = ''
      themeDir="$out/share/sddm/themes/${name}"
      mkdir -p $themeDir
      cp -r $src/* $themeDir

      # Link theme
      ln -s "$themeDir/Themes/${themeName}.conf" $themeDir/

      substituteInPlace "$themeDir/metadata.desktop" \
        --replace-fail "ConfigFile=Themes/astronaut.conf" "ConfigFile=${themeName}.conf"

      # Link fonts
      mkdir $out/share/fonts
      ln -s $themeDir/Fonts/* $out/share/fonts/

      # Link theme overrides
      ${lib.optionalString (lib.isAttrs themeConfig) ''
        ln -sf ${user-cfg} "$themeDir/${themeName}.conf.user"
      ''}
    '';

    meta = with lib; {
      description = "Series of modern looking themes for SDDM";
      homepage = "https://github.com/Keyitdev/sddm-astronaut-theme";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  }
