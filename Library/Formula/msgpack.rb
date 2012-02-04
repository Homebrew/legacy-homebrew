require 'formula'

class Msgpack < Formula
  homepage 'http://msgpack.org/'
  url 'http://msgpack.org/releases/cpp/msgpack-0.5.7.tar.gz'
  sha256 '7c203265cf14a4723820e0fc7ac14bf4bad5578f7bc525e9835c70cd36e7d1b8'

  def install
    fails_with_llvm "LLVM-GCC failed compiling with message: unpack.c:463: internal compiler error: Segmentation fault: 11"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
