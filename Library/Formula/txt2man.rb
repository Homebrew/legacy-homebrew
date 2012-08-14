require 'formula'

class Txt2man < Formula
  homepage 'http://mvertes.free.fr/'
  url 'http://mvertes.free.fr/download/txt2man-1.5.6.tar.gz'
  sha1 'ef1392785333ea88f7e01f4f4c519ecfbdd498bd'

  depends_on 'gawk'

  def install
    man1.install %W[ bookman.1 src2man.1 txt2man.1 ]
    bin.install %W[ bookman src2man txt2man ]
  end

  def test
    system "#{bin}/txt2man", "-h"
    system "#{bin}/src2man", "-h"
    system "#{bin}/bookman", "-h"
  end
end
