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

  def describe_xcode
    @describe_xcode ||= begin
      default_prefix = case MacOS.version
        when 10.5, 10.6 then '/Developer'
        else '/Applications/Xcode.app/Contents/Developer'
        end

      guess = '(guessed)' unless MacOS::Xcode.installed?
      prefix = if MacOS::Xcode.installed?
        "=> #{MacOS::Xcode.prefix}" unless MacOS::Xcode.prefix.to_s == default_prefix
      end

      [MacOS::Xcode.version, guess, prefix].compact.join(' ')
    end
  end

  def describe_clt
    @describe_clt ||= if MacOS::CLT.installed? then MacOS::CLT.version else 'N/A' end
  end

  def head
    head = HOMEBREW_REPOSITORY.cd do
      `git rev-parse --verify -q HEAD 2>/dev/null`.chomp
    end
    if head.empty? then "(none)" else head end
  end

  def describe_path path
    return "N/A" if path.nil?
    realpath = path.realpath
    if realpath == path then path else "#{path} => #{realpath}" end
  end

  def describe_x11
    return "N/A" unless MacOS::XQuartz.installed?
    return "#{MacOS::XQuartz.version} in " + describe_path(MacOS::XQuartz.prefix)
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

  # we try to keep output minimal
  def dump_build_config
    puts "HOMEBREW_VERSION: #{HOMEBREW_VERSION}"
    puts "HEAD: #{head}"
    puts "HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}" if HOMEBREW_PREFIX.to_s != "/usr/local"
    puts "HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}" if HOMEBREW_CELLAR.to_s != "#{HOMEBREW_PREFIX}/Cellar"
    puts hardware
    puts "OS X: #{MACOS_FULL_VERSION}-#{kernel}"
    puts "Xcode: #{describe_xcode}"
    puts "CLT: #{describe_clt}" if MacOS::Xcode.version.to_f >= 4.3
    puts "/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby:\n  #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}" if RUBY_VERSION.to_f != 1.8

    unless MacOS.compilers_standard?
      puts "GCC-4.0: build #{gcc_40}" if gcc_40
      puts "GCC-4.2: build #{gcc_42}" if gcc_42
      puts "LLVM-GCC: #{llvm ? "build #{llvm}" : "N/A"}"
      puts "Clang: #{clang ? "#{clang} build #{clang_build}" : "N/A"}"
    end

    ponk = macports_or_fink_installed?
    puts "MacPorts/Fink: #{ponk}" if ponk

    puts "X11: #{describe_x11}"
  end

  def dump_verbose_config
    puts "HOMEBREW_VERSION: #{HOMEBREW_VERSION}"
    puts "HEAD: #{head}"
    puts "HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}"
    puts "HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}"
    puts hardware
    puts "OS X: #{MACOS_FULL_VERSION}-#{kernel}"
    puts "Xcode: #{describe_xcode}"
    puts "CLT: #{describe_clt}\n" if MacOS::Xcode.version.to_f >= 4.3
    puts "GCC-4.0: build #{gcc_40}" if gcc_40
    puts "GCC-4.2: build #{gcc_42}" if gcc_42
    puts "LLVM-GCC: #{llvm ? "build #{llvm}" : "N/A"}"
    puts "Clang: #{clang ? "#{clang} build #{clang_build}" : "N/A"}"
    ponk = macports_or_fink_installed?
    puts "MacPorts or Fink? #{ponk}" if ponk
    puts "System Ruby: #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}"
    puts "Perl: #{describe_perl}"
    puts "Python: #{describe_python}"
    puts "Ruby: #{describe_ruby}"
  end

  def dump_c1
    stuff = []
    print "#{HOMEBREW_PREFIX}-#{HOMEBREW_VERSION} "
    print MACOS_FULL_VERSION
    print "-#{kernel}" if MacOS.version < :lion
    print ' '
    if MacOS::Xcode.version > "4.3"
      print MacOS::Xcode.prefix unless MacOS::Xcode.prefix.to_s =~ %r{^/Applications/Xcode.app}
    else
      print MacOS::Xcode.prefix unless MacOS::Xcode.prefix.to_s =~ %r{^/Developer}
    end
    print "#{MacOS::Xcode.version}"
    print "-noclt" unless MacOS::CLT.installed?
    print " clang-#{clang_build} llvm-#{llvm} "
    print "#{MacOS::XQuartz.prefix}-#{MacOS::XQuartz.version}" if MacOS::XQuartz.prefix
    puts
  end
end
