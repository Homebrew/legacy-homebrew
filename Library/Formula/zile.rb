require 'formula'

class Zile < Formula
  url 'http://ftp.gnu.org/gnu/zile/zile-2.3.23.tar.gz'
  homepage 'http://www.gnu.org/software/zile/'
  md5 '4a2fa0015403cdf0eb32a5e648169cae'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
