require 'formula'

class Rasqal <Formula
  url 'http://download.librdf.org/source/rasqal-0.9.17.tar.gz'
  homepage 'http://librdf.org/rasqal/'
  md5 'ee65a1c55da27d95f50d1e667b98d1d0'

  depends_on 'raptor'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
