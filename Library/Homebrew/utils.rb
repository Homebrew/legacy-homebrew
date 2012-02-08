require 'pathname'
require 'exceptions'

class Tty
  class <<self
    def blue; bold 34; end
    def white; bold 39; end
    def red; underline 31; end
    def yellow; underline 33 ; end
    def reset; escape 0; end
    def em; underline 39; end
    def green; color 92 end

    def width
      `/usr/bin/tput cols`.strip.to_i
    end

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
  title = title.to_s[0, Tty.width - 4] unless ARGV.verbose?
  puts "#{Tty.blue}==>#{Tty.white} #{title}#{Tty.reset}"
  puts sput unless sput.empty?
end

def oh1 title
  title = title.to_s[0, Tty.width - 4] unless ARGV.verbose?
  puts "#{Tty.green}==> #{Tty.reset}#{title}"
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
  unless Homebrew.system cmd, *args
    args = args.map{ |arg| arg.to_s.gsub " ", "\\ " } * " "
    raise ErrorDuringExecution, "Failure while executing: #{cmd} #{args}"
  end
end

# prints no output
def quiet_system cmd, *args
  Homebrew.system(cmd, *args) do
    $stdout.close
    $stderr.close
  end
end

def curl *args
  curl = Pathname.new '/usr/bin/curl'
  raise "#{curl} is not executable" unless curl.exist? and curl.executable?

  args = [HOMEBREW_CURL_ARGS, HOMEBREW_USER_AGENT, *args]
  # See https://github.com/mxcl/homebrew/issues/6103
  args << "--insecure" if MacOS.version < 10.6
  args << "--verbose" if ENV['HOMEBREW_CURL_VERBOSE']

  safe_system curl, *args
end

def puts_columns items, star_items=[]
  return if items.empty?

  if star_items && star_items.any?
    items = items.map{|item| star_items.include?(item) ? "#{item}*" : item}
  end

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

def which_editor
  editor = ENV['HOMEBREW_EDITOR'] || ENV['EDITOR']
  # If an editor wasn't set, try to pick a sane default
  return editor unless editor.nil?

  # Find Textmate
  return 'mate' if system "/usr/bin/which -s mate"
  # Find # BBEdit / TextWrangler
  return 'edit' if system "/usr/bin/which -s edit"
  # Default to vim
  return '/usr/bin/vim'
end

def exec_editor *args
  return if args.to_s.empty?

  # Invoke bash to evaluate env vars in $EDITOR
  # This also gets us proper argument quoting.
  # See: https://github.com/mxcl/homebrew/issues/5123
  system "bash", "-c", which_editor + ' "$@"', "--", *args
end

# GZips the given paths, and returns the gzipped paths
def gzip *paths
  paths.collect do |path|
    system "/usr/bin/gzip", path
    Pathname.new("#{path}.gz")
  end
end

module ArchitectureListExtension
  def universal?
    self.include? :i386 and self.include? :x86_64
  end

  def remove_ppc!
    self.delete :ppc7400
    self.delete :ppc64
  end

  def as_arch_flags
    self.collect{ |a| "-arch #{a}" }.join(' ')
  end
end

# Returns array of architectures that the given command or library is built for.
def archs_for_command cmd
  cmd = cmd.to_s # If we were passed a Pathname, turn it into a string.
  cmd = `/usr/bin/which #{cmd}` unless Pathname.new(cmd).absolute?
  cmd.gsub! ' ', '\\ '  # Escape spaces in the filename.

  lines = `/usr/bin/file -L #{cmd}`
  archs = lines.to_a.inject([]) do |archs, line|
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

def inreplace path, before=nil, after=nil
  [*path].each do |path|
    f = File.open(path, 'r')
    s = f.read

    if before == nil and after == nil
      s.extend(StringInreplaceExtension)
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

