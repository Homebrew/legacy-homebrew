require 'formula'

class Libpano < Formula
  homepage 'http://panotools.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.19/libpano13-2.9.19.tar.gz'
  version '13-2.9.19'
  sha1 '85d8d94c96780fa5b6df2c2e4929f8d20557f128'
  revision 1

  depends_on 'libpng'
  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
