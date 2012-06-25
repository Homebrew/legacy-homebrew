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
  title = title.to_s[0, Tty.width - 4] if $stdout.tty? unless ARGV.verbose?
  puts "#{Tty.blue}==>#{Tty.white} #{title}#{Tty.reset}"
  puts sput unless sput.empty?
end

def oh1 title
  title = title.to_s[0, Tty.width - 4] if $stdout.tty? unless ARGV.verbose?
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

def ofail error
  onoe error
  Homebrew.failed = true
end

def odie error
  onoe error
  exit 1
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
  args << "--silent" unless $stdout.tty?

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

def which cmd
  path = `/usr/bin/which #{cmd} 2>/dev/null`.chomp
  if path.empty?
    nil
  else
    Pathname.new(path)
  end
end

def which_editor
  editor = ENV['HOMEBREW_EDITOR'] || ENV['EDITOR']
  # If an editor wasn't set, try to pick a sane default
  return editor unless editor.nil?

  # Find Textmate
  return 'mate' if which "mate"
  # Find # BBEdit / TextWrangler
  return 'edit' if which "edit"
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

# Returns array of architectures that the given command or library is built for.
def archs_for_command cmd
  cmd = which(cmd) unless Pathname.new(cmd).absolute?
  Pathname.new(cmd).archs
end

