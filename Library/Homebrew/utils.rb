class ExecutionError <RuntimeError
  attr :exit_status
  attr :command

  def initialize cmd, args = [], es = nil
    @command = cmd
    super "Failure while executing: #{cmd} #{pretty(args)*' '}"
    @exit_status = es.exitstatus rescue 1
  end

  def was_running_configure?
    @command == './configure'
  end

  private

  def pretty args
    args.collect do |arg|
      if arg.to_s.include? ' '
        "'#{ arg.gsub "'", "\\'" }'"
      else
        arg
      end
    end
  end
end

class BuildError <ExecutionError
  attr :env

  def initialize cmd, args = [], es = nil
    super
    @env = ENV.to_hash
  end
end

class Tty
  class <<self
    def blue; bold 34; end
    def white; bold 39; end
    def red; underline 31; end
    def yellow; underline 33 ; end
    def reset; escape 0; end
    def em; underline 39; end
    
  private
    def color n
      escape "0;#{n}"
    end
    def bold n
      escape "1;#{n}"
    end
    def underline n
      escape "4;#{n}"
    end
    def escape n
      "\033[#{n}m" if $stdout.tty?
    end
  end
end

# args are additional inputs to puts until a nil arg is encountered
def ohai title, *sput
  title = title.to_s[0, `/usr/bin/tput cols`.strip.to_i-4] unless ARGV.verbose?
  puts "#{Tty.blue}==>#{Tty.white} #{title}#{Tty.reset}"
  puts sput unless sput.empty?
end

def opoo warning
  puts "#{Tty.red}Warning#{Tty.reset}: #{warning}"
end

def onoe error
  lines = error.to_s.split'\n'
  puts "#{Tty.red}Error#{Tty.reset}: #{lines.shift}"
  puts lines unless lines.empty?
end

def pretty_duration s
  return "2 seconds" if s < 3 # avoids the plural problem ;)
  return "#{s.to_i} seconds" if s < 120
  return "%.1f minutes" % (s/60)
end

def interactive_shell f=nil
  unless f.nil?
    ENV['HOMEBREW_DEBUG_PREFIX'] = f.prefix
    ENV['HOMEBREW_DEBUG_INSTALL'] = f.name
  end

  fork {exec ENV['SHELL'] }
  Process.wait
  unless $?.success?
    puts "Aborting due to non-zero exit status"
    exit $?
  end
end

module Homebrew
  def self.system cmd, *args
    puts "#{cmd} #{args*' '}" if ARGV.verbose?
    fork do
      yield if block_given?
      args.collect!{|arg| arg.to_s}
      exec(cmd, *args) rescue nil
      exit! 1 # never gets here unless exec failed
    end
    Process.wait
    $?.success?
  end
end

# Kernel.system but with exceptions
def safe_system cmd, *args
  raise ExecutionError.new(cmd, args, $?) unless Homebrew.system(cmd, *args)
end

# prints no output
def quiet_system cmd, *args
  Homebrew.system(cmd, *args) do
    $stdout.close
    $stderr.close
  end
end

def curl *args
  safe_system 'curl', '-f#LA', HOMEBREW_USER_AGENT, *args unless args.empty?
end

def puts_columns items, cols = 4
  return if items.empty?

  if $stdout.tty?
    # determine the best width to display for different console sizes
    console_width = `/bin/stty size`.chomp.split(" ").last.to_i
    console_width = 80 if console_width <= 0
    longest = items.sort_by { |item| item.length }.last
    optimal_col_width = (console_width.to_f / (longest.length + 2).to_f).floor
    cols = optimal_col_width > 1 ? optimal_col_width : 1

    IO.popen("/usr/bin/pr -#{cols} -t -w#{console_width}", "w"){|io| io.puts(items) }
  else
    puts items
  end
end

