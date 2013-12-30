# brew-bundle.rb

def usage
  puts <<-EOS.undent
  Usage: brew bundle [path]

  Looks for a Brewfile and runs each line as a brew command.

  brew bundle              # Looks for "./Brewfile"
  brew bundle path/to/dir  # Looks for "path/to/dir/Brewfile"
  brew bundle path/to/file # Looks for "path/to/file"

  Optional flags:

    --quiet             Redirects STDOUT to /dev/null

    --silent            Redirects STDERR to STDOUT and
                        invokes --quiet

  For example, given a Brewfile with the following content:
    install formula

  Running `brew bundle` will run the command `brew install formula`.

  NOTE: Not all brew commands will work consistently in a Brewfile.
  Some commands will raise errors which will stop execution of the Brewfile.

  Example that outputs an error:
    tap my/tap  # fails when my/tap has already been tapped

  In this case use the full formula path in the Brewfile instead:
    install my/tap/formula  # succeeds even when my/tap has already been tapped
  EOS
  exit
end

usage if ARGV.include?('--help') || ARGV.include?('-h')

path = 'Brewfile'
error = ' in current directory'

# redirect stdout to /dev/null
quiet = ARGV.include?('--quiet') || ARGV.include?('--silent') ? ' >/dev/null' : ''

# redirect stderr to stdout
silent = ARGV.include?('--silent') ? ' 2>&1' : ''

# remove the args we have processed from the ARGV array
ARGV.delete('--quiet')
ARGV.delete('--silent')

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

  brew_cmd = "brew #{command}#{quiet}#{silent}"
  odie "Command failed: L#{index+1}:#{brew_cmd}" unless system brew_cmd
end
