require 'formula'

class Chicken < Formula
  url 'http://code.call-cc.org/releases/4.6.0/chicken-4.6.0.tar.gz'
  md5 '538a93e786e550ad848a040bcd902184'
  homepage 'http://www.call-cc.org/'
  head 'git://code.call-cc.org/chicken-core'

  def install
    ENV.deparallelize
    args = ["PREFIX=#{prefix}", "PLATFORM=macosx"]
    args << "ARCH=x86-64" if MacOS.prefer_64_bit?
    system "make", *args
    system "make", "install", *args
  end
end
