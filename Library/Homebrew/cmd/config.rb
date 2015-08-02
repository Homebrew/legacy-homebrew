require 'hardware'
require "software_spec"

module Homebrew
  def config
    dump_verbose_config
  end

  def llvm
    @llvm ||= MacOS.llvm_build_version
  end

  def gcc_42
    @gcc_42 ||= MacOS.gcc_42_build_version
  end

  def gcc_40
    @gcc_40 ||= MacOS.gcc_40_build_version
  end

  def clang
    @clang ||= MacOS.clang_version
  end

  def clang_build
    @clang_build ||= MacOS.clang_build_version
  end

  def xcode
    if instance_variable_defined?(:@xcode)
      @xcode
    elsif MacOS::Xcode.installed?
      @xcode = MacOS::Xcode.version
      @xcode += " => #{MacOS::Xcode.prefix}" unless MacOS::Xcode.default_prefix?
      @xcode
    end
  end

  def clt
    if instance_variable_defined?(:@clt)
      @clt
    elsif MacOS::CLT.installed? && MacOS::Xcode.version >= "4.3"
      @clt = MacOS::CLT.version
    end
  end

  def head
    Homebrew.git_head || "(none)"
  end

  def last_commit
    Homebrew.git_last_commit || "never"
  end

  def origin
    origin = HOMEBREW_REPOSITORY.cd do
      `git config --get remote.origin.url 2>/dev/null`.chomp
    end
    if origin.empty? then "(none)" else origin end
  end

  def describe_path path
    return "N/A" if path.nil?
    realpath = path.realpath
    if realpath == path then path else "#{path} => #{realpath}" end
  end

  def describe_x11
    return "N/A" unless MacOS::XQuartz.installed?
    return "#{MacOS::XQuartz.version} => #{describe_path(MacOS::XQuartz.prefix)}"
  end

  def describe_perl
    describe_path(which 'perl')
  end

  def describe_python
    python = which 'python'
    if %r{/shims/python$} =~ python && which('pyenv')
      "#{python} => #{Pathname.new(`pyenv which python`.strip).realpath}" rescue describe_path(python)
    else
      describe_path(python)
    end
  end

  def describe_ruby
    ruby = which 'ruby'
    if %r{/shims/ruby$} =~ ruby && which('rbenv')
      "#{ruby} => #{Pathname.new(`rbenv which ruby`.strip).realpath}" rescue describe_path(ruby)
    else
      describe_path(ruby)
    end
  end

  def hardware
    "CPU: #{Hardware.cores_as_words}-core #{Hardware::CPU.bits}-bit #{Hardware::CPU.family}"
  end

  def kernel
    `uname -m`.chomp
  end

  def macports_or_fink
    @ponk ||= MacOS.macports_or_fink
    @ponk.join(", ") unless @ponk.empty?
  end

  def describe_system_ruby
    s = ""
    case RUBY_VERSION
    when /^1\.[89]/, /^2\.0/
      s << "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
    else
      s << RUBY_VERSION
    end

    if RUBY_PATH.to_s !~ %r[^/System/Library/Frameworks/Ruby.framework/Versions/[12]\.[089]/usr/bin/ruby]
      s << " => #{RUBY_PATH}"
    end
    s
  end

  def describe_java
    if which("java").nil?
      "N/A"
    elsif !(`/usr/libexec/java_home --failfast &>/dev/null` && $?.success?)
      "N/A"
    else
      java = `java -version 2>&1`.lines.first.chomp
      java =~ /java version "(.+?)"/ ? $1 : java
    end
  end

  def dump_verbose_config(f=$stdout)
    f.puts "HOMEBREW_VERSION: #{HOMEBREW_VERSION}"
    f.puts "ORIGIN: #{origin}"
    f.puts "HEAD: #{head}"
    f.puts "Last commit: #{last_commit}"
    f.puts "HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}"
    f.puts "HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}"
    f.puts "HOMEBREW_BOTTLE_DOMAIN: #{BottleSpecification::DEFAULT_DOMAIN}"
    f.puts hardware
    f.puts "OS X: #{MACOS_FULL_VERSION}-#{kernel}"
    f.puts "Xcode: #{xcode ? xcode : "N/A"}"
    f.puts "CLT: #{clt ? clt : "N/A"}"
    f.puts "GCC-4.0: build #{gcc_40}" if gcc_40
    f.puts "GCC-4.2: build #{gcc_42}" if gcc_42
    f.puts "LLVM-GCC: build #{llvm}"  if llvm
    f.puts "Clang: #{clang ? "#{clang} build #{clang_build}" : "N/A"}"
    f.puts "MacPorts/Fink: #{macports_or_fink}" if macports_or_fink
    f.puts "X11: #{describe_x11}"
    f.puts "System Ruby: #{describe_system_ruby}"
    f.puts "Perl: #{describe_perl}"
    f.puts "Python: #{describe_python}"
    f.puts "Ruby: #{describe_ruby}"
    f.puts "Java: #{describe_java}"
  end
end
