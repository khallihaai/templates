#!/usr/bin/env bash
# Certificate renderer — called by the n8n "Execute Command" node as  ./render_certs.sh
# Renders every  output/html/cert-<n>.html  ->  output/pdf/cert-<n>.pdf  with headless Chromium,
# and writes  output/render-log.csv  (الرقم,ملف الشهادة,الحجم,الحالة) from what really landed on disk.
#
# Run n8n from THIS folder so the relative paths resolve, e.g.:
#   cd 05-certificates && NODES_EXCLUDE="[]" N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n
# (n8n v2 disables the Execute Command node by default; NODES_EXCLUDE="[]" re-enables it.)
#
# Chromium is auto-detected on PATH. Override with:  CHROME=/path/to/chrome ./render_certs.sh
# No Chromium? See the LibreOffice fallback at the bottom of this file (one line to switch).
set -u
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML_DIR="$DIR/output/html"
PDF_DIR="$DIR/output/pdf"
CSS="$DIR/cert.css"
LOG="$DIR/output/render-log.csv"
HOMEDIR="$DIR/output/.chrome-home"

CHROME="${CHROME:-$(command -v chromium chromium-browser google-chrome google-chrome-stable chrome 2>/dev/null | head -1)}"
if [ -z "$CHROME" ]; then
  echo "ERROR: no Chromium/Chrome found on PATH. Install chromium, or set CHROME=/path/to/chrome," >&2
  echo "       or switch to the LibreOffice fallback (see the comment at the end of this script)." >&2
  exit 2
fi

mkdir -p "$PDF_DIR" "$HOMEDIR"
export HOME="$HOMEDIR" XDG_CACHE_HOME="$HOMEDIR/cache" XDG_CONFIG_HOME="$HOMEDIR/config"
cp -f "$CSS" "$HTML_DIR/cert.css"          # Chromium loads the stylesheet from the same folder

echo "الرقم,ملف الشهادة,الحجم,الحالة" > "$LOG"
ok=0; fail=0
for n in $(ls "$HTML_DIR" | sed -n 's/^cert-\([0-9]\+\)\.html$/\1/p' | sort -n); do
  out="$PDF_DIR/cert-$n.pdf"; rm -f "$out"
  "$CHROME" --headless --no-sandbox --disable-gpu --no-pdf-header-footer \
      --user-data-dir="$HOMEDIR/ud" --print-to-pdf="$out" "file://$HTML_DIR/cert-$n.html" \
      >/dev/null 2>&1
  if [ -s "$out" ]; then
    kb=$(( ( $(stat -c%s "$out") + 1023 ) / 1024 ))
    echo "$n,cert-$n.pdf,${kb} ك.ب,تم" >> "$LOG"; ok=$((ok+1))
  else
    echo "$n,cert-$n.pdf,0 ك.ب,فشل" >> "$LOG"; fail=$((fail+1))
  fi
done
rm -rf "$HOMEDIR"
echo "certificates rendered: ok=$ok fail=$fail"
[ "$fail" -eq 0 ] || exit 1

# ---------------------------------------------------------------------------------------------
# LibreOffice fallback (no Chromium): LibreOffice's HTML->PDF filter is simpler (less CSS), so the
# design is plainer, but it works headless. Replace the Chromium line in the loop above with:
#   soffice --headless --convert-to pdf --outdir "$PDF_DIR" "$HTML_DIR/cert-$n.html" >/dev/null 2>&1
# (soffice converts to cert-$n.pdf in $PDF_DIR). Keep the rest of the loop as-is.
