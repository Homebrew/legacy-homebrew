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
    sha = `cd #{HOMEBREW_REPOSITORY} && git rev-parse --verify HEAD 2> /dev/null`.chomp
    if sha.empty? then "(none)" else sha end
  end

  def system_ruby
    Pathname.new('/usr/bin/ruby').realpath.to_s
  end

  def config_s; <<-EOS.undent
    HOMEBREW_VERSION: #{HOMEBREW_VERSION}
    HEAD: #{sha}
    HOMEBREW_PREFIX: #{HOMEBREW_PREFIX}
    HOMEBREW_CELLAR: #{HOMEBREW_CELLAR}
    HOMEBREW_REPOSITORY: #{HOMEBREW_REPOSITORY}
    HOMEBREW_LIBRARY_PATH: #{HOMEBREW_LIBRARY_PATH}
    Hardware: #{Hardware.cores_as_words}-core #{Hardware.bits}-bit #{Hardware.intel_family}
    OS X: #{MACOS_FULL_VERSION}
    Kernel Architecture: #{`uname -m`.chomp}
    Ruby: #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}
    /usr/bin/ruby => #{system_ruby}
    Xcode: #{xcode_version}
    GCC-4.0: #{gcc_40 ? "build #{gcc_40}" : "N/A"}
    GCC-4.2: #{gcc_42 ? "build #{gcc_42}" : "N/A"}
    LLVM: #{llvm ? "build #{llvm}" : "N/A"}
    Clang: #{clang ? "#{clang}-#{clang_build}" : "N/A"}
    MacPorts or Fink? #{macports_or_fink_installed?}
    X11 installed? #{x11_installed?}
    EOS
  end
end
