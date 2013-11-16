# brew-bundle.rb
#
# Usage: brew bundle [path]
#
# Looks for a Brewfile and runs each line as a brew command.
#
# brew bundle              # Looks for "./brewfile"
# brew bundle path/to/dir  # Looks for "./path/to/dir/brewfile"
# brew bundle path/to/file # Looks for "./path/to/file"
#
# For example, given a Brewfile with the following contents:
#
# tap foo/bar
# install spark
#
# Running `brew bundle` will run the commands `brew tap foo/bar`
# and `brew install spark`.

if ARGV.empty? then
	path = 'brewfile'
else
	path = ARGV[0]
	if File.directory? path then
		path = path + '/brewfile'
	end
end

raise "No such Brewfile: #{path}" unless File.exist? path

File.readlines(path).each do |line|
  command = line.chomp
  next if command.empty?
  next if command.chars.first == '#'

  system "brew #{command}"
end
