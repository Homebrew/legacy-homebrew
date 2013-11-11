# brew-bundle.rb
# Looks for a "Brewfile" in the current directory and runs each line
# as a brew command.
#
# For example, given a Brewfile with the following contents:
# tap foo/bar
# install spark
#
# Running `brew bundle` will run the commands `brew tap foo/bar`
# and `brew install spark`.

raise 'Cannot find Brewfile' unless File.exist? 'Brewfile'

File.readlines('Brewfile').each do |line|
  command = line.chomp
  next if command.empty?
  next if command.chars.first == '#'

  system "brew #{command}"
end
