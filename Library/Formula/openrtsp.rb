class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2016.02.22.tar.gz"
  sha256 "e4571b466547e3ad153e4bd9bbb81b24d838815e9d97176157ecfb18c5414cd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2ead1f61b03f296f4256565e34edc0793316001584459166a90e5f2a3a68ffd" => :el_capitan
    sha256 "7e238c49ca726642bebd349d8230d2a60979770c35df8b7a130225ea1fe63064" => :yosemite
    sha256 "76f16900271a7f413655ad697c2cfb3a608eadb506c9f7d5acd960d8d32ec828" => :mavericks
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
