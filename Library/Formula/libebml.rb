require 'formula'

class Libebml <Formula
  url 'http://dl.matroska.org/downloads/libebml/libebml-1.2.0.tar.bz2'
  homepage 'http://www.matroska.org/'
  md5 '26fbaa556bb497c1134d33b84ab34443'

  def install
    system 'cp -r make/linux make/darwin'
    system "cd make/darwin && make install prefix=#{prefix}"
  end
end
