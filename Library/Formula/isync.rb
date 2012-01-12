require 'formula'

class Isync < Formula
  url 'http://downloads.sourceforge.net/project/isync/isync/1.0.4/isync-1.0.4.tar.gz'
  homepage 'http://isync.sourceforge.net/'
  md5 '8a836a6f4b43cd38a8b8153048417616'

  depends_on 'berkeley-db'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