module MacOS extend self
  def version
    MACOS_VERSION
  end

  def default_cc
    Pathname.new("/usr/bin/cc").realpath.basename.to_s
  end

  def default_compiler
    case default_cc
      when /^gcc/ then :gcc
      when /^llvm/ then :llvm
      when "clang" then :clang
      else :gcc # a hack, but a sensible one prolly
    end
  end

  def gcc_42_build_version
    @gcc_42_build_version ||= if File.exist? "/usr/bin/gcc-4.2" \
      and not Pathname.new("/usr/bin/gcc-4.2").realpath.basename.to_s =~ /^llvm/
      `/usr/bin/gcc-4.2 --version` =~ /build (\d{4,})/
      $1.to_i
    end
  end

  def gcc_40_build_version
    @gcc_40_build_version ||= if File.exist? "/usr/bin/gcc-4.0"
      `/usr/bin/gcc-4.0 --version` =~ /build (\d{4,})/
      $1.to_i
    end
  end

  # usually /Developer
  def xcode_prefix
    @xcode_prefix ||= begin
      path = `/usr/bin/xcode-select -print-path 2>&1`.chomp
      path = Pathname.new path
      if path.directory? and path.absolute?
        path
      elsif File.directory? '/Developer'
        # we do this to support cowboys who insist on installing
        # only a subset of Xcode
        Pathname.new '/Developer'
      else
        nil
      end
    end
  end

  def xcode_version
    @xcode_version ||= begin
      raise unless system "/usr/bin/which -s xcodebuild"
      `xcodebuild -version 2>&1` =~ /Xcode (\d(\.\d)*)/
      raise if $1.nil?
      $1
    rescue
      # for people who don't have xcodebuild installed due to using
      # some variety of minimal installer, let's try and guess their
      # Xcode version
      case llvm_build_version.to_i
      when 0..2063 then "3.1.0"
      when 2064..2065 then "3.1.4"
      when 2366..2325
        # we have no data for this range so we are guessing
        "3.2.0"
      when 2326
        # also applies to "3.2.3"
        "3.2.4"
      when 2327..2333 then "3.2.5"
      when 2335
        # this build number applies to 3.2.6, 4.0 and 4.1
        # https://github.com/mxcl/homebrew/wiki/Xcode
        "4.0"
      else
        "4.2"
      end
    end
  end

  def llvm_build_version
    # for Xcode 3 on OS X 10.5 this will not exist
    # NOTE may not be true anymore but we can't test
    @llvm_build_version ||= if File.exist? "/usr/bin/llvm-gcc"
      `/usr/bin/llvm-gcc --version` =~ /LLVM build (\d{4,})/
      $1.to_i
    end
  end

  def clang_version
    @clang_version ||= if File.exist? "/usr/bin/clang"
      `/usr/bin/clang --version` =~ /clang version (\d\.\d)/
      $1
    end
  end

  def clang_build_version
    @clang_build_version ||= if File.exist? "/usr/bin/clang"
      `/usr/bin/clang --version` =~ %r[tags/Apple/clang-(\d{2,})]
      $1.to_i
    end
  end

  def x11_installed?
    Pathname.new('/usr/X11/lib/libpng.dylib').exist?
  end

  def macports_or_fink_installed?
    # See these issues for some history:
    # http://github.com/mxcl/homebrew/issues/#issue/13
    # http://github.com/mxcl/homebrew/issues/#issue/41
    # http://github.com/mxcl/homebrew/issues/#issue/48

    %w[port fink].each do |ponk|
      path = `/usr/bin/which -s #{ponk}`
      return ponk unless path.empty?
    end

    # we do the above check because macports can be relocated and fink may be
    # able to be relocated in the future. This following check is because if
    # fink and macports are not in the PATH but are still installed it can
    # *still* break the build -- because some build scripts hardcode these paths:
    %w[/sw/bin/fink /opt/local/bin/port].each do |ponk|
      return ponk if File.exist? ponk
    end

    # finally, sometimes people make their MacPorts or Fink read-only so they
    # can quickly test Homebrew out, but still in theory obey the README's
    # advise to rename the root directory. This doesn't work, many build scripts
    # error out when they try to read from these now unreadable directories.
    %w[/sw /opt/local].each do |path|
      path = Pathname.new(path)
      return path if path.exist? and not path.readable?
    end

    false
  end

  def leopard?
    10.5 == MACOS_VERSION
  end

  def snow_leopard?
    10.6 <= MACOS_VERSION # Actually Snow Leopard or newer
  end

  def lion?
    10.7 <= MACOS_VERSION #Actually Lion or newer
  end

  def prefer_64_bit?
    Hardware.is_64_bit? and 10.6 <= MACOS_VERSION
  end

  def bottles_supported?
    lion? and HOMEBREW_PREFIX.to_s == '/usr/local' and HOMEBREW_CELLAR.to_s == '/usr/local/Cellar'
  end
end

module GitHub extend self
  def issues_for_formula name
    # bit basic as depends on the issue at github having the exact name of the
    # formula in it. Which for stuff like objective-caml is unlikely. So we
    # really should search for aliases too.

    name = f.name if Formula === name

    require 'open-uri'
    require 'yaml'

    issues = []

    open "http://github.com/api/v2/yaml/issues/search/mxcl/homebrew/open/#{name}" do |f|
      yaml = YAML::load(f.read);
      yaml['issues'].each do |issue|
        # don't include issues that just refer to the tool in their body
        if issue['title'].include? name
          issues << issue['html_url']
        end
      end
    end

    issues
  rescue
    []
  end

  def find_pull_requests rx
    require 'open-uri'
    require 'vendor/multi_json'

    query = rx.source.delete('.*').gsub('\\', '')
    uri = URI.parse("http://github.com/api/v2/json/issues/search/mxcl/homebrew/open/#{query}")

    open uri do |f|
      MultiJson.decode(f.read)["issues"].each do |pull|
        yield pull['pull_request_url'] if rx.match pull['title'] and pull["pull_request_url"]
      end
    end
  rescue
    nil
  end
end
