require 'download_strategy'


# Defines a URL and download method for a stable or HEAD build
class SoftwareSpecification
  attr_reader :url, :specs, :using

  VCS_SYMBOLS = {
    :bzr     => BazaarDownloadStrategy,
    :curl    => CurlDownloadStrategy,
    :cvs     => CVSDownloadStrategy,
    :git     => GitDownloadStrategy,
    :hg      => MercurialDownloadStrategy,
    :nounzip => NoUnzipCurlDownloadStrategy,
    :post    => CurlPostDownloadStrategy,
    :svn     => SubversionDownloadStrategy,
  }

  def initialize url, specs=nil
    raise "No url provided" if url.nil?
    @url = url
    unless specs.nil?
      # Get download strategy hint, if any
      @using = specs.delete :using
      # The rest of the specs are for source control
      @specs = specs
    end
  end

  # Returns a suitable DownloadStrategy class that can be
  # used to retreive this software package.
  def download_strategy
    return detect_download_strategy(@url) if @using.nil?

    # If a class is passed, assume it is a download strategy
    return @using if @using.kind_of? Class

    detected = VCS_SYMBOLS[@using]
    raise "Unknown strategy #{@using} was requested." unless detected
    return detected
  end

  def detect_version
    Pathname.new(@url).version
  end
end


# Used to annotate formulae that duplicate OS X provided software
# or cause conflicts when linked in.
class KegOnlyReason
  attr_reader :reason, :explanation

  def initialize reason, explanation=nil
    @reason = reason
    @explanation = explanation
  end

  def to_s
    if @reason == :provided_by_osx
      <<-EOS.strip
Mac OS X already provides this program and installing another version in
parallel can cause all kinds of trouble.

#{@explanation}
EOS
    else
      @reason.strip
    end
  end
end


# Used to annotate formulae that won't build correctly with LLVM.
class FailsWithLLVM
  attr_reader :msg, :data, :build

  def initialize msg=nil, data=nil
    if msg.nil? or msg.kind_of? Hash
      @msg = "(No specific reason was given)"
      data = msg
    else
      @msg = msg
    end
    @data = data
    @build = data.delete :build rescue nil
  end

  def reason
    s = @msg
    s += "Tested with LLVM build #{@build}" unless @build == nil
    s += "\n"
    return s
  end

  def handle_failure
    return unless ENV.compiler == :llvm

    # version 2336 is the latest version as of Xcode 4.2, so it is the
    # latest version we have tested against so we will switch to GCC and
    # bump this integer when Xcode 4.3 is released. TODO do that!
    if build.to_i >= 2336
      if MacOS.xcode_version < "4.2"
        opoo "Formula will not build with LLVM, using GCC"
        ENV.gcc
      else
        opoo "Formula will not build with LLVM, trying Clang"
        ENV.clang
      end
      return
    end
    opoo "Building with LLVM, but this formula is reported to not work with LLVM:"
    puts
    puts reason
    puts
    puts <<-EOS.undent
      We are continuing anyway so if the build succeeds, please open a ticket with
      the following information: #{MacOS.llvm_build_version}-#{MACOS_VERSION}. So
      that we can update the formula accordingly. Thanks!
      EOS
    puts
    if MacOS.xcode_version < "4.2"
      puts "If it doesn't work you can: brew install --use-gcc"
    else
      puts "If it doesn't work you can try: brew install --use-clang"
    end
    puts
  end
end
