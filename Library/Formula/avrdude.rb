require 'formula'

class Avrdude <Formula
  url 'http://mirror.lihnidos.org/GNU/savannah/avrdude/avrdude-5.10.tar.gz'
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  md5 '69b082683047e054348088fd63bad2ff'

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
