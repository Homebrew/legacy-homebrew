require 'formula'

class Protobuf <Formula
  url 'http://protobuf.googlecode.com/files/protobuf-2.3.0.tar.bz2'
  sha1 'db0fbdc58be22a676335a37787178a4dfddf93c6'
  homepage 'http://code.google.com/p/protobuf/'

  def install
    fails_with_llvm
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"
    system "make"
    system "make install"
  end
end