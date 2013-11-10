# Looks for a Brewfile and runs each line as a brew command. For example:
#
# tap foo/bar
# install spark
#
# Saving the above commands in a Brewfile and running `brew bundle` will run
# the commands `brew tap foo/bar` and `brew install spark` automagically.
#
# Current discussion: https://github.com/mxcl/homebrew/pull/24107

raise "Cannot find Brewfile" if not File.exist?('Brewfile')
File.readlines('Brewfile').each do |line|
	command = line.chomp
	if not command.empty? and not command.chars.first == '#'
		`brew #{command}`
	end
end
