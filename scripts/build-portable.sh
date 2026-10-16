#!/usr/bin/env bash
# Construit une version portable (.7z) d'Apache OpenOffice pour Windows
# a partir de l'installeur officiel. Depend de : curl, p7zip-full, msitools.
#
# Usage : scripts/build-portable.sh [VERSION] [LANGUE]      ex. 4.1.16 fr
set -euo pipefail

VERSION="${1:-4.1.16}"
LANG_CODE="${2:-fr}"
BASE_URL="https://downloads.apache.org/openoffice/${VERSION}/binaries/${LANG_CODE}"
ARCHIVE_URL="https://archive.apache.org/dist/openoffice/${VERSION}/binaries/${LANG_CODE}"
INSTALLER="Apache_OpenOffice_${VERSION}_Win_x86_install_${LANG_CODE}.exe"
NAME="OpenOffice_${VERSION}_Portable_${LANG_CODE}"

HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="${WORK:-$(mktemp -d)}"
OUT="${OUT:-$HERE/../dist}"
mkdir -p "$OUT"

echo "==> Telechargement de $INSTALLER"
mkdir -p "$WORK/dl"
for url in "$BASE_URL" "$ARCHIVE_URL"; do
    if curl -fsSL -o "$WORK/dl/$INSTALLER" "$url/$INSTALLER" \
       && curl -fsSL -o "$WORK/dl/$INSTALLER.sha256" "$url/$INSTALLER.sha256"; then
        break
    fi
done
(cd "$WORK/dl" && sed 's/\*//' "$INSTALLER.sha256" | sha256sum -c -)

echo "==> Extraction de l'installeur (NSIS) puis du MSI"
mkdir -p "$WORK/exe" "$WORK/msi"
7z x -y -o"$WORK/exe" "$WORK/dl/$INSTALLER" > /dev/null
MSI="$(find "$WORK/exe" -maxdepth 1 -iname '*.msi' | head -n1)"
msiextract -C "$WORK/msi" "$MSI" > /dev/null
SRC="$(find "$WORK/msi" -maxdepth 2 -type d -name 'OpenOffice 4*' | head -n1)"

echo "==> Assemblage de l'arborescence portable"
BUILD="$WORK/build/$NAME"
mkdir -p "$BUILD/licenses" "$BUILD/Data"
cp -a "$SRC/program" "$SRC/share" "$SRC/help" "$SRC/presets" "$SRC/readmes" \
      "$SRC/readme.txt" "$SRC/readme.html" "$BUILD/"
cp "$WORK/exe/licenses/LICENSE" "$WORK/exe/licenses/NOTICE" "$BUILD/licenses/"

# msiextract nomme "Fonts:truetype" le dossier que le MSI installe dans le
# dossier Fonts de Windows ; en portable, OpenOffice le lit dans share/fonts/truetype.
if [ -d "$BUILD/share/fonts/Fonts:truetype" ]; then
    mv "$BUILD/share/fonts/Fonts:truetype" "$BUILD/share/fonts/truetype"
fi

# Profil utilisateur relatif au programme : c'est ce qui rend la version portable.
sed -i 's|^UserInstallation=.*|UserInstallation=$ORIGIN/../Data/settings|' "$BUILD/program/bootstrap.ini"

crlf() { sed 's/$/\r/' > "$1"; }
SHA="$(cut -d" " -f1 "$WORK/dl/$INSTALLER.sha256")"
sed -e "s/4\.1\.16/${VERSION}/g" -e "s/_fr\.exe/_${LANG_CODE}.exe/g" -e "s|binaries/fr/|binaries/${LANG_CODE}/|" \
    -e "s/5cf9b3015b279f6470cd8dc6f77399da82b77edb49db59fe21e64b3c67dc3252/${SHA}/" \
    "$HERE/LISEZMOI-Portable.txt" > "$BUILD/LISEZMOI-Portable.txt"
for pair in OpenOffice:soffice Writer:swriter Calc:scalc Impress:simpress Draw:sdraw Base:sbase Math:smath; do
    crlf "$BUILD/${pair%%:*}.cmd" <<CMD
@echo off
start "" "%~dp0program\\${pair##*:}.exe" %*
CMD
done
crlf "$BUILD/Data/A-PROPOS.txt" <<'TXT'
Ce dossier recevra votre profil utilisateur OpenOffice (Data\settings\user)
au premier lancement. Supprimez Data\settings pour revenir aux reglages par defaut.
TXT

echo "==> Compression 7z"
(cd "$WORK/build" && 7z a -t7z -mx=9 -m0=lzma2 -md=64m -ms=on -mmt=on "$OUT/$NAME.7z" "$NAME" > /dev/null)
(cd "$OUT" && sha256sum "$NAME.7z" > "$NAME.7z.sha256")
echo "==> Termine : $OUT/$NAME.7z"
