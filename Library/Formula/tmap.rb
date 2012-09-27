require 'formula'

class Tmap < Formula
  homepage 'http://github.com/iontorrent/TMAP'
  url 'http://github.com/iontorrent/TMAP/tarball/tmap.0.3.7'
  sha1 '8cb8c6d9ebaeb3486a74a402a07a08c778964682'
  version '0.3.7'

  head 'https://github.com/iontorrent/TMAP.git'

  fails_with :clang do
    build 318
  end

  def install
    system "sh autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/tmap", "-v"
  end
end
