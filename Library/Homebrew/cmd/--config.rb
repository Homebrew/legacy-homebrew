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

  def xcode_version
    `xcodebuild -version 2>&1` =~ /Xcode (\d(\.\d)*)/
    $1
  end

  def llvm_recommendation
    "(#{RECOMMENDED_LLVM} or newer recommended)" if llvm and llvm < RECOMMENDED_LLVM
  end

  def gcc_42_recommendation
    "(#{RECOMMENDED_GCC_42} or newer recommended)" if gcc_42 and gcc_42 < RECOMMENDED_GCC_42
  end

  def gcc_40_recommendation
    "(#{RECOMMENDED_GCC_40} or newer recommended)" if gcc_40 and gcc_40 < RECOMMENDED_GCC_40
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
    GCC-4.0: #{gcc_40 ? "build #{gcc_40}" : "N/A"} #{gcc_40_recommendation}
    GCC-4.2: #{gcc_42 ? "build #{gcc_42}" : "N/A"} #{gcc_42_recommendation}
    LLVM: #{llvm ? "build #{llvm}" : "N/A" } #{llvm_recommendation}
    MacPorts or Fink? #{macports_or_fink_installed?}
    X11 installed? #{x11_installed?}
    EOS
  end
end
