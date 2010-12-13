require 'formula'

class Rasqal <Formula
  url 'http://download.librdf.org/source/rasqal-0.9.20.tar.gz'
  homepage 'http://librdf.org/rasqal/'
  md5 'c45b6cd784298e264e8757d14355ecce'

  depends_on 'raptor'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
