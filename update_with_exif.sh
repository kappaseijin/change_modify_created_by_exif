SEARCH_DIR='/d/Users/kappa/Dropbox/data/photo/google_photos/tgz/Takeout/Google フォト/エイチ展 H.4 2020'

find "$SEARCH_DIR" -type f \( -iname "*.jpg" -o -iname "*.JPG" -o -iname "*.jpeg" -o -iname "*.JPEG" -o -iname "*.png" -o -iname "*.PNG" -o -iname "*.heic" -o -iname "*.HEIC" -o -iname "*.mov" -o -iname "*.MOV" -o -iname "*.mp4" -o -iname "*.MP4" \) -exec bash -c '
  for unix_file; do
    datetime=$(exiftool -d "%Y-%m-%dT%H:%M:%S" -DateTimeOriginal "$unix_file" | awk -F": " '\''{print $2}'\'')
    if [ ! -z "$datetime" ]; then
      echo "unix_file:$unix_file"
      touch -am -d "$datetime" "$unix_file"
      win_file=$(echo "$unix_file" | sed "s/^\/\([a-z]\)\//\1:\//; s/\//\\\\/g")
      echo "win_file:$win_file"
      powershell.exe -Command "\$file = Get-Item \"$win_file\"; \$file.CreationTime = [datetime]::ParseExact(\"$datetime\", \"yyyy-MM-ddTHH:mm:ss\", \$null); \$file.LastWriteTime = [datetime]::ParseExact(\"$datetime\", \"yyyy-MM-ddTHH:mm:ss\", \$null);"
    fi
  done
' bash {} +
