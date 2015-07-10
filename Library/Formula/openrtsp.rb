class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://live555.com/liveMedia/public/live.2015.06.25.tar.gz"
  sha256 "c769542f930840ac246155558e163cd94b119f4f6b9e102b6b5b063f9f055875"

  bottle do
    cellar :any
    sha1 "01a5a2676e3995e505fc092ca949b67691f2e812" => :yosemite
    sha1 "f019de571028a7fa0027a2f4e464651e5a5259f9" => :mavericks
    sha1 "ee10c6dd74631ae656f4482380a1ec81c86e779d" => :mountain_lion
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
