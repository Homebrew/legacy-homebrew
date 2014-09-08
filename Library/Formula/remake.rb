require 'formula'

class Remake < Formula
  homepage 'http://bashdb.sourceforge.net/remake/'
  url 'https://downloads.sourceforge.net/bashdb/remake/3.82%2Bdbg-0.9/remake-3.82%2Bdbg0.9.tar.gz'
  sha1 'bac6b2d2327ef4bcafe529901daa28c6645e83c7'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"remake", "-v"
  end
end
