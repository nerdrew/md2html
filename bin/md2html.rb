#!/usr/bin/env ruby

begin
  require 'premailer'
rescue LoadError => e
  puts e.inspect
  puts "To install premailer and get inlined css: gem install premailer"
end

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

custom_css = File.expand_path("../../share/md2html/custom-css.html", __FILE__)
cmd = %w[/usr/local/bin/pandoc -f markdown_github -t html -s -H]
cmd << custom_css
html = IO.popen(cmd, 'r+') do |io|
  io.print markdown
  io.close_write
  io.read
end

if defined?(Premailer)
  html = Premailer.new(html, with_html_string: true).to_inline_css
else
  html.gsub!(%r{<style[^>]*>.*</style>}, '')

  html.gsub!(/<pre>\s*<code>/, '<pre><code style="
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

  html.gsub!(/<code>/, '<code style="
    background-color: rgb(248,248,248);
    background: rgb(248,248,255);
    border-radius: 2px;
    border: 1px solid rgb(204,204,204);
    color: rgb(51,51,51);
    font-family: Consolas,Inconsolata,Courier,monospace;
    font-size: 9pt;
    margin: 0px 1px;
    padding: 1px;
    white-space: pre-wrap;
  ">')
end

puts html if ARGV.include?('--verbose')

unless ARGV.include?('--no-copy')
  hex = IO.popen(['hexdump', '-ve', '1/1 "%.2x"'], 'r+') do |io|
    io.print html
    io.close_write
    io.read
  end
  system('osascript', '-e', "set the clipboard to «data HTML#{hex}»")
end
