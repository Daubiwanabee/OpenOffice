# Apache OpenOffice 4.1.16 portable (fr, Windows)

Tag suggéré : `v4.1.16-portable-fr`
Fichiers à joindre : `dist/OpenOffice_4.1.16_Portable_fr.7z` et `dist/OpenOffice_4.1.16_Portable_fr.7z.sha256`

---

Version portable pour Windows d'**Apache OpenOffice 4.1.16** (français), la dernière version publiée par la fondation Apache, construite à partir de l'installeur officiel `Apache_OpenOffice_4.1.16_Win_x86_install_fr.exe` (SHA-256 vérifiée).

## Utilisation
1. Téléchargez `OpenOffice_4.1.16_Portable_fr.7z` ci-dessous et décompressez-le avec [7-Zip](https://www.7-zip.org/) où vous voulez (clé USB, disque externe, dossier quelconque).
2. Lancez `OpenOffice.cmd` (ou `Writer.cmd`, `Calc.cmd`, `Impress.cmd`, `Draw.cmd`, `Base.cmd`, `Math.cmd`), ou directement `program\soffice.exe`.

Aucune installation, aucune écriture dans le registre : le profil utilisateur est stocké dans le dossier `Data` à côté du programme. Les polices livrées sont chargées depuis `share\fonts\truetype`. Java n'est pas inclus (utile seulement pour Base et quelques assistants).

## Intégrité
SHA-256 de l'archive : `ae27283aec0abfc4793cf6e11dd79661b6aa3738855d01ecba7d66977535b910`

Script de reconstruction : `scripts/build-portable.sh 4.1.16 fr`
