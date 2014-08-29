# brew-bundle.rb

def usage
  puts <<-EOS.undent
  Usage: brew bundle [path]

  Looks for a Brewfile and runs each line as a brew command.

  brew bundle              # Looks for "./Brewfile"
  brew bundle path/to/dir  # Looks for "path/to/dir/Brewfile"
  brew bundle path/to/file # Looks for "path/to/file"

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

opoo <<-EOS.undent
  brew bundle is unsupported and will be replaced with another,
  incompatible version at some point.
  Please feel free volunteer to support it in a tap.

EOS

usage if ARGV.include?('--help') || ARGV.include?('-h')

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
