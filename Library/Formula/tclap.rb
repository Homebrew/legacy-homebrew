require 'formula'

class Tclap < Formula
  url 'http://downloads.sourceforge.net/project/tclap/tclap-1.2.1.tar.gz'
  homepage 'http://tclap.sourceforge.net/'
  md5 'eb0521d029bf3b1cc0dcaa7e42abf82a'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # Installer scripts have problems with parallel make
    ENV.deparallelize
    system "make install"
  end
end
