require 'hardware'

module Homebrew
  def config
    dump_verbose_config(STDOUT)
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
    describe_path(which 'python')
  end

  def describe_ruby
    describe_path(which 'ruby')
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

  # we try to keep output minimal
  def dump_build_config(f=STDOUT)
    f.puts "HOMEBREW_VERSION: #{HOMEBREW_VERSION}"
    f.puts "HEAD: #{head}"
    f.puts "HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}" if HOMEBREW_PREFIX.to_s != "/usr/local"
    f.puts "HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}" if HOMEBREW_CELLAR.to_s != "#{HOMEBREW_PREFIX}/Cellar"
    f.puts hardware
    f.puts "OS X: #{MACOS_FULL_VERSION}-#{kernel}"
    f.puts "Xcode: #{xcode}" if xcode
    f.puts "CLT: #{clt}" if clt

    ruby_version = MacOS.version >= "10.9" ? "2.0" : "1.8"
    if RUBY_VERSION[/\d\.\d/] != ruby_version
      f.puts "#{RUBY_PATH}:\n  #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}"
    end

    unless MacOS.compilers_standard?
      f.puts "GCC-4.0: build #{gcc_40}" if gcc_40
      f.puts "GCC-4.2: build #{gcc_42}" if gcc_42
      f.puts "LLVM-GCC: build #{llvm}"  if llvm
      f.puts "Clang: #{clang ? "#{clang} build #{clang_build}" : "N/A"}"
    end

    f.puts "MacPorts/Fink: #{macports_or_fink}" if macports_or_fink
    f.puts "X11: #{describe_x11}"
  end

  def dump_verbose_config(f)
    f.puts "HOMEBREW_VERSION: #{HOMEBREW_VERSION}"
    f.puts "ORIGIN: #{origin}"
    f.puts "HEAD: #{head}"
    f.puts "HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}"
    f.puts "HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}"
    f.puts hardware
    f.puts "OS X: #{MACOS_FULL_VERSION}-#{kernel}"
    f.puts "Xcode: #{xcode}" if xcode
    f.puts "CLT: #{clt}" if clt
    f.puts "GCC-4.0: build #{gcc_40}" if gcc_40
    f.puts "GCC-4.2: build #{gcc_42}" if gcc_42
    f.puts "LLVM-GCC: build #{llvm}"  if llvm
    f.puts "Clang: #{clang ? "#{clang} build #{clang_build}" : "N/A"}"
    f.puts "MacPorts/Fink: #{macports_or_fink}" if macports_or_fink
    f.puts "X11: #{describe_x11}"
    f.puts "System Ruby: #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}"
    f.puts "Perl: #{describe_perl}"
    f.puts "Python: #{describe_python}"
    f.puts "Ruby: #{describe_ruby}"
  end
end
