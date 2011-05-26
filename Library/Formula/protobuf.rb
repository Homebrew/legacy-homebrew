require 'formula'

class Protobuf < Formula
  url 'http://protobuf.googlecode.com/files/protobuf-2.4.1.tar.bz2'
  homepage 'http://code.google.com/p/protobuf/'
  sha1 'df5867e37a4b51fb69f53a8baf5b994938691d6d'

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
