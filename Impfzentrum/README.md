# Übungsdatenbank *Angestellte & Projekte*

## Vorbereitung

Die Daten für diese Datenbank befinden sich im Stammverzeichnis des
Projekt. Online sind die Daten in [diesem Ordner](/../tree/master) und
in dieser [zip
Datei](/../-/jobs/artifacts/master/file/AngProj.zip?job=AngProj) zu
finden.

Um die Daten zu laden, brauchen Sie das Kommandozeilentool
[`psql`](https://www.postgresql.org/docs/current/static/app-psql.html).

## Überblick

Die nachfolgende Abbildung zeigt die Relationen der Datenbank in UML.

``` plantuml
class Abteilung {
  AbtNr
  Name
}
class AbtLeitung {
  AbtNr
  AbtChef
}
class Angestellter {
  PersNr
  Name
  Tel
  Salaer
  Chef
  AbtNr
  Wohnort
  Eintrittsdatum
  Bonus
}
class Projekt {
  ProjNr
  Bezeichnung
  Startzeit
  Dauer
  Aufwand
  ProjLeiter
}
class ProjektZuteilung {
  PersNr
  ProjNr
  Zeitanteil
  Startzeit
  Dauer
}
Abteilung "1" -- "*" Angestellter
Abteilung "1" - "0..1" AbtLeitung: leitet <
AbtLeitung "0..1\nAbteilungsleiter" -- "1" Angestellter: ist <
Angestellter "0..1\nChef" - "*" Angestellter
Angestellter "1" -- "*" ProjektZuteilung
ProjektZuteilung "*" - "1" Projekt
Projekt "*" -- "0..1\nProjektleiter" Angestellter
hide circle
hide methods
```

Mithilfe dieser Datenbank können Mitarbeiter und Projekte einer Firma
verwaltet werden. Dazu gehört auch die Zuteilung zu Projekten und die
Verwaltung der Firmenhierarchie mittels Zuordnung eines Chef und die
Gliederung anhand von Abteilungen.

## Import der Datenbank und der Beispieldaten

Zur Erstellung der Datenbank und Import der Daten werden verschiedene
Dateien benötigt. Nachfolgend eine Auflistung der Dateien:

``` console
AngProj/
|-- 0_runAllScripts.sql
|-- 0_runAllScriptsORA.sql
|-- 1_extensions.sql
|-- 2_schema.sql
|-- 3_copy.sql
|-- 3_inserts.sql
|-- 4_constraints.sql
|-- 5_queries.sql
|-- README.md
|-- run.bat
`-- WindowsConsoleSettings.reg
```

Der Datenimport wird durch die Datei
[0\_runAllScripts.sql](0_runAllScripts.sql) gesteuert, welche mit dem
Programm
[`psql`](https://www.postgresql.org/docs/current/static/app-psql.html)
interpretiert werden kann.

Folgende Schritte werden dabei durchlaufen:

1.  Löschen der bestehenden Datenbank `angproj` und des zugeörigen
    Benutzer `anguser`

    Es ist notwendig, dass keine aktiven Verbindungen zur Datenbank mehr
    bestehen, da sonst die Datenbank oder auch der Benutzer nicht
    gelöscht werden kann.

2.  Erstellen des Benutzer `anguser` mit Passwort `angproj`
3.  Erstellen der Datenbank `angproj` mit `anguser` als Owner.
4.  Ausführen der Skripte in aufsteigender Reihenfolge. Bei grossen
    Importdaten empfiehlt sich die Verwendung des
    [`COPY`](https://www.postgresql.org/docs/current/static/sql-copy.html)
    anstelle des
    [`INSERT`](https://www.postgresql.org/docs/current/static/sql-insert.html)-
    Befehls, da dieser von der Datenbank effizienter ausgeführt wird.
5.  Die Datei [`5_queries.sql`](5_queries.sql) beinhaltet Abfragen,
    welche den Inhalt der Datenbank in unterschiedlicher Form aufzeigen.

### Datenimport PostgreSQL

1.  Entpacken Sie das Archiv oder klonen Sie die Sourcen:

    ``` bash
    git clone https://gitlab.dev.ifs.hsr.ch/ifs/AngProj
    ```

2.  Öffnen Sie eine Terminal/Konsole/Kommandozeile und wechseln Sie in
    das Verzeichnis mit den entpackten oder geklonten Dateien.
3.  Stellen Sie sicher, dass Sie das Kommando `psql --version` ausführen
    können. Falls dies nicht funktioniert, vor allem unter Windows,
    können Sie entweder:
    1.  den Suchpfad ergänzen durch Angabe zum Verzeichnis worin sich
        die Datei `psql.exe`(Windows) befindet mittels
        `PATH=%PATH%;C:\Program Files\PostgreSQL\9.6\bin`. Damit Sie
        dies nicht immer wieder anpassen müssen, empfiehlt sich die
        Erweiterung der PATH Umgebungsvariablen in den
        Systemeinstellungen von Windows. Suche nach *Umgebungsvariablen*
        resp. *environment variables*.
    2.  jeweils die absolute Pfadangabe zum Starten der PostgreSQL Tools
        verwenden, bspw:
        `"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" --version`
4.  Linux-/Ubuntu-Benutzer müssen je nach Installation des PostgreSQL
    Servers das Kommando mittels `sudo -u postgres` ausführen.
5.  Führen Sie nun das nachfolgende Kommando aus, um die Daten zu
    importieren (Queries müssen während der Importsequenz nicht
    ausgeführt werden):

    ``` bash
    psql -U postgres -v ON_ERROR_STOP=on -f 0_runAllScripts.sql
    ```

    -   Windows

        Alternativ kann auch die Datei [`run.bat`](run.bat) in der
        Konsole ausgeführt werden. Darin ist eine Anpassung der
        Konsolencodepage schon eingebaut. Sollten Fehler in der
        Darstellung von Zeichen auftreten (Umlaute etc.), kann man
        versuchen, dies mit der Datei
        [`WindowsConsoleSettings.reg`](WindowsConsoleSettings.reg) zu
        korrigieren.
    -   Linux / Mac OSX

        Unter Linux wird in den meisten Fällen ein eigener Benutzer
        postgres für die Datenbankverwaltung angelegt. Daher muss in der
        Grundkonfiguration jeweils sudo verwendet werden, um
        Datenbankbefehle auszuführen.

        ``` bash
        sudo -u postgres psql -v ON_ERROR_STOP=on -f 0_runAllScripts.sql
        ```

        Alternativ kann man sich für den Linux-Login einen
        PostgreSQL-Superuser-Account einrichten, wonach die Verwendung
        von `sudo -u postgres` entfällt. Dies geschieht mit folgendem
        Kommando (LoginName durch den \*nix-Account-Namen ersetzen):

        ``` bash
        createuser -s -U postgres --interactive
        Enter name of role to add: LoginName
        ```

        [Siehe auch
        Archwiki](https://wiki.archlinux.org/index.php/Postgres#Create_your_first_database.2Fuser)

    **Hinweis:**

    Bei folgender Fehlermeldung
    `\connect: FATAL: Peer authentication failed for user "anguser"`
    gibt es zwei mögliche Lösungen:
    1.  Die `psql` Kommandozeile ergänzen mit `-h localhost`
    2.  Die Datei `pg_hba.conf` muss dazu angepasst werden, weil das
        voreingestellte Authentifizierungsschema eine Verbindung über
        socket für andere Benutzer als `postgres` nicht zulässt. Die
        Datei befindet sich bei Debian/Ubuntu im Ordner
        `/etc/postgresql/9.6/main/`, bei anderen Distributionen im
        *Datenverzeichnis von `postgres`*, z.B.
        `/var/lib/postgres/data`.

        ``` console
        # peer durch trust ersetzen:
        # ALT:
        local   all   all      peer
        # NEU:
        local   all   all      trust
        ```

        Oder mittels `sed`-Expression:

        ``` bash
        # evtl. Pfad anpassen
        sudo sed -ie 's/^\(local *all *all *\)peer$/\1trust/g' \
          /etc/postgresql/9.6/main/pg_hba.conf
        ```

        **Nach erfolgter Modifikation muss der Server neu gestartet
        werden:**

        ``` bash
        # upstart Systeme
        sudo service postgresql restart
        # systemd Systeme
        sudo systemctl restart postgresql
        # init.d Systeme
        sudo /etc/init.d/postgresql restart
        ```

6.  Sofern das vorangegangene Kommando fehlerfrei ausgeführt wurde,
    können Sie folgende Schritte ausführen, um auf vorhandene Daten zu
    prüfen:

    ``` bash
    # es kann sein dass anstelle des Benutzers anguser postgres verwenden müssen
    psql -U anguser -d angproj
    # auflisten vorhandener Datenbanken
    \l
    # anzeigen der Anmeldedaten zur aktuellen Verbindung
    \c
    # verbinden zur angproj Datenbank, falls nicht schon als anguser zur Datenbank angproj eingeloggt:
    \c angproj anguser
    # auflisten vorhandener Tabellen
    \dt
    # auslesen der Angestellten:
    select * from angestellter;
    # verlassen von psql
    \q
    ```

### Datenimport Oracle

1.  Entpacken Sie das Archiv oder klonen Sie die Sourcen:

    ``` bash
    git clone https://gitlab.dev.ifs.hsr.ch/ifs/AngProj
    ```

2.  Öffnen Sie eine Terminal/Konsole/Kommandozeile und wechseln Sie in
    das Verzeichnis mit den entpackten oder geklonten Dateien.
3.  Stellen Sie sicher, dass Sie das Kommando `sqlplus -V` ausführen
    können. Auf der [Oracle](https://wiki.hsr.ch/Datenbanken/Oracle)
    Seite finden Sie verschiedene Links, die Sie weiterführen.
4.  Führen Sie nun das nachfolgende Kommando aus, um die Daten zu
    importieren. ***Wichtig:*** Passen Sie das Passwort für den Benutzer
    `system` an, falls dieses -- anders als im Folgenden angegeben --
    nicht `admin` sein soll!

    ``` bash
    sqlplus system/admin @0_runAllScriptsORA.sql
    ```

5.  Sofern das vorangegangene Kommando fehlerfrei ausgeführt wurde,
    können Sie folgende Schritte ausführen, um auf vorhandene Daten zu
    prüfen:

    ``` bash
    # Anmelden zur Datenbank als Benutzer anguser
    sqlplus anguser/angproj
    # auflisten vorhandener Tabellen
    select table_name from user_tables;
    # auslesen der Angestellten:
    select * from angestellter;
    # verlassen von sqlplus
    quit
    ```

#### Import mittels SQLDeveloper

Wenn Sie den Import der Datenbank über das *gewohnte* SQLDeveloper GUI
durchführen möchten, geschieht dies wie folgt:

1.  Melden Sie sich als `system` an
2.  Öffnen Sie die Datei `0_runAllScriptsORA.sql`
3.  Im neu geöffneten Fenster sehen Sie den Inhalt und den Namen der
    Datei
4.  Lassen Sie das Script mittels ***F5*** ausführen
5.  Melden Sie sich ab (Disconnect) und und als Benutzer `anguser`
    wieder an.

#### Verbindungs-Parameter

Die SID (Oracle System ID, d.h. eindeutiger Instanzname) lautet `orcl`
(bei Express Edition ist die SID `xe`); weitere Parameter sind
`Host=localhost`, `Port=1521`. Weiter Hinweise zum sogenannten *Connect
String* oder auch *Net Service Name* finden Sie im Guide: [Erste
Schritte mit SQL
Plus](http://docs.oracle.com/cd/E11882_01/server.112/e16604/ch_three.htm#CHDBIAEB)

---
keywords:
- database
- sql
- postgresql
- plpgsql
- stored procedure
- trigger
- views
- arrays
title: 'Übungsdatenbank *Angestellte & Projekte*'
---

