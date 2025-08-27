#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import sys
from Evtx.Evtx import Evtx
from Evtx.Views import evtx_file_xml_view

def convert_evtx_to_xml(input_path: str, output_path: str, pretty: bool = False):
    """
    Czyta plik .evtx i zapisuje wszystkie rekordy w jednym pliku XML.
    """
    # Uwaga: evtx_file_xml_view zwraca już kompletne węzły <Event> w XML.
    # My dokładamy nagłówek, root <Events> i stopkę.
    with Evtx(input_path) as log, open(output_path, "w", encoding="utf-8", buffering=1024*1024) as out:
        out.write('<?xml version="1.0" encoding="utf-8"?>\n<Events>\n')
        for idx, event_xml in enumerate(evtx_file_xml_view(log.get_file_header()), start=1):
            # event_xml to str zawierający pojedynczy <Event>…</Event>
            if pretty:
                # prosta „pseudo-pretty” — w razie potrzeby można podmienić na lxml
                event_xml = event_xml.replace("><", ">\n<")
            out.write(event_xml)
            out.write("\n")
            # (opcjonalnie) prosta informacja o postępie co 10k rekordów:
            if idx % 10000 == 0:
                print(f"[i] Zapisano {idx} rekordów…", file=sys.stderr)
        out.write("</Events>\n")

def main():
    parser = argparse.ArgumentParser(
        description="Konwersja pliku Windows Event Log (.evtx) do jednego pliku XML."
    )
    parser.add_argument("input", help="Ścieżka do pliku .evtx (np. Security.evtx)")
    parser.add_argument(
        "-o", "--output", default="output.xml",
        help="Ścieżka wyjściowa pliku XML (domyślnie: output.xml)"
    )
    parser.add_argument(
        "--pretty", action="store_true",
        help="Proste łamanie linii w XML dla czytelności (wolniejsze)"
    )
    args = parser.parse_args()

    try:
        convert_evtx_to_xml(args.input, args.output, pretty=args.pretty)
        print(f"[✓] Zakończono: {args.output}")
    except FileNotFoundError:
        print(f"[!] Nie znaleziono pliku: {args.input}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"[!] Błąd: {e}", file=sys.stderr)
        sys.exit(2)

if __name__ == "__main__":
    main()
