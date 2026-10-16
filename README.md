# OpenOffice portable

Version portable pour Windows d'**Apache OpenOffice 4.1.16** (français), la dernière
version publiée par la fondation Apache, construite à partir de l'installeur officiel.

## Téléchargement

| Fichier | Taille | SHA-256 |
|---|---|---|
| [`dist/OpenOffice_4.1.16_Portable_fr.7z`](dist/OpenOffice_4.1.16_Portable_fr.7z) | 82 Mo | voir [`dist/OpenOffice_4.1.16_Portable_fr.7z.sha256`](dist/OpenOffice_4.1.16_Portable_fr.7z.sha256) |

Décompressez l'archive avec [7-Zip](https://www.7-zip.org/) où vous voulez (clé USB,
disque externe, dossier quelconque), puis lancez `OpenOffice.cmd` ou directement
`program\soffice.exe`. Aucune installation, aucune écriture dans le registre.

## Ce qui a été fait

- L'installeur officiel `Apache_OpenOffice_4.1.16_Win_x86_install_fr.exe` a été
  téléchargé depuis `downloads.apache.org` et sa somme SHA-256 vérifiée.
- Son contenu (archive NSIS puis MSI) a été extrait sans modifier les binaires.
- Dans `program\bootstrap.ini`, `UserInstallation` pointe sur `$ORIGIN/../Data/settings` :
  le profil utilisateur (réglages, dictionnaires, macros, extensions) vit dans le
  dossier `Data` à côté du programme, au lieu de `%APPDATA%`.
- Les polices livrées (DejaVu, Liberation, Gentium, Caladea, Carlito…) sont placées dans
  `share\fonts\truetype`, où OpenOffice les charge lui-même sans les installer dans Windows.
- Ajout de lanceurs (`OpenOffice.cmd`, `Writer.cmd`, `Calc.cmd`, `Impress.cmd`, `Draw.cmd`,
  `Base.cmd`, `Math.cmd`) et d'un `LISEZMOI-Portable.txt`.

Java n'est pas inclus ; il n'est utile que pour Base et quelques assistants.

## Reconstruire l'archive

Sous Linux (ou WSL) avec `curl`, `p7zip-full` et `msitools` installés :

```bash
scripts/build-portable.sh 4.1.16 fr
```

L'archive est produite dans `dist/`. Changez les arguments pour une autre version ou
une autre langue (par exemple `4.1.16 en-US`).

## Licence

Apache OpenOffice est distribué sous licence Apache 2.0 ; les fichiers `LICENSE` et
`NOTICE` d'origine sont inclus dans l'archive (`licenses/`). Les scripts de ce dépôt
sont sous la même licence.
