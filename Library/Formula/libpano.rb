require 'formula'

class Libpano < Formula
  url 'http://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.18/libpano13-2.9.18.tar.gz'
  version '13-2.9.18'
  homepage 'http://panotools.sourceforge.net/'
  md5 '9c3a4fce8b6f1d79e395896ce5d8776e'

  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    ENV.x11 # for libpng
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
