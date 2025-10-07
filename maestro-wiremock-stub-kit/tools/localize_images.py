#!/usr/bin/env python3
import argparse, hashlib, json, mimetypes, os, re, sys, urllib.request, urllib.error

URL_RE = re.compile(r'"(imagePath|image|imageUrl|icon|iconUrl|photo|photoUrl)"\s*:\s*"(https?://[^"]+)"')

def sha1(b: bytes) -> str:
    return hashlib.sha1(b).hexdigest()

def ext_from_ct(ct: str) -> str:
    if not ct: return "jpg"
    ct = ct.lower()
    if "png" in ct: return "png"
    if "webp" in ct: return "webp"
    return "jpg"

def download(url: str) -> (bytes, str):
    req = urllib.request.Request(url, headers={"User-Agent":"stub-localizer/1.0"})
    with urllib.request.urlopen(req, timeout=30) as r:
        data = r.read()
        ext = ext_from_ct(r.headers.get("Content-Type",""))
        return data, ext

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True, help="wiremock folder")
    ap.add_argument("--placeholder", help="png/jpg")
    args = ap.parse_args()

    files_dir = os.path.join(args.base, "__files")
    assets_dir = os.path.join(files_dir, "assets")
    os.makedirs(assets_dir, exist_ok=True)

    placeholder_data = None
    placeholder_ext = "png"
    if args.placeholder and os.path.exists(args.placeholder):
        with open(args.placeholder, "rb") as f:
            placeholder_data = f.read()
        placeholder_ext = "png" if args.placeholder.lower().endswith(".png") else "jpg"

    body_files = [os.path.join(files_dir, f) for f in os.listdir(files_dir) if f.endswith(".json")]

    url_to_local = {}
    created = 0
    changed = 0

    for path in body_files:
        s = open(path, "r", encoding="utf-8").read()

        def replacer(m):
            key = m.group(1)
            url = m.group(2)
            if url in url_to_local:
                return f'"{key}":"{url_to_local[url]}"'
            try:
                data, ext = download(url)
            except Exception:
                if placeholder_data is None:
                    return m.group(0)
                data, ext = placeholder_data, placeholder_ext
            h = sha1(data)
            local_name = f"{h}.{ext}"
            local_path = os.path.join(assets_dir, local_name)
            if not os.path.exists(local_path):
                with open(local_path, "wb") as f:
                    f.write(data)
            url_to_local[url] = f"/assets/{local_name}"
            nonlocal created
            created += 1
            return f'"{key}":"{url_to_local[url]}"'

        s2 = URL_RE.sub(replacer, s)
        if s2 != s:
            with open(path, "w", encoding="utf-8") as f:
                f.write(s2)
            changed += 1
            print(f"[rewrite] {os.path.basename(path)}")

    print(f"Done. json changed={changed}, new images={created}, assets_dir={assets_dir}")

if __name__ == "__main__":
    main()
