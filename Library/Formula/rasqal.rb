require 'formula'

class Rasqal < Formula
  url 'http://download.librdf.org/source/rasqal-0.9.25.tar.gz'
  homepage 'http://librdf.org/rasqal/'
  md5 'ee12d7ad59c581eb65db89c851672c0a'

  depends_on 'raptor'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
