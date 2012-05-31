require 'formula'

class Zile < Formula
  homepage 'http://www.gnu.org/software/zile/'
  url 'http://ftpmirror.gnu.org/zile/zile-2.4.7.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/zile/zile-2.4.7.tar.gz'
  sha1 '30c47a399b94b5dce68a178fe98807f86719a466'

  depends_on 'bdw-gc'
  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
