require 'formula'

class Mp3splt < Formula
  url 'http://prdownloads.sourceforge.net/mp3splt/mp3splt-2.4.tar.gz'
  homepage 'http://mp3splt.sourceforge.net/'
  md5 'aa4dc3de6e789961c71d8b3daaac0623'

  depends_on "libid3tag"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
