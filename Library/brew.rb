#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -W0
# encoding: UTF-8

std_trap = trap("INT") { exit! 130 } # no backtrace thanks

HOMEBREW_BREW_FILE = ENV['HOMEBREW_BREW_FILE']

if ARGV == %w{--prefix}
  puts File.dirname(File.dirname(HOMEBREW_BREW_FILE))
  exit 0
end

require 'pathname'
HOMEBREW_LIBRARY_PATH = Pathname.new(__FILE__).realpath.dirname.parent.join("Library/Homebrew").to_s
$:.unshift(HOMEBREW_LIBRARY_PATH + '/vendor')
$:.unshift(HOMEBREW_LIBRARY_PATH)
require 'global'

case ARGV.first when '-h', '--help', '--usage', '-?', 'help', nil
  require 'cmd/help'
  puts Homebrew.help_s
  exit ARGV.first ? 0 : 1
when '--version'
  puts HOMEBREW_VERSION
  exit 0
when '-v'
  puts "Homebrew #{HOMEBREW_VERSION}"
  # Shift the -v to the end of the parameter list
  ARGV << ARGV.shift
  # If no other arguments, just quit here.
  exit 0 if ARGV.length == 1
end

case HOMEBREW_PREFIX.to_s when '/', '/usr'
  # it may work, but I only see pain this route and don't want to support it
  abort "Cowardly refusing to continue at this prefix: #{HOMEBREW_PREFIX}"
end
if MACOS and MACOS_VERSION < 10.5
  abort <<-EOABORT.undent
    Homebrew requires Leopard or higher. For Tiger support, see:
    https://github.com/mistydemeo/tigerbrew
  EOABORT
end

# Many Pathname operations use getwd when they shouldn't, and then throw
# odd exceptions. Reduce our support burden by showing a user-friendly error.
Dir.getwd rescue abort "The current working directory doesn't exist, cannot proceed."


def require? path
  require path.to_s.chomp
rescue LoadError => e
  # HACK :( because we should raise on syntax errors but
  # not if the file doesn't exist. TODO make robust!
  raise unless e.to_s.include? path
end

begin
  trap("INT", std_trap) # restore default CTRL-C handler

  aliases = {'ls' => 'list',
             'homepage' => 'home',
             '-S' => 'search',
             'up' => 'update',
             'ln' => 'link',
             'instal' => 'install', # gem does the same
             'rm' => 'uninstall',
             'remove' => 'uninstall',
             'configure' => 'diy',
             'abv' => 'info',
             'dr' => 'doctor',
             '--repo' => '--repository',
             'environment' => '--env'  # same as gem
             }

  cmd = ARGV.shift
  cmd = aliases[cmd] if aliases[cmd]

  if cmd == '-c1' # Shortcut for one line of configuration
    cmd = '--config'
    ARGV.unshift('-1')
  end

  sudo_check = Set.new %w[ install link pin unpin upgrade ]

  if sudo_check.include? cmd
    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      raise "Cowardly refusing to `sudo brew #{cmd}`\n#{SUDO_BAD_ERRMSG}"
    end
  end

  # Add contributed commands to PATH before checking.
  ENV['PATH'] += ":#{HOMEBREW_REPOSITORY}/Library/Contributions/cmd"
  if require? HOMEBREW_REPOSITORY/"Library/Homebrew/cmd"/cmd
    Homebrew.send cmd.to_s.gsub('-', '_').downcase
  elsif which "brew-#{cmd}"
    %w[CACHE CELLAR LIBRARY_PATH PREFIX REPOSITORY].each do |e|
      ENV["HOMEBREW_#{e}"] = Object.const_get "HOMEBREW_#{e}"
    end
    exec "brew-#{cmd}", *ARGV
  elsif require? which("brew-#{cmd}.rb").to_s
    exit 0
  else
    onoe "Unknown command: #{cmd}"
    exit 1
  end

rescue FormulaUnspecifiedError
  abort "This command requires a formula argument"
rescue KegUnspecifiedError
  abort "This command requires a keg argument"
rescue UsageError
  onoe "Invalid usage"
  abort ARGV.usage
rescue SystemExit
  puts "Kernel.exit" if ARGV.verbose?
  raise
rescue Interrupt => e
  puts # seemingly a newline is typical
  exit 130
rescue BuildError => e
  e.dump
  exit 1
rescue RuntimeError, SystemCallError => e
  raise if e.message.empty?
  onoe e
  puts e.backtrace if ARGV.debug?
  exit 1
rescue Exception => e
  onoe e
  puts "#{Tty.white}Please report this bug:"
  puts "    #{Tty.em}#{ISSUES_URL}#{Tty.reset}"
  puts e.backtrace
  exit 1
else
  exit 1 if Homebrew.failed?
end
