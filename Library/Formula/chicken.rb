require 'formula'

class Chicken < Formula
  url 'http://code.call-cc.org/releases/4.7.0/chicken-4.7.0.tar.gz'
  md5 '9389388fdf04c3c64de29633aae12539'
  homepage 'http://www.call-cc.org/'
  head 'git://code.call-cc.org/chicken-core'

  def install
    # see http://lists.gnu.org/archive/html/chicken-users/2010-12/msg00159.html
    if [:clang, :llvm].include? ENV.compiler
      ENV['DEBUGBUILD'] = "1"
      opoo "Building with DEBUGBUILD to avoid Clang/LLVM issues"
    end

    ENV.deparallelize
    args = ["PREFIX=#{prefix}", "PLATFORM=macosx", "C_COMPILER=#{ENV.cc}"] # Chicken uses a non-standard var. for this
    args << "ARCH=x86-64" if MacOS.prefer_64_bit?
    system "make", *args
    system "make", "install", *args
  end
end
