require 'formula'

class Libmatroska <Formula
  url 'http://dl.matroska.org/downloads/libmatroska/libmatroska-1.1.0.tar.bz2'
  homepage 'http://www.matroska.org/'
  md5 '21e5ee3e2573f0ae99db195348bdfb98'

  depends_on 'libebml'

  def install
    system 'cp -r make/linux make/darwin'
    system "cd make/darwin && make install prefix=#{prefix}"
  end
end
