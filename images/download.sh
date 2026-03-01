#!/bin/bash
# Скачивает изображения для лендинга. Убедитесь, что возвращается HTTP 200.

cd "$(dirname "$0")"
FAIL=0

download() {
  local url="$1"
  local file="$2"
  local code
  code=$(curl -sL -w "%{http_code}" -o "$file" "$url")
  if [ "$code" = "200" ]; then
    echo "✓ $file: HTTP $code"
  else
    echo "✗ $file: HTTP $code (ожидался 200)"
    rm -f "$file"
    FAIL=1
  fi
}

download "https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=600&q=80" "model.jpg"
download "https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&q=80" "description.jpg"
download "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600&q=80" "camera.jpg"

if [ $FAIL -eq 0 ]; then
  echo ""
  echo "Все изображения загружены."
  ls -la *.jpg
else
  echo ""
  echo "Ошибка: некоторые загрузки не вернули 200."
  exit 1
fi
