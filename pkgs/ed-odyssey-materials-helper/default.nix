{
  buildFHSEnv,
  stdenv,
  fetchurl,
  dpkg,
}:

let
  app = stdenv.mkDerivation rec {
    pname = "ed-odyssey-materials-helper-unwrapped";
    version = "3.15.12";

    src = fetchurl {
      url = "https://github.com/jixxed/ed-odyssey-materials-helper/releases/download/${version}/edomh-${version}.auto-updater.linux.deb";
      hash = "sha256-qO9w/nEnXQ3zloC4oN4BnC1RHz2zgI9n3YXsME80qOE=";
    };

    nativeBuildInputs = [ dpkg ];

    unpackPhase = ''
      dpkg -x $src .
    '';

    installPhase = ''
      mkdir -p $out
      cp -r opt/elite-dangerous-odyssey-materials-helper/* $out/
    '';
  };
in
buildFHSEnv {
  name = "ed-odyssey-materials-helper";

  targetPkgs = pkgs: with pkgs; [
    # System utilities called by launcher during extraction and launch
    coreutils
    procps
    gawk
    findutils
    lsb-release

    # Libraries for Java 25 and JavaFX
    stdenv.cc.cc.lib
    zlib
    glib
    gtk3
    alsa-lib
    libGL
    libglvnd
    libxxf86vm
    libxtst
    libx11
    libxext
    libxi
    libxrender
    ffmpeg
    freetype
    fontconfig
  ];

  runScript = "\"${app}/bin/Elite Dangerous Odyssey Materials Helper Launcher\"";

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/512x512/apps
    cp "${app}/lib/Elite Dangerous Odyssey Materials Helper Launcher.png" \
       $out/share/icons/hicolor/512x512/apps/ed-odyssey-materials-helper.png

    cat << 'DESKTOP' > $out/share/applications/ed-odyssey-materials-helper.desktop
[Desktop Entry]
Name=Elite Dangerous Odyssey Materials Helper
Comment=Helper for managing materials in Elite Dangerous Odyssey
Exec=ed-odyssey-materials-helper %u
Icon=ed-odyssey-materials-helper
Terminal=false
Type=Application
Categories=Game;
MimeType=x-scheme-handler/edomh;
StartupWMClass=nl.jixxed.bootstrap.Main
DESKTOP
  '';
}
