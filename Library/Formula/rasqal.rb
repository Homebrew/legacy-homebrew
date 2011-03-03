require 'formula'

class Rasqal <Formula
  url 'http://download.librdf.org/source/rasqal-0.9.21.tar.gz'
  homepage 'http://librdf.org/rasqal/'
  md5 '55b67ec92a059ef8979d46486b00a032'

  depends_on 'raptor'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
