{ stdenv, autoPatchelfHook, unzip, libX11, libXcomposite, glib
, libXcursor, libXdamage, libXext, libXi, libXrender, libXtst, libxcb, nspr
, dbus, gdk-pixbuf, gtk3, pango, atk, cairo, expat, libXrandr, libXScrnSaver
, alsaLib, at-spi2-core, cups, nss }:

stdenv.mkDerivation rec {
  pname = "foundry-vtt";
  version = "0.7.9";
  src = builtins.fetchTarball {
    name = "foundry-vtt-${version}";
    url = "https://foundryvtt.com/releases/download?version=${version}&platform=linux";
    sha256 = stdenv.lib.fakeSha256;
  };

  buildInputs = [
    alsaLib
    at-spi2-core
    atk
    autoPatchelfHook
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXi
    libXrandr
    libXrender
    libXrender
    libXtst
    libxcb
    nspr
    nss
    pango
    unzip
  ];

  installPhase = ''
    cp -r ${src} $out
  '';
}