def exec_editor *args
  editor = ENV['HOMEBREW_EDITOR'] || ENV['EDITOR']
  if editor.nil?
    if system "/usr/bin/which -s mate"
      # TextMate
      editor='mate'
    elsif system "/usr/bin/which -s edit"
      # BBEdit / TextWrangler
      editor='edit'
    else
      # Default to vim
      editor='/usr/bin/vim'
    end
  end
  # we split the editor because especially on mac "mate -w" is common
  # but we still want to use the comma-delimited version of exec because then
  # we don't have to escape args, and escaping 100% is tricky
  exec(*(editor.split+args))
end

# GZips the given path, and returns the gzipped file
def gzip *paths
  paths.collect do |path|
    system "/usr/bin/gzip", path
    Pathname.new(path+".gz")
  end
end

module ArchitectureListExtension
  def universal?
    self.include? :i386 and self.include? :x86_64
  end
end

# Returns array of architectures that the given command or library is built for.
def archs_for_command cmd
  cmd = cmd.to_s # If we were passed a Pathname, turn it into a string.
  cmd = `/usr/bin/which #{cmd}` unless Pathname.new(cmd).absolute?
  cmd.gsub! ' ', '\\ '  # Escape spaces in the filename.

  archs = IO.popen("/usr/bin/file -L #{cmd}").readlines.inject([]) do |archs, line|
    case line
    when /Mach-O (executable|dynamically linked shared library) ppc/
      archs << :ppc7400
    when /Mach-O 64-bit (executable|dynamically linked shared library) ppc64/
      archs << :ppc64
    when /Mach-O (executable|dynamically linked shared library) i386/
      archs << :i386
    when /Mach-O 64-bit (executable|dynamically linked shared library) x86_64/
      archs << :x86_64
    else
      archs
    end
  end
  archs.extend(ArchitectureListExtension)
end

# String extensions added by inreplace below.
module HomebrewInreplaceExtension
  # Looks for Makefile style variable defintions and replaces the
  # value with "new_value", or removes the definition entirely.
  def change_make_var! flag, new_value
    new_value = "#{flag}=#{new_value}"
    gsub! Regexp.new("^#{flag}[ \\t]*=[ \\t]*(.*)$"), new_value
  end
  # Removes variable assignments completely.
  def remove_make_var! flags
    flags.each do |flag|
      # Also remove trailing \n, if present.
      gsub! Regexp.new("^#{flag}[ \\t]*=(.*)$\n?"), ""
    end
  end
  # Finds the specified variable
  def get_make_var flag
    m = match Regexp.new("^#{flag}[ \\t]*=[ \\t]*(.*)$")
    return m[1] if m
    return nil
  end
end

def inreplace path, before=nil, after=nil
  [*path].each do |path|
    f = File.open(path, 'r')
    s = f.read

    if before == nil and after == nil
      s.extend(HomebrewInreplaceExtension)
      yield s
    else
      s.gsub!(before, after)
    end

    f.reopen(path, 'w').write(s)
    f.close
  end
end

def ignore_interrupts
  std_trap = trap("INT") {}
  yield
ensure
  trap("INT", std_trap)
end

def nostdout
  if ARGV.verbose?
    yield
  else
    begin
      require 'stringio'
      real_stdout = $stdout
      $stdout = StringIO.new
      yield
    ensure
      $stdout = real_stdout
    end
  end
end

def dump_build_env env
  puts "\"--use-llvm\" was specified" if ARGV.include? '--use-llvm'

  %w[ CC CXX LD ].each do |k|
    value = env[k]
    if value
      results = value
      if File.exists? value and File.symlink? value
        target = Pathname.new(value)
        results += " => #{target.realpath}"
      end
      puts "#{k}: #{results}"
    end
  end

  %w[ CFLAGS CXXFLAGS CPPFLAGS LDFLAGS MACOSX_DEPLOYMENT_TARGET MAKEFLAGS PKG_CONFIG_PATH
      HOMEBREW_DEBUG HOMEBREW_VERBOSE HOMEBREW_USE_LLVM HOMEBREW_SVN ].each do |k|
    value = env[k]
    puts "#{k}: #{value}" if value
  end
end

def x11_installed?
  Pathname.new('/usr/X11/lib/libpng.dylib').exist?
end