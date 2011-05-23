require 'formula'

class Protobuf < Formula
  url 'http://protobuf.googlecode.com/files/protobuf-2.4.0a.tar.bz2'
  homepage 'http://code.google.com/p/protobuf/'
  sha1 '5816b0dd686115c3d90c3beccf17fd89432d3f07'

  fails_with_llvm

  def options
    [['--universal', 'Do a universal build']]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"
    system "make"
    system "make install"
  end
end
