# brew-bundle.rb

def usage
  puts <<-EOS.undent
  Usage: brew bundle [--ignore-failures] [path]

  Looks for a Brewfile and runs each line as a brew command.

  brew bundle              # Looks for "./Brewfile"
  brew bundle path/to/dir  # Looks for "path/to/dir/Brewfile"
  brew bundle path/to/file # Looks for "path/to/file"

  For example, given a Brewfile with the following content:
    install formula

  Running `brew bundle` will run the command `brew install formula`.

  Handling errors:
  Not all brew commands will work consistently in a Brewfile.
  Some commands will raise errors which will stop execution of the Brewfile
  unless `--ignore-failures` is provided either as a command line option or
  within the Brewfile.

  As a command line option:
    brew bundle --ignore-failures  # Will continue on errors

  Within the Brewfile:
    echo "--ignore-failures" > Brewfile
    echo "tap my/tap"       >> Brewfile
    echo "install formula"  >> Brewfile
    brew bundle                    # Will continue on errors
  EOS
  exit
end

usage if ARGV.include?('--help') || ARGV.include?('-h')
ignore_failures = ARGV.include?('--ignore-failures')

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

  if command.chars.first == '-'
    ignore_failures = true if command.include?('--ignore-failures')
    next
  end

  brew_cmd = "brew #{command}"
  status = system brew_cmd
  odie "Command failed: L#{index+1}:#{brew_cmd}" unless status or ignore_failures
end
