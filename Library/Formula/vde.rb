require 'formula'

class Vde <Formula
  url 'http://downloads.sourceforge.net/project/vde/vde2/2.3.1/vde2-2.3.1.tar.gz'
  homepage 'http://vde.sourceforge.net/'
  sha256 '6778c4a302b8fa3d9e2664760c9cf0bed02384984cbc79f773c1b230916e79ed'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
