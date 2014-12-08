# Markdown to HTML converter

## Requirements

- pandoc
- hexdump
- osascript

## Install

```
make install PREFIX=/usr/local
```

## Usage

```
Usage: bin/md2html.rb [OPTIONS]

  -h, --help   Print this help
  --no-paste   Read from STDIN (default: read from `pbpaste`)
  --no-copy    Don't copy to clipboard (default: copy to clipboard)
  --verbose    Print HTML
```
