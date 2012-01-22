require 'formula'

class Libfrei0r < Formula
  url 'http://www.piksel.no/frei0r/releases/frei0r-plugins-1.3.tar.gz'
  homepage 'http://www.piksel.org/frei0r'
  md5 'a2eb63feeeb0c5cf439ccca276cbf70c'
  head 'git://code.dyne.org/frei0r.git'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
