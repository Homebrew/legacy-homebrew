require 'formula'

class Rasqal <Formula
  url 'http://download.librdf.org/source/rasqal-0.9.19.tar.gz'
  homepage 'http://librdf.org/rasqal/'
  md5 '9bc1b40ffe1bdc794887d845d153bd4e'

  depends_on 'raptor'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
