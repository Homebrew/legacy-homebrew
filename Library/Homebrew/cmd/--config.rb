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

  def describe_perl
    perl = `which perl`.chomp
    return "N/A" unless perl

    real_perl = Pathname.new(perl).realpath.to_s
    return perl if perl == real_perl
    return "#{perl} => #{real_perl}"
  end

  def describe_python
    python = `which python`.chomp
    return "N/A" unless python

    real_python = Pathname.new(python).realpath.to_s

    return python if python == real_python
    return "#{python} => #{real_python}"
  end

  def describe_ruby
    ruby = `which ruby`.chomp
    return "N/A" unless ruby

    real_ruby = Pathname.new(ruby).realpath.to_s
    return ruby if ruby == real_ruby
    return "#{ruby} => #{real_ruby}"
  end

  def real_path a_path
    Pathname.new(a_path).realpath.to_s
  end

  def config_s; <<-EOS.undent
    HOMEBREW_VERSION: #{HOMEBREW_VERSION}
    HEAD: #{sha}
    HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}
    HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}
    Hardware: #{Hardware.cores_as_words}-core #{Hardware.bits}-bit #{Hardware.intel_family}
    OS X: #{MACOS_FULL_VERSION}
    Kernel Architecture: #{`uname -m`.chomp}
    Xcode: #{xcode_version}
    GCC-4.0: #{gcc_40 ? "build #{gcc_40}" : "N/A"}
    GCC-4.2: #{gcc_42 ? "build #{gcc_42}" : "N/A"}
    LLVM: #{llvm ? "build #{llvm}" : "N/A"}
    Clang: #{clang ? "#{clang} build #{clang_build}" : "N/A"}
    MacPorts or Fink? #{macports_or_fink_installed?}
    X11 installed? #{x11_installed?}
    System Ruby: #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}
    /usr/bin/ruby => #{real_path("/usr/bin/ruby")}
    Which Perl:   #{describe_perl}
    Which Python: #{describe_python}
    Which Ruby:   #{describe_ruby}
    EOS
  end
end
