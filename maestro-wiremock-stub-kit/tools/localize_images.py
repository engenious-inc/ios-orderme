#!/usr/bin/env python3
"""
localize_images.py
------------------
Назначение: сделать изображения **офлайн** при воспроизведении WireMock.

Что делает:
1) Находит во всех файлах `wiremock/__files/*.json` поля "imagePath": "http(s)://...".
2) Качает каждую такую картинку и сохраняет в `wiremock/__files/assets/<sha1>.<ext>`.
3) Создаёт для каждой картинки маппинг `wiremock/mappings/img-<sha1>.json` на путь `/assets/<sha1>.<ext>`.
4) Переписывает JSON-ответы, заменяя исходные URL на `/assets/<sha1>.<ext>`.
5) (Опц.) Если картинка не скачалась, можно указать `--placeholder` путь к png/jpg, он подставится для всех нескачанных.

Запуск из корня проекта, где лежит папка `wiremock/`:
    python3 tools/localize_images.py --base ./wiremock --placeholder ./tools/placeholder.png
"""
import os, re, sys, json, hashlib, mimetypes, urllib.request, urllib.error, argparse

def sha1(b: bytes) -> str:
    import hashlib
    return hashlib.sha1(b).hexdigest()

def ext_from_content_type(ct: str) -> str:
    if not ct:
        return "bin"
    ct = ct.split(";")[0].strip().lower()
    if ct == "image/jpeg" or ct == "image/jpg":
        return "jpg"
    if ct == "image/png":
        return "png"
    if ct == "image/gif":
        return "gif"
    if "/" in ct:
        return ct.split("/")[1]
    return "bin"

def download(url: str) -> (bytes, str):
    req = urllib.request.Request(url, headers={"User-Agent":"Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = resp.read()
        ct = resp.headers.get("Content-Type", "")
        return data, ct

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", default="./wiremock", help="папка wiremock (по умолчанию ./wiremock)")
    ap.add_argument("--placeholder", default="", help="PNG/JPG-заглушка, если не удалось скачать")
    args = ap.parse_args()

    base = os.path.abspath(args.base)
    files_dir = os.path.join(base, "__files")
    maps_dir  = os.path.join(base, "mappings")
    assets_dir= os.path.join(files_dir, "assets")
    os.makedirs(assets_dir, exist_ok=True)

    placeholder_bytes = b""
    placeholder_ext = "png"
    if args.placeholder and os.path.exists(args.placeholder):
        with open(args.placeholder, "rb") as f:
            placeholder_bytes = f.read()
        placeholder_ext = "png" if args.placeholder.lower().endswith(".png") else "jpg"

    url_re = re.compile(r'"imagePath"\s*:\s*"([^"]+)"')
    changed = 0
    created = 0

    for fn in os.listdir(files_dir):
        if not fn.endswith(".json"): 
            continue
        p = os.path.join(files_dir, fn)
        with open(p, "r", encoding="utf-8") as f:
            s = f.read()

        urls = url_re.findall(s)
        if not urls:
            continue

        repl = {}
        for url in urls:
            if not (url.startswith("http://") or url.startswith("https://")):
                # уже локальный
                continue
            print(f"[img] {url}")
            data = b""
            ext  = ""
            try:
                data, ct = download(url)
                ext = ext_from_content_type(ct)
            except Exception as e:
                if placeholder_bytes:
                    data = placeholder_bytes
                    ext = placeholder_ext
                    print(f"  ! download failed, use placeholder: {e}")
                else:
                    print(f"  ! skip (download failed): {e}")
                    continue

            h = sha1(data)
            out_name = f"{h}.{ext}"
            out_file = os.path.join(assets_dir, out_name)
            if not os.path.exists(out_file):
                with open(out_file, "wb") as f:
                    f.write(data)
                created += 1

                # mapping per image
                mapping = {
                    "request": {"url": f"/assets/{out_name}", "method": "GET"},
                    "response": {
                        "status": 200,
                        "headers": {
                            "Content-Type": "image/"+("jpeg" if ext=="jpg" else ext)
                        },
                        "bodyFileName": f"assets/{out_name}"
                    }
                }
                map_path = os.path.join(maps_dir, f"img-{h}.json")
                with open(map_path, "w", encoding="utf-8") as mf:
                    json.dump(mapping, mf, ensure_ascii=False, indent=2)

            repl[url] = f"/assets/{out_name}"

        if not repl:
            continue

        def replace_all(m):
            u = m.group(1)
            return f"\"imagePath\":\"{repl.get(u,u)}\""

        s2 = url_re.sub(lambda m: replace_all(m), s)
        if s2 != s:
            with open(p, "w", encoding="utf-8") as f:
                f.write(s2)
            changed += 1
            print(f"[rewrite] {p}")

    print(f"Done. json changed={changed}, images added={created}, assets_dir={assets_dir}")

if __name__ == "__main__":
    main()
