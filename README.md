# 2048_Byte_FPC

Dieses Repository enthält eine stark abgespeckte Free-Pascal-Codebasis, die demonstriert,
wie sich eine Win64-Anwendung mit einem sehr kleinen Footprint bauen lässt. Das Projekt
liefert vor allem eine Lern- und Experimentierumgebung, um den Systemstart von
Pascal-Programmen, die Generierung der Standardlaufzeitbibliothek (RTL) und das
Zusammenspiel mit Assembler-Code nachzuvollziehen.

## Grober Aufbau

```
src/
├── build.bat          # Build-Skript für Windows
├── system.pas         # Minimalimplementierung der System-Unit
├── sysinit.pas        # Einstiegspunkt, ruft `PascalMain`
├── objpas.pas         # Platzhalter für Objekt-Pascal-Kompatibilität
├── fpintres.pas       # Platzhalter für Ressourcen-Unit
├── sources/           # Quelltexte der einzelnen Teilkomponenten
│   ├── fpc-rtl/       # RTL-Erweiterungen (Pascal)
│   ├── fpc-sys/       # systemnahe Dateien (Assembler)
│   └── fpc-test/      # Beispielprogramm(e)
└── tests/             # Linker-Skripte und Zwischenartefakte
```

Das Herzstück bildet `system.pas`. Hier werden elementare Typen und Strukturen der
Free-Pascal-Laufzeit definiert – beispielsweise GUIDs, Exceptions und interne Record-Typen.
Die Datei ist absichtlich minimal gehalten, damit das Projekt auf rund 2 KB anwächst.

`sysinit.pas` stellt den Einstiegspunkt bereit: Die `Entry`-Prozedur besitzt das Alias
`_mainCRTStartup` und ruft direkt `PascalMain`. Dadurch lässt sich der herkömmliche C-
Runtime-Startcode umgehen und Speicher sparen.

## Wichtige Dateien und Aufgabenbereiche

* **Build-Skript (`src/build.bat`)** – automatisiert den kompletten Build. Das Skript ruft den
  Cross-Compiler (`ppcrossX64.exe`), erzeugt die Start-Routine `fpcinit.o` aus dem Assembler
  und linkt anschließend ein Testprogramm inklusive eigener Linker-Konfiguration.
* **Systemnahe Assembler-Datei (`src/sources/fpc-sys/fpcinit.asm`)** – enthält die leere
  Routine `fpc_initializeunits`. Sie wird vom Pascal-Code importiert, kann aber später um
  Initialisierungsschritte erweitert werden.
* **RTL-Helfer (`src/sources/fpc-rtl/RTL.utils.pas`)** – Beispiel-Unit, die zeigt, wie
  zusätzliche Pascal-Einheiten eingebunden werden können.
* **Testprogramm (`src/sources/fpc-test/test1.pas`)** – minimale Anwendung, die lediglich die
  `test`-Prozedur der RTL-Helfer-Unit aufruft. Das Programm demonstriert, wie Units
  zusammenspielen und über Direktiven (`{$L fpcinit.o}`) Assemblerobjekte einbinden.
* **Linker-Skript (`src/tests/test1.ld`)** – beschreibt den Aufbau der Win64-Peat-Executable.
  Die Sektionen (`.text`, `.data`, `.rdata`, …) werden damit exakt so angeordnet, dass das
  finale Binary die Zielgröße erreicht.

## Lernschwerpunkte für Einsteiger:innen

1. **Pascal-Units verstehen:** Lies `system.pas`, um zu sehen, welche Basis-Typen für eine
   Pascal-Laufzeit nötig sind. Viele Deklarationen sind stark vereinfacht, was dir den Einstieg
   erleichtert.
2. **Direktiven und Build-Flags nutzen:** Die Compiler-Optionen im Batch-Skript zeigen, wie man
   Free Pascal gezielt konfiguriert (`-Mdelphi`, `-Anasmwin64`, `-XMmainCRTstartup`, …) und
   damit Ein- und Ausgabedateien steuert.
3. **Assembler-Integration:** `test1.pas` bindet mit `{$L fpcinit.o}` die von NASM erzeugte
   Objektdatei ein. In Kombination mit `fpcinit.asm` kannst du Schritt für Schritt eigene
   Startprozeduren hinzufügen.
4. **Linker-Layouts lesen:** Durch das Linker-Skript siehst du, wie Windows-PE-Executable
   aufgebaut ist. Das Verständnis der Sektionen hilft beim Optimieren von Größe und Struktur.

Wenn du experimentieren möchtest, bietet sich folgender Lernpfad an:

1. Baue das Projekt unter Windows mithilfe von `build.bat` nach und beobachte die erzeugten
   Artefakte im Ordner `src/tests/units`.
2. Erweitere `RTL.utils.pas` um eigene Funktionen und rufe sie aus `test1.pas` auf, um den
   Zusammenhang zwischen Units zu festigen.
3. Ergänze `fpcinit.asm` um Initialisierungscode (z. B. das Setzen globaler Variablen) und
   prüfe, wie sich Änderungen auf den Programmstart auswirken.

Mit dieser Struktur lernst du Schritt für Schritt, wie der Free-Pascal-Compiler aufgebaut ist
und wie sich ein minimales Win64-Programm zusammensetzt.
