require 'formula'

class Rasqal <Formula
  url 'http://download.librdf.org/source/rasqal-0.9.24.tar.gz'
  homepage 'http://librdf.org/rasqal/'
  md5 '7cda27ed64e4c284f4b5a4f7f8c60d94'

  depends_on 'raptor'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
