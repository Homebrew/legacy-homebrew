class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://live555.com/liveMedia/public/live.2015.06.25.tar.gz"
  sha256 "c769542f930840ac246155558e163cd94b119f4f6b9e102b6b5b063f9f055875"

  bottle do
    cellar :any
    sha256 "ff44f9812456770736ca3f338769afc02226303dc40780125da8b65f4a604292" => :yosemite
    sha256 "b916e93c80bd88c5f7f873c956d8cf5a04a2952b76b51b41110cde02e209f9a9" => :mavericks
    sha256 "f041f3680d6a71378d61078152bcbba8fc54c58de5f074f121397135687dc564" => :mountain_lion
  end

  option "32-bit"

  def install
    if build.build_32_bit? || !MacOS.prefer_64_bit?
      ENV.m32
      system "./genMakefiles", "macosx-32bit"
    else
      system "./genMakefiles", "macosx"
    end

    system "make", "PREFIX=#{prefix}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats; <<-EOS.undent
    Testing executables have been placed in:
      #{libexec}
    EOS
  end
end
