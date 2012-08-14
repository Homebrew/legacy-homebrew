require 'formula'

class Zile < Formula
  homepage 'http://www.gnu.org/software/zile/'
  url 'http://ftpmirror.gnu.org/zile/zile-2.4.8.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/zile/zile-2.4.8.tar.gz'
  sha1 '763224367472deecf71fb10d61806706a481fd48'

  depends_on 'bdw-gc'
  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
