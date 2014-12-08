#!/usr/bin/env ruby

if ARGV.include?('--help') || ARGV.include?('-h')
  puts <<-EOF
Usage: #{$0} [OPTIONS]

	-h, --help	Print this help
	--no-paste	Read from STDIN (default: read from `pbpaste`)
	--no-copy	Don't copy to clipboard (default: copy to clipboard)
	--verbose	Print HTML
  EOF
  exit
end

if ARGV.include?('--no-paste')
  markdown = STDIN.read
else
  markdown = `pbpaste`
end

html = IO.popen(%w[/usr/local/bin/pandoc -f markdown_github -t html -s], 'r+') do |io|
  io.print markdown
  io.close_write
  io.read
end

html.gsub!(/<code[^>]*>/, '<code style="
  background-color: rgb(248,248,248);
  background: rgb(248,248,255);
  border-radius: 3px;
  border: 1px solid rgb(204,204,204);
  color: rgb(51,51,51);
  display: block;
  font-family: Consolas,Inconsolata,Courier,monospace;
  font-size: 9pt;
  margin: 0px 0.15em;
  padding: 0.5em;
  white-space: pre-wrap;
">')

puts html if ARGV.include?('--verbose')

unless ARGV.include?('--no-copy')
  hex = IO.popen(['hexdump', '-ve', '1/1 "%.2x"'], 'r+') do |io|
    io.print html
    io.close_write
    io.read
  end
  system('osascript', '-e', "set the clipboard to «data HTML#{hex}»")
end
