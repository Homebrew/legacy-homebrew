require 'formula'

class Libzip < Formula
  homepage 'http://www.nih.at/libzip/'
  url 'http://www.nih.at/libzip/libzip-0.11.2.tar.gz'
  sha1 'eeb3b5567fcf3532fa4bcb6440a87c7ad8507d2d'

  bottle do
    cellar :any
    revision 1
    sha1 "ce30c8d305a9e9472448f5d91b28714a5aa2a576" => :yosemite
    sha1 "b9efac49af4b11a0e9f45d849b6d5b0b6c8e2a6e" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make install"
  end
end
