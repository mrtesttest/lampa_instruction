#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Проверка доступности плагинов Lampa"
echo "===================================="
echo ""

success=0
failed=0
total=0

for file in _plugins/*.html; do
    if [ ! -f "$file" ]; then
        continue
    fi
    
    url=$(grep -m 1 '^url_plugin:' "$file" | sed 's/url_plugin: *"\(.*\)"/\1/')
    
    if [ -z "$url" ]; then
        continue
    fi
    
    total=$((total + 1))
    filename=$(basename "$file")
    
    printf "%-40s " "$filename"
    
    http_code=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time 10 "$url")
    
    if [ "$http_code" = "200" ]; then
        echo -e "${GREEN}✓ OK${NC} ($http_code)"
        success=$((success + 1))
    else
        echo -e "${RED}✗ FAIL${NC} ($http_code)"
        echo "  URL: $url"
        failed=$((failed + 1))
    fi
done

echo ""
echo "===================================="
echo -e "Всего: $total | ${GREEN}Успешно: $success${NC} | ${RED}Ошибок: $failed${NC}"
