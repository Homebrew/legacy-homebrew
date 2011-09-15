require 'formula'

class Srm < Formula
  url 'http://downloads.sourceforge.net/project/srm/srm/1.2.11/srm-1.2.11.tar.gz'
  homepage 'http://srm.sourceforge.net/'
  md5 '9617033fc97651a529fb80930da6a278'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
