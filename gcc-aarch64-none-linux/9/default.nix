{ lib, stdenv
, fetchurl
, ncurses5
, python27
, expat
}:

stdenv.mkDerivation rec {
  pname = "gcc-aarch64-none-linux";
  version = "9.2-2019.12";
  subdir = "9.2-2019.12";

  suffix = {
    x86_64-linux  = "x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu-a/${subdir}/binrel/gcc-arm-${version}-${suffix}-aarch64-none-linux-gnu.tar.xz";
    sha256 = {
      x86_64-linux  = "sha256-jf5oFTHwvQT7nFPPPAozaMYWqoXUiTjuvitRY3bgamY=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp -r * $out
    ln -s $out/share/doc/gcc-arm-none-eabi/man $out/man
  '';

  preFixup = ''
    find $out -type f | while read f; do
      patchelf "$f" > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
      patchelf --set-rpath ${lib.makeLibraryPath [ "$out" stdenv.cc.cc ncurses5 python27 expat ]} "$f" || true
    done
  '';

  meta = with lib; {
    description = "Pre-built GNU toolchain from ARM Cortex-A processors, linux target";
    homepage = "https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a";
    platforms = [ "x86_64-linux" ];
  };
}
