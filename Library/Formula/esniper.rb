require 'formula'

class Esniper <Formula
  url 'http://downloads.sourceforge.net/project/esniper/esniper/2.23.0/esniper-2-23-0.tgz'
  homepage 'http://sourceforge.net/projects/esniper/'
  md5 'fa1990f82213193cb05efd3040848fcb'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
