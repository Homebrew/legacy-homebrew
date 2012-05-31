require 'formula'

class ReginaRexx < Formula
  url 'http://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.4/Regina-REXX-3.4.tar.gz'
  homepage 'http://regina-rexx.sourceforge.net/'
  md5 '3300e28b39134211a45aedb0e760cd44'

  def install
    ENV.j1 # No core usage for you
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
