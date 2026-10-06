#!/usr/bin/env bash
# Catalogue renderer — called by the n8n "Execute Command" node as  ./render_catalog.sh
# Renders  output/catalog.html  ->  output/catalog.pdf  with headless Chromium (best CSS fidelity
# for the catalogue), and writes a one-line  output/render-log.csv  (الملف,الصفحات,الحجم,الحالة)
# from what really landed on disk. stdout is path-free (counts only) so the node is safe to show.
#
# Run n8n from THIS folder so the relative paths resolve, e.g.:
#   cd 07-catalog-pdf && NODES_EXCLUDE="[]" N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n
# (n8n v2 disables the Execute Command node by default; NODES_EXCLUDE="[]" re-enables it.)
#
# Chromium is auto-detected on PATH. Override with:  CHROME=/path/to/chrome ./render_catalog.sh
# No Chromium? A LibreOffice fallback is used automatically (plainer CSS, but fully headless).
set -u
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML="$DIR/output/catalog.html"
PDF="$DIR/output/catalog.pdf"
LOG="$DIR/output/render-log.csv"
HOMEDIR="$DIR/output/.chrome-home"

CHROME="${CHROME:-$(command -v chromium chromium-browser google-chrome google-chrome-stable chrome 2>/dev/null | head -1)}"
mkdir -p "$DIR/output" "$HOMEDIR"
rm -f "$PDF"

status="فشل"
if [ -n "$CHROME" ]; then
  export HOME="$HOMEDIR" XDG_CACHE_HOME="$HOMEDIR/cache" XDG_CONFIG_HOME="$HOMEDIR/config"
  "$CHROME" --headless --no-sandbox --disable-gpu --no-pdf-header-footer \
      --user-data-dir="$HOMEDIR/ud" --print-to-pdf="$PDF" "file://$HTML" >/dev/null 2>&1
fi
# LibreOffice fallback if Chromium missing or produced nothing
if [ ! -s "$PDF" ]; then
  SOFFICE="$(command -v soffice libreoffice 2>/dev/null | head -1)"
  if [ -n "$SOFFICE" ]; then
    HOME="$HOMEDIR" "$SOFFICE" --headless --convert-to pdf --outdir "$DIR/output" "$HTML" >/dev/null 2>&1
  fi
fi
rm -rf "$HOMEDIR"

echo "الملف,الصفحات,الحجم,الحالة" > "$LOG"
if [ -s "$PDF" ]; then
  kb=$(( ( $(stat -c%s "$PDF") + 1023 ) / 1024 ))
  pages=$(pdfinfo "$PDF" 2>/dev/null | awk '/^Pages:/{print $2}'); pages="${pages:-?}"
  echo "catalog.pdf,${pages},${kb} ك.ب,تم" >> "$LOG"; status="تم"
  echo "catalog rendered: pages=${pages} size=${kb}KB status=ok"
else
  echo "catalog.pdf,0,0 ك.ب,فشل" >> "$LOG"
  echo "catalog render FAILED (no Chromium/LibreOffice, or empty output)"
fi
[ "$status" = "تم" ] || exit 1
