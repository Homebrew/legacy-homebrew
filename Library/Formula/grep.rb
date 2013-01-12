require 'formula'

class Grep < Formula
  homepage 'http://www.gnu.org/software/grep/'
  url 'http://ftpmirror.gnu.org/grep/grep-2.14.tar.xz'
  sha1 'fb6ea404a0ef915334ca6212c7b517432ffe193e'

  depends_on 'xz'
  depends_on 'pcre'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "make check"
  end
end
