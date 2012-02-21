require 'formula'

class Zile < Formula
  url 'http://ftpmirror.gnu.org/zile/zile-2.4.6.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/zile/zile-2.4.6.tar.gz'
  homepage 'http://www.gnu.org/software/zile/'
  md5 '508d14a3410d7dde89088eca06dad69'

  depends_on 'bdw-gc'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
