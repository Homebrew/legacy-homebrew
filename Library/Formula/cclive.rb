require 'formula'

class Cclive <Formula
  url 'http://cclive.googlecode.com/files/cclive-0.6.3.tar.bz2'
  homepage 'http://code.google.com/p/cclive/'
  md5 '07123fa1c5f8fd60a14d6ceaaf935a2c'

  depends_on 'pkg-config'
  depends_on 'quvi'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
