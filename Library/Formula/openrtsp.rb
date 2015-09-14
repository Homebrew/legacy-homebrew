class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2015.08.07.tar.gz"
  sha256 "1a27410aea9723e9e0c60850c57b52a08eed32a4ecfa88942026d2b9c0ac3fdc"

  bottle do
    cellar :any_skip_relocation
    sha256 "17e43299332bcb2187abcfabc33a6d3093a30e83633be182cfc14f21b6de7369" => :yosemite
    sha256 "d55d749e11c9e500b56df98727c9bbdb43445a856757ff0a762c2fb52370f91c" => :mavericks
    sha256 "8f051738a67319c3eaa5f990a7b8ca0ffb4b2a234872a325fdcfbb6951af3ca4" => :mountain_lion
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
