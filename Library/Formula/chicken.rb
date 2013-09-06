require 'formula'

class Chicken < Formula
  homepage 'http://www.call-cc.org/'
  url 'http://code.call-cc.org/releases/4.8.0/chicken-4.8.0.4.tar.gz'
  sha1 '35fe59da04041a7b98d018e5ebb223d491ae57c4'

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
