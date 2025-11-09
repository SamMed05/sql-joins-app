# SQL Joins Visualizer

An interactive web app to visualize SQL JOIN operations using Venn diagrams with animated explanations.

## ✨ Features

- **Interactive Venn Diagrams** - Click on diagram segments to see different SQL join types
- **Animated Explanations** - Manim-powered animations that demonstrate each join visually
- **SQL Code Examples** - Get the exact SQL query for each join type
- **Copy to Clipboard** - One-click copying of SQL queries

## 🚀 Quick Start

```bash
# Install dependencies
pnpm install

# Start development server
pnpm run dev
```

Visit `http://localhost:5173` to see the app!

## 🎬 Animations Setup (Optional)

The app includes animated explanations using [Manim](https://www.manim.community/). Currently supports:

- **INNER JOIN** - Matching records from both tables ✅
- **LEFT JOIN** - All from left table + matching from right ✅
- **RIGHT JOIN** - All from right table + matching from left 🏗️
- **LEFT ANTI JOIN** - Rows in left table with no match in right 🏗️
- **RIGHT ANTI JOIN** - Rows in right table with no match in left 🏗️
- **FULL OUTER JOIN** - All records from both tables ✅
- **FULL ANTI JOIN** - Rows with no match in either table 🏗️

### Generating Animations

**Prerequisites:** Python 3.8+ and FFmpeg

**Quick Setup:**

```bash
# Windows
.\setup-animations.ps1

# Linux/Mac
chmod +x setup-animations.sh
./setup-animations.sh
```

**Manual Setup:**

```bash
cd manim_scripts
pip install -r requirements.txt
python generate_all.py
```

This generates MP4 videos in `static/animations/`.

### Customizing Animations

Edit files in `manim_scripts/` then regenerate:

```bash
cd manim_scripts
manim -pql inner_join.py InnerJoinScene
```

Adjust quality in `generate_all.py`:

- `QUALITY = "l"` - Low (fast, ~1-2 MB)
- `QUALITY = "m"` - Medium (~3-5 MB)
- `QUALITY = "h"` - High (best quality, ~8-15 MB)

### Adding More Joins

Additional join animations can be added following patterns from [@jmablog's manim joins](https://github.com/jmablog/manim/tree/main/joins).

## 🛠️ Development

Built with:

- **SvelteKit 2** - Framework
- **Svelte 5** - UI components with runes
- **Manim** - Mathematical animations
- **Highlight.js** - SQL syntax highlighting

### Project Structure

```text
src/lib/components/
  ├── ManimAnimation.svelte    # Animation player
  ├── SqlJoins.svelte          # Main component
  └── VennDiagram.svelte       # Interactive diagram
static/animations/             # Generated videos
manim_scripts/                 # Python animation scripts
```

## 🔮 Future Enhancements

- **Manim Web Integration** - Browser-native vector rendering with JSON exports
- **More Join Types** - RIGHT JOIN, ANTI JOINs, etc.
- **Interactive Playback** - Control animation speed and replay
- **Custom Data** - User-defined table examples

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 Credits

- Original visualizer: [sql-joins.leopard.in.ua](https://sql-joins.leopard.in.ua/)
- Animations powered by [Manim Community](https://www.manim.community/)
- Animation code based on [@jmablog's SQL joins animations](https://github.com/jmablog/manim/tree/main/joins)

## 📄 License

See LICENSE file for details.
