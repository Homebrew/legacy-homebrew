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
    if specs.nil?
      @using = nil
    else
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
