# brew-bundle.rb
#
# Usage: brew bundle [path]
#
# Looks for a Brewfile and runs each line as a brew command.
#
# brew bundle              # Looks for "./Brewfile"
# brew bundle path/to/dir  # Looks for "path/to/dir/Brewfile"
# brew bundle path/to/file # Looks for "path/to/file"
#
# For example, given a Brewfile with the following contents:
# tap foo/bar
# install spark
#
# Running `brew bundle` will run the commands `brew tap foo/bar`
# and `brew install spark`.

path = 'Brewfile'
error = ' in current directory'

if ARGV.first
  if File.directory? ARGV.first
    path = "#{ARGV.first}/#{path}"
    error = " in '#{ARGV.first}'"
  else
    path = ARGV.first
    error = " at '#{ARGV.first}'"
  end
end

raise "Cannot find Brewfile#{error}" unless File.exist? path

File.readlines(path).each_with_index do |line, index|
  command = line.chomp
  next if command.empty?
  next if command.chars.first == '#'

  brew_cmd = "brew #{command}"
  odie "Command failed: L#{index+1}:#{brew_cmd}" unless system brew_cmd
end
