require 'formula'

class Libpano <Formula
  url 'http://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.17/libpano13-2.9.17.tar.gz'
  version '13-2.9.17'
  homepage 'http://panotools.sourceforge.net/'
  md5 '54ec7c505cf38521f2fbb6e2acd2c433'

  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'libpng'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
