std_trap = trap("INT") { exit! 130 } # no backtrace thanks

require "pathname"
HOMEBREW_LIBRARY_PATH = Pathname.new(__FILE__).realpath.parent.join("Homebrew")
$:.unshift(HOMEBREW_LIBRARY_PATH.to_s)
require "global"

if ARGV == %w[--version] || ARGV == %w[-v]
  puts "Homebrew #{Homebrew.homebrew_version_string}"
  puts "Homebrew/homebrew-core #{Homebrew.core_formula_repository_version_string}"
  exit 0
end

if OS.mac? && MacOS.version < "10.6"
  abort <<-EOABORT.undent
    Homebrew requires Snow Leopard or higher. For Tiger and Leopard support, see:
    https://github.com/mistydemeo/tigerbrew
  EOABORT
end

def require?(path)
  require path
rescue LoadError => e
  # HACK: ( because we should raise on syntax errors but
  # not if the file doesn't exist. TODO make robust!
  raise unless e.to_s.include? path
end

begin
  trap("INT", std_trap) # restore default CTRL-C handler

  empty_argv = ARGV.empty?
  help_flag_list = %w[-h --help --usage -? help]
  help_flag = false
  internal_cmd = true
  cmd = nil

  ARGV.dup.each_with_index do |arg, i|
    if help_flag && cmd
      break
    elsif help_flag_list.include? arg
      help_flag = true
    elsif !cmd
      cmd = ARGV.delete_at(i)
    end
  end

  # Add contributed commands to PATH before checking.
  Dir["#{HOMEBREW_LIBRARY}/Taps/*/*/cmd"].each do |tap_cmd_dir|
    ENV["PATH"] += "#{File::PATH_SEPARATOR}#{tap_cmd_dir}"
  end

  # Add SCM wrappers.
  ENV["PATH"] += "#{File::PATH_SEPARATOR}#{HOMEBREW_LIBRARY}/ENV/scm"

  if cmd
    internal_cmd = require? HOMEBREW_LIBRARY_PATH.join("cmd", cmd)

    if !internal_cmd && ARGV.homebrew_developer?
      internal_cmd = require? HOMEBREW_LIBRARY_PATH.join("dev-cmd", cmd)
    end
  end

  # Usage instructions should be displayed if and only if one of:
  # - a help flag is passed AND an internal command is matched
  # - a help flag is passed AND there is no command specified
  # - no arguments are passed
  #
  # It should never affect external commands so they can handle usage
  # arguments themselves.

  if empty_argv || (help_flag && (cmd.nil? || internal_cmd))
    # TODO: - `brew help cmd` should display subcommand help
    require "cmd/help"
    if empty_argv
      $stderr.puts ARGV.usage
    else
      puts ARGV.usage
    end
    exit ARGV.any? ? 0 : 1
  end

  if internal_cmd
    Homebrew.send cmd.to_s.tr("-", "_").downcase
  elsif which "brew-#{cmd}"
    %w[CACHE LIBRARY_PATH].each do |e|
      ENV["HOMEBREW_#{e}"] = Object.const_get("HOMEBREW_#{e}").to_s
    end
    exec "brew-#{cmd}", *ARGV
  elsif (path = which("brew-#{cmd}.rb")) && require?(path)
    exit Homebrew.failed? ? 1 : 0
  else
    require "tap"
    possible_tap = case cmd
    when "brewdle", "brewdler", "bundle", "bundler"
      Tap.fetch("Homebrew", "bundle")
    when "cask"
      Tap.fetch("caskroom", "cask")
    when "services"
      Tap.fetch("Homebrew", "services")
    end

    if possible_tap && !possible_tap.installed?
      brew_uid = HOMEBREW_BREW_FILE.stat.uid
      tap_commands = []
      if Process.uid.zero? && !brew_uid.zero?
        tap_commands += %W[/usr/bin/sudo -u ##{brew_uid}]
      end
      tap_commands += %W[#{HOMEBREW_BREW_FILE} tap #{possible_tap}]
      safe_system *tap_commands
      exec HOMEBREW_BREW_FILE, cmd, *ARGV
    else
      onoe "Unknown command: #{cmd}"
      exit 1
    end
  end

rescue FormulaUnspecifiedError
  abort "This command requires a formula argument"
rescue KegUnspecifiedError
  abort "This command requires a keg argument"
rescue UsageError
  onoe "Invalid usage"
  abort ARGV.usage
rescue SystemExit => e
  onoe "Kernel.exit" if ARGV.verbose? && !e.success?
  $stderr.puts e.backtrace if ARGV.debug?
  raise
rescue Interrupt => e
  $stderr.puts # seemingly a newline is typical
  exit 130
rescue BuildError => e
  e.dump
  exit 1
rescue RuntimeError, SystemCallError => e
  raise if e.message.empty?
  onoe e
  $stderr.puts e.backtrace if ARGV.debug?
  exit 1
rescue Exception => e
  onoe e
  if internal_cmd
    $stderr.puts "#{Tty.white}Please report this bug:"
    $stderr.puts "    #{Tty.em}#{OS::ISSUES_URL}#{Tty.reset}"
  end
  $stderr.puts e.backtrace
  exit 1
else
  exit 1 if Homebrew.failed?
end
