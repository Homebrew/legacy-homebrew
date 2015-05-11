require 'formula'

class Libdrawtext < Formula
  homepage 'http://nuclear.mutantstargoat.com/sw/libdrawtext/'
  url 'http://nuclear.mutantstargoat.com/sw/libdrawtext/libdrawtext-0.2.1.tar.gz'
  sha1 'dd12c67e7c7898a5941a92d616e9dbbbab4b9a38'
  head 'https://github.com/jtsiomb/libdrawtext.git'

  depends_on 'pkg-config' => :build
  depends_on 'freetype'
  depends_on 'glew'

  def install
    system "./configure", "--disable-dbg", "--enable-opt", "--prefix=#{prefix}"
    system "make", "install"
  end
end
