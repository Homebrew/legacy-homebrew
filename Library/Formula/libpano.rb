require 'formula'

class Libpano <Formula
  url 'http://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.17_beta1/libpano13-2.9.17_beta1.tar.gz'
  version '13-2.9.17_beta1'
  homepage 'http://panotools.sourceforge.net/'
  md5 'd3708c6c29f6a19b69c74232853e73ae'

  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'libpng'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
