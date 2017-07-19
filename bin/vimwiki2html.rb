#!/usr/bin/env ruby

require 'pathname'
require 'tempfile'

$options = {}
[:force, :syntax, :extension, :output_path, :input_file, :css_file, :template_path, :template_default, :template_extension, :root_path].each do |k|
	$options[k] = ARGV.shift
	puts "#{k} : #{$options[k]}"
end

# requires markdown syntax
if $options[:syntax] != 'markdown'
	STDERR.puts 'error: input syntax must be markdown'
	exit 1
end

# make sure we have pandoc installed
if !File.executable?(`which pandoc`.chomp)
	STDERR.puts 'error: requires pandoc (`brew install pandoc`)'
	exit 1
end

# determine input and output filenames
$input_file  = $options[:input_file]
$output_file = File.join($options[:output_path], File.basename($input_file, $options[:extension]) + 'html')

# figure out root paths
$options[:root_path] = './' if $options[:root_path] == '-'
$input_path  = File.dirname($input_file)
$output_path = File.dirname($output_file)
$input_root_path  = File.expand_path(File.join($input_path, $options[:root_path]))
$output_root_path = File.expand_path(File.join($output_path, $options[:root_path]))
$index_basename = 'index.' + $options[:extension]

# create style.css if it doesn't exist
$css_file = File.join($output_root_path, 'style.css')
if !File.file?($css_file)
	IO.write($css_file, DATA.read)
end

$css_file_relative = Pathname.new($css_file).relative_path_from(Pathname.new($output_path))

# if we're not in force mode, see if output file already exists and if it's newer than the source
if $options[:force] == '0' && File.exist?($output_file)
	exit if File.stat($options[:input_file]).mtime < File.stat($output_file).mtime
end

# process input
input = File.read($input_file)

# fix up checkboxes
input.gsub!(/\[ \] /, '▢ ')
input.gsub!(/\[.\] /, '✔ ')

# method that does some link fixing up
def fix_link(title, uri)
# fix up special diary scheme to link directly to /diary/
	uri.gsub!(/^diary:/, '/diary/')
# build a list of candidate relative and absolute filenames
	candidates = []
	if uri =~ /^\//
		candidates << File.join($input_root_path, uri + '.' + $options[:extension])
		candidates << File.join($input_root_path, uri, $index_basename) if uri =~ /\/$/
	end
	candidates << File.join($input_path, uri + '.' + $options[:extension])
	candidates << File.join($input_path, uri, $index_basename) if uri =~ /\/$/
# search candidates to see if we find an actual file
	candidates.each do |c|
		if File.file?(c)
	# we found a matching filename, reconfigure the link to point directly to it
			relative_c = Pathname.new(c).relative_path_from(Pathname.new($input_path))
			uri = File.join(File.dirname(relative_c), File.basename(relative_c, $options[:extension]) + 'html')
			break
		end
	end
# return the recreated link with the (potentially) new URI
	"[#{title}](#{uri})"
end

# fix paths to local files (to be Linkname.html or /index.html if target file exists)
input.gsub!(/\[(?<title>.*)\]\((?<uri>.*)\)/).each { fix_link($1, $2) }
input.gsub!(/\[\[([0-9]{4}-[0-9]{2}-[0-9]{2})\|(.*)\]\]/).each { fix_link($2, $1) }

# save modified input to tmpfile
file = Tempfile.new('vimwiki2html')
file.write(input)
file.close

# run our command
pandoc_cmd = 'pandoc -f markdown_github -t html --mathjax=https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML'
pandoc_cmd = 'pandoc -f markdown_github -t html'
system("#{pandoc_cmd} -c \"#{$css_file_relative}\" \"#{file.path}\" > \"#{$output_file}\"")

# clean up tmpfile
file.unlink

__END__
html {
	font-size: 100%;
	overflow-y: scroll;
	-webkit-text-size-adjust: 100%;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	-ms-text-size-adjust: 100%;
}

body {
	color: #444;
   /* font-size: 0.8em; */
   font-family: Roboto, Verdana, sans-serif;
   line-height: 1.5em;
padding: 1em;
margin: auto;
		max-width: 42em;
background: #fefefe;
}

a {
color: #0645ad;
	   text-decoration: none;
}

a:visited {
color: #0b0080;
  }

a:hover {
color: #06e;
  }

a:active {
color: #faa700;
  }

a:focus {
outline: thin dotted;
  }

*::-moz-selection {
background: rgba(255, 255, 0, 0.3);
color: #000;
}

