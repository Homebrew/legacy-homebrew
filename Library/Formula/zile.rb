require 'formula'

class Zile < Formula
  homepage 'http://www.gnu.org/software/zile/'
  url 'http://ftpmirror.gnu.org/zile/zile-2.4.9.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/zile/zile-2.4.9.tar.gz'
  sha1 'f233487e2d0ce99d7670832d106d1a2503d4c925'

  depends_on 'bdw-gc'
  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
