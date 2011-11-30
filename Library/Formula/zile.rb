require 'formula'

class Zile < Formula
  url 'http://ftpmirror.gnu.org/zile/zile-2.4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/zile/zile-2.4.2.tar.gz'
  homepage 'http://www.gnu.org/software/zile/'
  md5 '2a68ac77cebbeca1eacf170ba9072dbe'

  depends_on 'bdw-gc'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
