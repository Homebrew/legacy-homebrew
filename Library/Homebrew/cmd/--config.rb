require 'hardware'

module Homebrew extend self
  def __config
    if ARGV.first == '-1'
      dump_c1
    else
      dump_verbose_config
    end
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
    elsif MacOS::CLT.installed? && MacOS::Xcode.version.to_f >= 4.3
      @clt = MacOS::CLT.version
    end
  end

  def head
    head = HOMEBREW_REPOSITORY.cd do
      `git rev-parse --verify -q HEAD 2>/dev/null`.chomp
    end
    if head.empty? then "(none)" else head end
  end

  def origin
    origin = HOMEBREW_REPOSITORY.cd do
      `git config --get remote.origin.url`.chomp
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
    return "#{MacOS::XQuartz.version} => " + describe_path(MacOS::XQuartz.prefix)
  end

  def describe_perl
    describe_path(which 'perl')
  end

  def describe_python
    describe_path(which 'python')
  end

  def describe_ruby
    describe_path(which 'ruby')
  end

  def hardware
    "CPU: #{Hardware.cores_as_words}-core #{Hardware.bits}-bit #{Hardware.intel_family}"
  end

  def kernel
    `uname -m`.chomp
  end

  def macports_or_fink
    @ponk ||= MacOS.macports_or_fink
    @ponk.join(", ") unless @ponk.empty?
  end

  # we try to keep output minimal
  def dump_build_config
    puts "HOMEBREW_VERSION: #{HOMEBREW_VERSION}"
    puts "HEAD: #{head}"
    puts "HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}" if HOMEBREW_PREFIX.to_s != "/usr/local"
    puts "HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}" if HOMEBREW_CELLAR.to_s != "#{HOMEBREW_PREFIX}/Cellar"
    puts hardware
    puts "OS X: #{MACOS_FULL_VERSION}-#{kernel}"
    puts "Xcode: #{xcode}" if xcode
    puts "CLT: #{clt}" if clt
    puts "/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby:\n  #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}" if RUBY_VERSION.to_f != 1.8

    unless MacOS.compilers_standard?
      puts "GCC-4.0: build #{gcc_40}" if gcc_40
      puts "GCC-4.2: build #{gcc_42}" if gcc_42
      puts "LLVM-GCC: #{llvm ? "build #{llvm}" : "N/A"}"
      puts "Clang: #{clang ? "#{clang} build #{clang_build}" : "N/A"}"
    end

    puts "MacPorts/Fink: #{macports_or_fink}" if macports_or_fink

    puts "X11: #{describe_x11}"
  end

  def write_build_config f
    stdout = $stdout
    $stdout = f
    Homebrew.dump_build_config
  ensure
    $stdout = stdout
  end

  def dump_verbose_config
    puts "HOMEBREW_VERSION: #{HOMEBREW_VERSION}"
    puts "ORIGIN: #{origin}"
    puts "HEAD: #{head}"
    puts "HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}"
    puts "HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}"
    puts hardware
    puts "OS X: #{MACOS_FULL_VERSION}-#{kernel}"
    puts "Xcode: #{xcode}" if xcode
    puts "CLT: #{clt}" if clt
    puts "GCC-4.0: build #{gcc_40}" if gcc_40
    puts "GCC-4.2: build #{gcc_42}" if gcc_42
    puts "LLVM-GCC: #{llvm ? "build #{llvm}" : "N/A"}"
    puts "Clang: #{clang ? "#{clang} build #{clang_build}" : "N/A"}"
    puts "MacPorts/Fink: #{macports_or_fink}" if macports_or_fink
    puts "X11: #{describe_x11}"
    puts "System Ruby: #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}"
    puts "Perl: #{describe_perl}"
    puts "Python: #{describe_python}"
    puts "Ruby: #{describe_ruby}"
  end

  def dump_c1
    print "#{HOMEBREW_PREFIX}-#{HOMEBREW_VERSION} "
    print MACOS_FULL_VERSION
    print "-#{kernel}" if MacOS.version < :lion
    print ' '
    print MacOS::Xcode.prefix unless MacOS::Xcode.default_prefix?
    print "#{MacOS::Xcode.version}"
    print "-noclt" unless MacOS::CLT.installed?
    print " clang-#{clang_build} llvm-#{llvm} "
    print "#{MacOS::XQuartz.prefix}-#{MacOS::XQuartz.version}" if MacOS::XQuartz.prefix
    puts
  end
end
