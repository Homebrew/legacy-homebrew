require 'formula'

class Fping <Formula
  url 'http://fping.sourceforge.net/download/fping.tar.gz'
  homepage 'http://fping.sourceforge.net/'
  md5 'd5e8be59e307cef76bc479e1684df705'
  version '2.4b2_to-ipv6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