*::selection {
background: rgba(255, 255, 0, 0.3);
color: #000;
}

a::-moz-selection {
background: rgba(255, 255, 0, 0.3);
color: #0645ad;
}

a::selection {
background: rgba(255, 255, 0, 0.3);
color: #0645ad;
}

p {
margin: 1em 0;
}

img {
	max-width: 100%;
}

h1, h2, h3, h4, h5, h6 {
color: #111;
	   line-height: 125%;
	   margin-top: 1.2em;
	   font-weight: normal;
}

h4, h5, h6 {
	font-weight: bold;
}

h1 {
	font-size: 2.5em;
}

h2 {
	font-size: 2em;
}

h3 {
	font-size: 1.5em;
}

h4 {
	font-size: 1.2em;
}

h5 {
	font-size: 1em;
}

h6 {
	font-size: 0.9em;
}

blockquote {
color: #666666;
margin: 0;
		padding-left: 3em;
		border-left: 0.5em #EEE solid;
}

hr {
display: block;
height: 1px;
		background-color: #000000;
color: #000000;
border: 0 none;
margin: 1em 0;
padding: 0;
}

pre, code, kbd, samp {
color: #000;
	   background-color: #fafaf8;
	   font-family: monospace, monospace;
	   _font-family: 'courier new', monospace;
	   font-size: 0.90em;
	   line-height: 1.2em;
}

pre {
	white-space: pre;
	white-space: pre-wrap;
	word-wrap: break-word;
}

b, strong {
	font-weight: bold;
}

dfn {
	font-style: italic;
}

ins {
background: #ff9;
color: #000;
	   text-decoration: none;
}

mark {
background: #ff0;
color: #000;
	   font-style: italic;
	   font-weight: bold;
}

sub, sup {
	font-size: 75%;
	line-height: 0;
position: relative;
		  vertical-align: baseline;
}

sup {
top: -0.5em;
}

sub {
bottom: -0.25em;
}

ul, ol {
margin: 1em 0;
padding: 0 0 0 2em;
}

li p:last-child {
	margin-bottom: 0;
}

ul ul, ol ol {
margin: .3em 0;
}

dl {
	margin-bottom: 1em;
}

dt {
	font-weight: bold;
	margin-bottom: .8em;
}

dd {
margin: 0 0 .8em 2em;
}

dd:last-child {
	   margin-bottom: 0;
   }

img {
border: 0;
		-ms-interpolation-mode: bicubic;
		vertical-align: middle;
}

figure {
display: block;
		 text-align: center;
margin: 1em 0;
}

figure img {
border: none;
margin: 0 auto;
}

figcaption {
	font-size: 0.8em;
	font-style: italic;
margin: 0 0 .8em;
}

table {
	margin-bottom: 2em;
	border-bottom: 1px solid #ddd;
	border-right: 1px solid #ddd;
	border-spacing: 0;
	border-collapse: collapse;
}

table th {
padding: .2em 1em;
		 background-color: #eee;
		 border-top: 1px solid #ddd;
		 border-left: 1px solid #ddd;
}

table td {
padding: .2em 1em;
		 border-top: 1px solid #ddd;
		 border-left: 1px solid #ddd;
		 vertical-align: top;
}

.author {
	font-size: 1.2em;
	text-align: center;
}

@media only screen and (min-width: 480px) {
	body {
		font-size: 14px;
	}
}
@media only screen and (min-width: 768px) {
	body {
		font-size: 16px;
	}
}
@media print {
	* {
background: transparent !important;
color: black !important;
filter: none !important;
		-ms-filter: none !important;
	}

	body {
		font-size: 12pt;
		max-width: 100%;
	}

	a, a:visited {
		text-decoration: underline;
	}

	hr {
height: 1px;
border: 0;
		border-bottom: 1px solid black;
	}

	a[href]:after {
content: " (" attr(href) ")";
	}

	abbr[title]:after {
content: " (" attr(title) ")";
	}

	.ir a:after, a[href^="javascript:"]:after, a[href^="#"]:after {
content: "";
	}

	pre, blockquote {
border: 1px solid #999;
		padding-right: 1em;
		page-break-inside: avoid;
	}

	tr, img {
		page-break-inside: avoid;
	}

	img {
		max-width: 100% !important;
	}

	@page :left {
margin: 15mm 20mm 15mm 10mm;
	}

	@page :right {
margin: 15mm 10mm 15mm 20mm;
	}

	p, h2, h3 {
orphans: 3;
widows: 3;
	}

	h2, h3 {
		page-break-after: avoid;
	}
}
