require 'brewkit'

class Mg <Formula
  url 'http://www.dds.nl/~han/software/mg/mg-20090107.tar.gz'
  homepage 'http://www.han.dds.nl/software/mg'
  md5 'f25a139da44c3a2f760ffec531bd996e'

  def install
    system "./configure"
    system "make prefix=#{prefix}"
    system "make install prefix=#{prefix}"
  end
end
