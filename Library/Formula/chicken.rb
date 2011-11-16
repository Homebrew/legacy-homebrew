require 'formula'

class Chicken < Formula
  url 'http://code.call-cc.org/releases/4.7.0/chicken-4.7.0.tar.gz'
  md5 '9389388fdf04c3c64de29633aae12539'
  homepage 'http://www.call-cc.org/'
  head 'git://code.call-cc.org/chicken-core'

  fails_with_llvm "Compilation hangs. See http://lists.gnu.org/archive/html/chicken-users/2010-12/msg00158.html"

  def install
    ENV.deparallelize
    args = ["PREFIX=#{prefix}", "PLATFORM=macosx", "C_COMPILER=#{ENV.cc}"] # Chicken uses a non-standard var. for this
    args << "ARCH=x86-64" if MacOS.prefer_64_bit?
    system "make", *args
    system "make", "install", *args
  end
end