def inreplace path, before=nil, after=nil
  [*path].each do |path|
    f = File.open(path, 'r')
    s = f.read

    if before == nil and after == nil
      s.extend(StringInreplaceExtension)
      yield s
    else
      sub = s.gsub!(before, after)
      if sub.nil?
        opoo "inreplace in '#{path}' failed"
        puts "Expected replacement of '#{before}' with '#{after}'"
      end
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

  def cat
    if mountain_lion?
      :mountainlion
    elsif lion?
      :lion
    elsif snow_leopard?
      :snowleopard
    elsif leopard?
      :leopard
    else
      nil
    end
  end

  def clt_installed?
    # If the command line tools are installed, most unix standard
    # tools, libs and headers are in /usr.
    # Returns true, also for older Xcode/OSX versions that had everything in /usr
    # Beginning with Xcode 4.3, the dev tools are no longer installed
    # in /usr and SDKs no longer in /Developer by default.
    # But Apple provides an optional "Command Line Tools for Xcode" package.
    not clt_version.empty? or dev_tools_path == Pathname.new("/usr/bin")
  end

  def clt_version
    # Version string (a pretty damn long one) of the CLT package.
    # Note, that different ways to install the CLTs lead to different
    # version numbers.
    @clt_version ||= begin
      # CLT installed via stand-alone website download
      clt_pkginfo_stand_alone = `pkgutil --pkg-info com.apple.pkg.DeveloperToolsCLILeo 2>/dev/null`.strip
      # CLT installed via preferences from within Xcode
      clt_pkginfo_from_xcode = `pkgutil --pkg-info com.apple.pkg.DeveloperToolsCLI 2>/dev/null`.strip
      if not clt_pkginfo_stand_alone.empty?
        clt_pkginfo_stand_alone =~ /version: (.*)$/
        $1
      elsif not clt_pkginfo_from_xcode.empty?
        clt_pkginfo_from_xcode =~ /version: (.*)$/
        $1
      else
        # We return "" instead of nil because we want clt_installed? to be true on older Macs.
        # So clt_version.empty? does not mean there are no unix tools in /usr, it just means
        # that the "Command Line Tools for Xcode" package is not installed
        "" # No CLT or recipe available to pkgutil.
      end
    end
  end

  def locate tool
    # Don't call tools (cc, make, strip, etc.) directly!
    # Give the name of the binary you look for as a string to this method
    # in order to get the full path back as a Pathname.
    tool = tool.to_s

    @locate_cache ||= {}
    return @locate_cache[tool] if @locate_cache.has_key? tool

    if File.executable? "/usr/bin/#{tool}"
      path = Pathname.new "/usr/bin/#{tool}"
    elsif not MacOS.xctools_fucked? and system "/usr/bin/xcrun -find #{tool} 1>/dev/null 2>&1"
      # xcrun was provided first with Xcode 4.3 and allows us to proxy
      # tool usage thus avoiding various bugs
      p = `/usr/bin/xcrun -find #{tool}`.chomp
      if File.executable?  p
        path = Pathname.new  p
      else
        path = nil
      end
    else
      # otherwise lets try and figure it out ourselves
      p = "#{MacOS.dev_tools_path}/#{tool}"
      if File.executable?  p
        path = Pathname.new  p
      else
        # This is for the use-case where xcode-select is not set up with
        # Xcode 4.3+. The tools in Xcode 4.3+ are split over two locations,
        # usually xcrun would figure that out for us, but it won't work if
        # xcode-select is not configured properly (i.e. xctools_fucked?).
        p = "#{MacOS.xcode_prefix}/Toolchains/XcodeDefault.xctoolchain/usr/bin/#{tool}"
        if File.executable?  p
          path Pathname.new  p
        else
          path = nil
        end
      end
    end
    @locate_cache[tool] = path
    return path
  end

  def dev_tools_path
    @dev_tools_path ||= if File.exist? "/usr/bin/cc" and File.exist? "/usr/bin/make"
      # probably a safe enough assumption (the unix way)
      Pathname.new "/usr/bin"
    elsif not xctools_fucked?
      # The new way of finding stuff via locate:
      Pathname.new(locate 'make').dirname
    elsif File.exist? "#{xcode_prefix}/usr/bin/make"
      # cc stopped existing with Xcode 4.3, there are c89 and c99 options though
      Pathname.new "#{xcode_prefix}/usr/bin"
    else
      # yes this seems dumb, but we can't throw because the existance of
      # dev tools is not mandatory for installing formula. Eventually we
      # should make formula specify if they need dev tools or not.
      Pathname.new "/usr/bin"
    end
  end

  def xctoolchain_path
    # Beginning with Xcode 4.3, clang and some other tools are located in a xctoolchain dir.
    @xctoolchain_path ||= begin
      path = Pathname.new("#{MacOS.xcode_prefix}/Toolchains/XcodeDefault.xctoolchain")
      if path.exist?
        path
      else
        # ok, there are no Toolchains in xcode_prefix
        # and that's ok as long as everything is in dev_tools_path="/usr/bin" (i.e. clt_installed?)
        nil
      end
    end
  end

  def sdk_path(v=MacOS.version)
    # The path of the MacOSX SDK.
    if not MacOS.xctools_fucked?
      path = `#{locate('xcodebuild')} -version -sdk macosx#{v} Path 2>/dev/null`.chomp
    elsif File.directory? '/Developer/SDKs/MacOS#{v}.sdk'
      # the old default (or wild wild west style)
      path = "/Developer/SDKs/MacOS#{v}.sdk"
    elsif File.directory? "#{xcode_prefix}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX#{v}.sdk"
      # xcode_prefix is pretty smart, so lets look inside to find the sdk
      path = "#{xcode_prefix}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX#{v}.sdk"
    end
    if path.nil? or path.empty? or not File.directory? path
      nil
    else
      Pathname.new path
    end
  end

  def xctools_fucked?
    # Xcode 4.3 tools hang if "/" is set
    @xctools_fucked ||= `/usr/bin/xcode-select -print-path 2>/dev/null`.chomp == "/"
  end

  def default_cc
    cc = locate 'cc'
    Pathname.new(cc).realpath.basename.to_s rescue nil
  end

  def default_compiler
    case default_cc
      when /^gcc/ then :gcc
      when /^llvm/ then :llvm
      when "clang" then :clang
      else
        # guess :(
        if xcode_version >= "4.3"
          :clang
        elsif xcode_version >= "4.2"
          :llvm
        else
          :gcc
        end
    end
  end

  def gcc_42_build_version
    @gcc_42_build_version ||= if File.exist? "#{dev_tools_path}/gcc-4.2" \
      and not Pathname.new("#{dev_tools_path}/gcc-4.2").realpath.basename.to_s =~ /^llvm/
      `#{dev_tools_path}/gcc-4.2 --version` =~ /build (\d{4,})/
      $1.to_i
    end
  end

  def gcc_40_build_version
    @gcc_40_build_version ||= if File.exist? "#{dev_tools_path}/gcc-4.0"
      `#{dev_tools_path}/gcc-4.0 --version` =~ /build (\d{4,})/
      $1.to_i
    end
  end

  def xcode_prefix
    @xcode_prefix ||= begin
      path = `/usr/bin/xcode-select -print-path 2>/dev/null`.chomp
      path = Pathname.new path
      if $?.success? and path.directory? and path.absolute?
        path
      elsif File.directory? '/Developer'
        # we do this to support cowboys who insist on installing
        # only a subset of Xcode
        Pathname.new '/Developer'
      elsif File.directory? '/Applications/Xcode.app/Contents/Developer'
        # fallback for broken Xcode 4.3 installs
        Pathname.new '/Applications/Xcode.app/Contents/Developer'
      else
        # Ask Spotlight where Xcode is. If the user didn't install the
        # helper tools and installed Xcode in a non-conventional place, this
        # is our only option. See: http://superuser.com/questions/390757
        path = `mdfind "kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode'"`.strip
        if path.empty?
          # Xcode 3 had a different identifier
          path = `mdfind "kMDItemCFBundleIdentifier == 'com.apple.Xcode'"`.strip
        end
        path = "#{path}/Contents/Developer"
        if path.empty? or not File.directory? path
          nil
        else
          Pathname.new path
        end
      end
    end
  end

  def xcode_installed?
    # Telling us whether the Xcode.app is installed or not.
    @xcode_installed ||= begin
      if File.directory? '/Applications/Xcode.app'
        true
      elsif File.directory? '/Developer/Applications/Xcode.app' # old style
        true
      elsif not `mdfind "kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode'"`.strip.empty?
        # Xcode 4
        true
      elsif not `mdfind "kMDItemCFBundleIdentifier == 'com.apple.Xcode'"`.strip.empty?
        # Xcode 3
        true
      else
        false
      end
    end
  end


 def xcode_version
    # may return a version string
    # that is guessed based on the compiler, so do not
    # use it in order to check if Xcode is installed.
    @xcode_version ||= begin
      return "0" unless MACOS

      # this shortcut makes xcode_version work for people who don't realise you
      # need to install the CLI tools
      xcode43build = "/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild"
      if File.file? xcode43build
        `#{xcode43build} -version 2>/dev/null` =~ /Xcode (\d(\.\d)*)/
        return $1 if $1
      end

      # Xcode 4.3 xc* tools hang indefinately if xcode-select path is set thus
      raise if `xcode-select -print-path 2>/dev/null`.chomp == "/"

      raise unless which "xcodebuild"
      `xcodebuild -version 2>/dev/null` =~ /Xcode (\d(\.\d)*)/
      raise if $1.nil? or not $?.success?
      $1
    rescue
      # For people who's xcode-select is unset, or who have installed
      # xcode-gcc-installer or whatever other combinations we can try and
      # supprt. See https://github.com/mxcl/homebrew/wiki/Xcode
      case llvm_build_version.to_i
      when 1..2063 then "3.1.0"
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
        case (clang_version.to_f * 10).to_i
        when 0
          "dunno"
        when 1..14
          "3.2.2"
        when 15
          "3.2.4"
        when 16
          "3.2.5"
        when 17..20
          "4.0"
        when 21
          "4.1"
        when 22..30
          "4.2"
        when 31
          "4.3"
        else
          "4.3"
        end
      end
    end
  end

  def llvm_build_version
    # for Xcode 3 on OS X 10.5 this will not exist
    # NOTE may not be true anymore but we can't test
    @llvm_build_version ||= if locate("llvm-gcc")
      `#{locate("llvm-gcc")} --version` =~ /LLVM build (\d{4,})/
      $1.to_i
    end
  end

  def clang_version
    @clang_version ||= if locate("clang")
      `#{locate("clang")} --version` =~ /clang version (\d\.\d)/
      $1
    end
  end

  def clang_build_version
    @clang_build_version ||= if locate("clang")
      `#{locate("clang")} --version` =~ %r[tags/Apple/clang-(\d{2,})]
      $1.to_i
    end
  end

  def x11_installed?
    # Even if only Xcode (without CLT) is installed, this dylib is there.
    Pathname.new('/usr/X11/lib/libpng.dylib').exist?
  end

  def macports_or_fink_installed?
    # See these issues for some history:
    # http://github.com/mxcl/homebrew/issues/#issue/13
    # http://github.com/mxcl/homebrew/issues/#issue/41
    # http://github.com/mxcl/homebrew/issues/#issue/48
    return false unless MACOS

    %w[port fink].each do |ponk|
      path = which(ponk)
      return ponk unless path.nil?
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
    10.7 <= MACOS_VERSION # Actually Lion or newer
  end

  def mountain_lion?
    10.8 <= MACOS_VERSION # Actually Mountain Lion or newer
  end

  def prefer_64_bit?
    Hardware.is_64_bit? and not leopard?
  end

  StandardCompilers = {
    "3.1.4" => {:gcc_40_build_version=>5493, :gcc_42_build_version=>5577},
    "3.2.6" => {:gcc_40_build_version=>5494, :gcc_42_build_version=>5666, :llvm_build_version=>2335, :clang_version=>"1.7", :clang_build_version=>77},
    "4.0" => {:gcc_40_build_version=>5494, :gcc_42_build_version=>5666, :llvm_build_version=>2335, :clang_version=>"2.0", :clang_build_version=>137},
    "4.0.1" => {:gcc_40_build_version=>5494, :gcc_42_build_version=>5666, :llvm_build_version=>2335, :clang_version=>"2.0", :clang_build_version=>137},
    "4.0.2" => {:gcc_40_build_version=>5494, :gcc_42_build_version=>5666, :llvm_build_version=>2335, :clang_version=>"2.0", :clang_build_version=>137},
    "4.2" => {:llvm_build_version=>2336, :clang_version=>"3.0", :clang_build_version=>211},
    "4.3" => {:llvm_build_version=>2336, :clang_version=>"3.1", :clang_build_version=>318},
    "4.3.1" => {:llvm_build_version=>2336, :clang_version=>"3.1", :clang_build_version=>318},
    "4.3.2" => {:llvm_build_version=>2336, :clang_version=>"3.1", :clang_build_version=>318},
    "4.3.3" => {:llvm_build_version=>2336, :clang_version=>"3.1", :clang_build_version=>318}
  }

  def compilers_standard?
    xcode = MacOS.xcode_version
    # Assume compilers are okay if Xcode version not in hash
    return true unless StandardCompilers.keys.include? xcode

    StandardCompilers[xcode].all? {|k,v| MacOS.send(k) == v}
  end
end

module GitHub extend self
  def issues_for_formula name
    # bit basic as depends on the issue at github having the exact name of the
    # formula in it. Which for stuff like objective-caml is unlikely. So we
    # really should search for aliases too.

    name = f.name if Formula === name

    require 'open-uri'
    require 'vendor/multi_json'

    issues = []

    uri = URI.parse("https://api.github.com/legacy/issues/search/mxcl/homebrew/open/#{name}")

    open uri do |f|
      MultiJson.decode(f.read)['issues'].each do |issue|
        # don't include issues that just refer to the tool in their body
        issues << issue['html_url'] if issue['title'].include? name
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
    uri = URI.parse("https://api.github.com/legacy/issues/search/mxcl/homebrew/open/#{query}")

    open uri do |f|
      MultiJson.decode(f.read)['issues'].each do |pull|
        yield pull['pull_request_url'] if rx.match pull['title'] and pull['pull_request_url']
      end
    end
  rescue
    nil
  end
end
