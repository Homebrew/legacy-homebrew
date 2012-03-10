require 'formula'

class Rasqal < Formula
  url 'http://download.librdf.org/source/rasqal-0.9.27.tar.gz'
  homepage 'http://librdf.org/rasqal/'
  md5 'dd48b9a80947a6136fbdb79276d476e2'

  depends_on 'raptor'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
