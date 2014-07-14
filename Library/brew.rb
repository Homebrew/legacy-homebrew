#!/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby -W0
# encoding: UTF-8

std_trap = trap("INT") { exit! 130 } # no backtrace thanks

HOMEBREW_BREW_FILE = ENV['HOMEBREW_BREW_FILE']

if ARGV == %w{--prefix}
  puts File.dirname(File.dirname(HOMEBREW_BREW_FILE))
  exit 0
end

require 'pathname'
HOMEBREW_LIBRARY_PATH = Pathname.new(__FILE__).realpath.dirname.parent.join("Library", "Homebrew")
$:.unshift(HOMEBREW_LIBRARY_PATH.to_s)
require 'global'

if ARGV.first == '--version'
  puts HOMEBREW_VERSION
  exit 0
elsif ARGV.first == '-v'
  puts "Homebrew #{HOMEBREW_VERSION}"
  # Shift the -v to the end of the parameter list
  ARGV << ARGV.shift
  # If no other arguments, just quit here.
  exit 0 if ARGV.length == 1
end

# Check for bad xcode-select before anything else, because `doctor` and
# many other things will hang
# Note that this bug was fixed in 10.9
if OS.mac? && MacOS.version < :mavericks && MacOS.active_developer_dir == "/"
  odie <<-EOS.undent
  Your xcode-select path is currently set to '/'.
  This causes the `xcrun` tool to hang, and can render Homebrew unusable.
  If you are using Xcode, you should:
    sudo xcode-select -switch /Applications/Xcode.app
  Otherwise, you should:
    sudo rm -rf /usr/share/xcode-select
  EOS
end

case HOMEBREW_PREFIX.to_s when '/', '/usr'
  # it may work, but I only see pain this route and don't want to support it
  abort "Cowardly refusing to continue at this prefix: #{HOMEBREW_PREFIX}"
end
if OS.mac? and MacOS.version < "10.5"
  abort <<-EOABORT.undent
    Homebrew requires Leopard or higher. For Tiger support, see:
    https://github.com/mistydemeo/tigerbrew
  EOABORT
end

# Many Pathname operations use getwd when they shouldn't, and then throw
# odd exceptions. Reduce our support burden by showing a user-friendly error.
Dir.getwd rescue abort "The current working directory doesn't exist, cannot proceed."

def require? path
  require path
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
             'environment' => '--env',
             '--config' => 'config',
             }

  empty_argv = ARGV.empty?
  help_regex = /(-h$|--help$|--usage$|-\?$|help$)/
  help_flag = false
  cmd = nil

  ARGV.dup.each_with_index do |arg, i|
    if help_flag && cmd
      break
    elsif arg =~ help_regex
      help_flag = true
    elsif !cmd
      cmd = ARGV.delete_at(i)
    end
  end

  cmd = aliases[cmd] if aliases[cmd]

  sudo_check = Set.new %w[ install link pin unpin upgrade ]

  if sudo_check.include? cmd
    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      raise "Cowardly refusing to `sudo brew #{cmd}`\n#{SUDO_BAD_ERRMSG}"
    end
  end

  # Add contributed commands to PATH before checking.
  ENV['PATH'] += "#{File::PATH_SEPARATOR}#{HOMEBREW_CONTRIB}/cmd"

  internal_cmd = require? HOMEBREW_LIBRARY_PATH.join("cmd", cmd) if cmd

  # Usage instructions should be displayed if and only if one of:
  # - a help flag is passed AND an internal command is matched
  # - a help flag is passed AND there is no command specified
  # - no arguments are passed
  #
  # It should never affect external commands so they can handle usage
  # arguments themselves.

  if empty_argv || (help_flag && (cmd.nil? || internal_cmd))
    # TODO - `brew help cmd` should display subcommand help
    require 'cmd/help'
    puts ARGV.usage
    exit ARGV.any? ? 0 : 1
  end

  if internal_cmd
    Homebrew.send cmd.to_s.gsub('-', '_').downcase
  elsif which "brew-#{cmd}"
    %w[CACHE CELLAR LIBRARY_PATH PREFIX REPOSITORY].each do |e|
      ENV["HOMEBREW_#{e}"] = Object.const_get("HOMEBREW_#{e}").to_s
    end
    exec "brew-#{cmd}", *ARGV
  elsif (path = which("brew-#{cmd}.rb")) && require?(path)
    exit Homebrew.failed? ? 1 : 0
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
  puts "    #{Tty.em}#{OS::ISSUES_URL}#{Tty.reset}"
  puts e.backtrace
  exit 1
else
  exit 1 if Homebrew.failed?
end
