#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import csv
from Evtx.Evtx import Evtx
from Evtx.Views import evtx_file_xml_view
import xml.etree.ElementTree as ET

INPUT_FILE = "Security.evtx"
OUTPUT_FILE = "Security.csv"

def main():
    with Evtx(INPUT_FILE) as log, open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        # Nagłówki
        writer.writerow(["EventID", "Provider", "TimeCreated", "Message"])

        for xml_record in evtx_file_xml_view(log.get_file_header()):
            try:
                root = ET.fromstring(xml_record)

                # Pobieramy kilka podstawowych pól
                event_id = root.findtext(".//EventID")
                provider = root.find(".//Provider").attrib.get("Name", "")
                time_created = root.find(".//TimeCreated").attrib.get("SystemTime", "")
                message = ET.tostring(root, encoding="unicode", method="text").strip()

                writer.writerow([event_id, provider, time_created, message[:200].replace("\n", " ")])
            except Exception:
                # Pomijamy błędne rekordy
                continue

    print(f"[✓] Zapisano {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
