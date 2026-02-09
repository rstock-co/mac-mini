#!/usr/bin/env python3
"""Convert XFA (IRCC) forms to fillable AcroForm PDFs by stripping the XFA layer."""

import sys
import pikepdf

def convert(input_path, output_path=None):
    if output_path is None:
        stem = input_path.rsplit(".", 1)[0]
        output_path = f"{stem}_acroform.pdf"

    pdf = pikepdf.open(input_path)

    if "/AcroForm" not in pdf.Root:
        print(f"ERROR: {input_path} has no AcroForm dictionary at all.")
        print("This form is XFA-only — no hidden AcroForm fallback exists.")
        print("You'll need Adobe Acrobat Pro to convert this one.")
        sys.exit(1)

    acroform = pdf.Root.AcroForm

    if "/XFA" not in acroform:
        print(f"{input_path} has no XFA layer — it's already a standard AcroForm PDF.")
        sys.exit(0)

    del acroform["/XFA"]

    # Check if fields actually exist in the AcroForm layer
    fields = acroform.get("/Fields", [])
    if len(fields) == 0:
        print(f"ERROR: XFA layer removed but AcroForm has 0 fields.")
        print("This form is XFA-only — the AcroForm layer is a stub.")
        print("You'll need Adobe Acrobat Pro to convert this one.")
        sys.exit(1)

    pdf.save(output_path)
    print(f"OK: Stripped XFA layer, {len(fields)} fillable AcroForm fields retained.")
    print(f"Saved: {output_path}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <input.pdf> [output.pdf]")
        sys.exit(1)
    convert(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else None)
