require 'formula'

class Libdrawtext < Formula
  homepage 'http://nuclear.mutantstargoat.com/sw/libdrawtext/'
  url 'http://nuclear.mutantstargoat.com/sw/libdrawtext/libdrawtext-0.1.tar.gz'
  sha1 '0d7166bbb1479553abf82b71a56ec565d861fe81'

  depends_on 'pkg-config' => :build
  depends_on 'freetype'
  depends_on 'glew'

  def install
    system "./configure", "--disable-dbg", "--enable-opt",
           "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
