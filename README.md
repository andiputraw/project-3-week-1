# Mission 1: Website portofolio pribadi

Repository ini adalah landing page yang dibuat untuk menyelesaikan tugas proyek 3. Challange 1. 

## Running

Website dapat diakses via github pages di [github pages](https://andiputraw.github.io/project-3-week-1/)

Untuk menjalankan program. Disarankan menggunakan server via extensi [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) untuk VS Code. atau menggunakan python. Ini diperlukan karena fungsi `fetch()` pada javascript tidak dapat digunakan tanpa server

```bash
python -m http.server 8000
```

# Teknologi yang digunakan

Project ini menggunakan teknologi pada umumnya

- [HTML](https://id.wikipedia.org/wiki/HTML): Kerangka pada website
- [CSS](https://en.wikipedia.org/wiki/CSS): Memberikan style pada website
- [JS](https://id.wikipedia.org/wiki/JavaScript): Script untuk membuat website interaktif

Beberapa komponen memerlukan teknologi tambahan

- [Zig](https://ziglang.org/): bahasa tingkat rendah karena memerlukan manipulasi memori. Di compile dan mengoutputkan webassembly
- [WASM](https://webassembly.org/): hasil output dari zig. Bisa dibilang ini adalah .exe nya untuk website.

# Framework

Tidak ada fraemework yang digunakan pada project ini.

# Credit dan Referensi

Beberapa Referensi yang digunakan untuk website ini

- [Deno](https://deno.com/) dan [Deno Deploy](https://deno.com/deploy) sebagai referensi UI
- [Zeini-23025](https://github.com/Zeini-23025/Zeini-23025) Referrensi penggunaan badge untuk section _skills_
- [Reset CSS](https://meyerweb.com/eric/tools/css/reset/) mereset CSS bawaan browser.
- [TailwindCSS](https://tailwindcss.com/docs) Referensi value CSS untuk digunakan pada text, margin, dll.
- [Game of Life](https://github.com/andiputraw/game-of-life) implementasi game of life


