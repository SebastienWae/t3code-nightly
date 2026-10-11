# T3 Code nightly: upstream's prebuilt Linux server archive (a Node single
# executable + its native modules). source.json is bumped by ./update.sh,
# which the hourly GitHub Action runs.
{
  lib,
  stdenv,
  fetchurl,
  wrapBuddy,
}:
let
  source = lib.importJSON ./source.json;
in
stdenv.mkDerivation {
  pname = "t3code-nightly";
  inherit (source) version;

  src = fetchurl { inherit (source) url hash; };

  # wrapBuddy points the binaries at Nix's loader and libraries without
  # rewriting them, which keeps the Node single-executable payload intact.
  nativeBuildInputs = [ wrapBuddy ];
  buildInputs = [ stdenv.cc.cc.lib ];
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/t3code $out/bin
    cp -r . $out/lib/t3code
    ln -s $out/lib/t3code/t3 $out/bin/t3
    runHook postInstall
  '';

  # The archive is prebuilt: check that it actually starts here (loader,
  # libraries) before anyone gets it.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    HOME=$TMPDIR $out/bin/t3 --version
    runHook postInstallCheck
  '';

  meta = {
    description = "T3 Code server (nightly)";
    homepage = "https://github.com/pingdotgg/t3code";
    license = lib.licenses.mit;
    mainProgram = "t3";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
