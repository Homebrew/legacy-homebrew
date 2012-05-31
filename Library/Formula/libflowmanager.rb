require 'formula'

class Libflowmanager < Formula
  url 'http://research.wand.net.nz/software/libflowmanager/libflowmanager-2.0.0.tar.gz'
  homepage 'http://research.wand.net.nz/software/libflowmanager.php'
  md5 'da8d21616c28bcba817405d85773b9c6'

  depends_on 'libtrace'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
