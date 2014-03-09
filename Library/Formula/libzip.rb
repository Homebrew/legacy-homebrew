require 'formula'

class Libzip < Formula
  homepage 'http://www.nih.at/libzip/'
  url 'http://www.nih.at/libzip/libzip-0.11.2.tar.gz'
  sha1 'eeb3b5567fcf3532fa4bcb6440a87c7ad8507d2d'

  bottle do
    cellar :any
    sha1 "ed81b49df9a37a76c79ea81ea24270e85bcfcf7b" => :mavericks
    sha1 "c6ae9c8a7d990eda3120dcdedc8eaedba24be174" => :mountain_lion
    sha1 "075beaec1419bf7b0aaeb03a492acc70a731e3ba" => :lion
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
