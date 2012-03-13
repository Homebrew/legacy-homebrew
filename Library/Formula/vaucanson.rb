require 'formula'

class Vaucanson < Formula
  url 'http://www.lrde.epita.fr/dload/vaucanson/1.4/vaucanson-1.4.tar.gz'
  homepage 'http://www.lrde.epita.fr/cgi-bin/twiki/view/Vaucanson/WebHome'
  md5 '6ba3b9e58fb55a88c4c655247d4901c6'

  depends_on 'boost'
  depends_on 'xerces-c'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "vcsn-char-b"
  end
end
