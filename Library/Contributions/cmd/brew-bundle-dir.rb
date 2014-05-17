#!/usr/bin/env ruby

# program name.
NAME = "bundle-dir"

# defaults.
PREFIX_DEFAULT = "~/.brews.d"

# effective prefix directory.
PREFIX = File.expand_path(ENV["BUNDLE_DIR"] || PREFIX_DEFAULT)

# validate prefix directory exists and is readable.
odie "'#{PREFIX}' does not exist, is not a directory, or is not readable." unless File.readable?(PREFIX) && File.directory?(PREFIX)

# list all available brewfiles in PREFIX.
def list
  Dir["#{PREFIX}/**/*.brewfile"].select do |brewfile|
    File.readable?(brewfile)
  end
end

# edit/open all available brewfiles in PREFIX.
def edit
  odie "environment variable EDITOR is not set." unless ENV["EDITOR"].length > 0
  system "$EDITOR #{list().join(' ')}"
end

# count number of `brew * install` lines across all found brewfiles.
def count
  system "echo #{list().join(' ')} | xargs cat | grep -vE '^[#]' | grep -vE '^$' | wc -l | awk '{ print $NR }'"
end

# print a usage message.
def usage
  <<-USAGE
Usage: brew #{NAME}

  Options:

   -c, --count  Count of formula found in all brewfiles found in PREFIX.
   -e, --edit   Edit/open all brewfiles found in PREFIX.
   -l, --list   List all brewfiles found in PREFIX.
   -h, --help   Display help information.
  USAGE
end

# command.
command = ARGV.first

# help.
if ["--help", "-h"].include? command
  puts usage ; exit 0
end

# list.
if ["--list", "-l"].include? command
  puts list ; exit 0
end

# edit.
if ["--edit", "-e"].include? command
  edit ; exit 0
end

# count.
if ["--count", "-c"].include? command
  count ; exit 0
end

# unknown option.
if !command.nil? && command.length > 0
  puts "#{usage}"
  puts "\n"
  odie "Unknown option: #{command}"
end

# main.
list().each do |brewfile|
  system "brew bundle #{brewfile}"
end
