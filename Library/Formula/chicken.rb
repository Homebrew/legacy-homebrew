require 'formula'

class Chicken < Formula
  homepage 'http://www.call-cc.org/'
  url 'http://code.call-cc.org/releases/4.8.0/chicken-4.8.0.3.tar.gz'
  sha1 '90ce759d3b8a2cb53b2409c1e90277d380069440'

  head 'git://code.call-cc.org/chicken-core'

  def install
    ENV.deparallelize
    # Chicken uses a non-standard var. for this
    args = ["PREFIX=#{prefix}", "PLATFORM=macosx", "C_COMPILER=#{ENV.cc}"]
    args << "ARCH=x86-64" if MacOS.prefer_64_bit?
    system "make", *args
    system "make", "install", *args
  end
end
