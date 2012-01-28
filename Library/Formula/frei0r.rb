require 'formula'

class Frei0r < Formula
  url 'ftp://ftp.dyne.org/frei0r/releases/frei0r-plugins-1.3.tar.gz'
  homepage 'http://frei0r.dyne.org/'
  md5 'a2eb63feeeb0c5cf439ccca276cbf70c'

  depends_on 'opencv'
  depends_on 'gavl'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
