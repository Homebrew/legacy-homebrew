require 'formula'

class Esniper < Formula
  url 'http://downloads.sourceforge.net/project/esniper/esniper/2.27.0/esniper-2-27-0.tgz'
  homepage 'http://sourceforge.net/projects/esniper/'
  md5 '673a014f78402c2af1f2d42b3990ed9d'
  version '2.27'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
