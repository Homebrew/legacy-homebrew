class Rtmidi < Formula
  desc "C++ classes that provide a common API for realtime MIDI input/output"
  homepage "http://www.music.mcgill.ca/~gary/rtmidi/"
  url "https://github.com/thestk/rtmidi/archive/2.1.0.tar.gz"
  sha256 "52e6822fc413d5d3963c5b7bfe412ed69233bb81a7f04d6097f5b56aafa28934"

  depends_on "autoconf"

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "librtmidi.a"
    lib.install Dir["*.a", "*.dylib"]
    include.install Dir["*.h"]
  end
end
