require 'hardware'

module Homebrew extend self
  def __config
    puts config_s
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

  def xcode_version
    @xcode_version || MacOS.xcode_version
  end

  def sha
    sha = HOMEBREW_REPOSITORY.cd do
      `git rev-parse --verify -q HEAD 2>/dev/null`.chomp
    end
    if sha.empty? then "(none)" else sha end
  end

  def describe_x11
    return "N/A" unless x11_installed?
    return case x11_path = Pathname.new("/usr/X11").realpath.to_s
    when "/usr/X11" then "/usr/X11"
    else "/usr/X11 => #{x11_path}"
    end
  end

  def describe_perl
    perl = which 'perl'
    return "N/A" if perl.nil?

    real_perl = Pathname.new(perl).realpath
    return perl if perl == real_perl
    return "#{perl} => #{real_perl}"
  end

  def describe_python
    python = which 'python'
    return "N/A" if python.nil?

    real_python = Pathname.new(python).realpath

    return python if python == real_python
    return "#{python} => #{real_python}"
  end

  def describe_ruby
    ruby = which 'ruby'
    return "N/A" if ruby.nil?

    real_ruby = Pathname.new(ruby).realpath
    return ruby if ruby == real_ruby
    return "#{ruby} => #{real_ruby}"
  end

  def real_path a_path
    Pathname.new(a_path).realpath.to_s
  end

  def hardware
    "CPU: #{Hardware.cores_as_words}-core #{Hardware.bits}-bit #{Hardware.intel_family}"
  end

  def kernel
    `uname -m`.chomp
  end

  # we try to keep output minimal
  def dump_build_config
    puts "HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}" if HOMEBREW_PREFIX.to_s != "/usr/local"
    puts "HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}" if HOMEBREW_CELLAR.to_s != "#{HOMEBREW_PREFIX}/Cellar"
    puts hardware
    puts "MacOS: #{MACOS_FULL_VERSION}-#{kernel}"
    puts "Xcode: #{xcode_version}"
    puts "/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby:\n  #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}" if RUBY_VERSION.to_f != 1.8

    ponk = macports_or_fink_installed?
    puts "MacPorts/Fink: #{ponk}" if ponk

    x11 = describe_x11
    puts "X11: #{x11}" unless x11 == "/usr/X11"
  end

  def config_s; <<-EOS.undent
    HOMEBREW_VERSION: #{HOMEBREW_VERSION}
    HEAD: #{sha}
    HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}
    HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}
    #{hardware}
    OS X: #{MACOS_FULL_VERSION}
    Kernel Architecture: #{kernel}
    Xcode: #{xcode_version}
    GCC-4.0: #{gcc_40 ? "build #{gcc_40}" : "N/A"}
    GCC-4.2: #{gcc_42 ? "build #{gcc_42}" : "N/A"}
    LLVM: #{llvm ? "build #{llvm}" : "N/A"}
    Clang: #{clang ? "#{clang} build #{clang_build}" : "N/A"}
    MacPorts or Fink? #{macports_or_fink_installed?}
    X11: #{describe_x11}
    System Ruby: #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}
    Which Perl:   #{describe_perl}
    Which Python: #{describe_python}
    Which Ruby:   #{describe_ruby}
    EOS
  end
end
