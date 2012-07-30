require 'formula'

class Chicken < Formula
  url 'http://code.call-cc.org/releases/4.7.0/chicken-4.7.0.6.tar.gz'
  md5 '31f455be39b3e12503ced8d81971e610'
  homepage 'http://www.call-cc.org/'
  head 'git://code.call-cc.org/chicken-core'

  def install
    ENV.deparallelize
    args = ["PREFIX=#{prefix}", "PLATFORM=macosx", "C_COMPILER=#{ENV.cc}"] # Chicken uses a non-standard var. for this
    args << "ARCH=x86-64" if MacOS.prefer_64_bit?
    system "make", *args
    system "make", "install", *args
  end
end
