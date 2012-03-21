require 'formula'

class Rasqal < Formula
  url 'http://download.librdf.org/source/rasqal-0.9.28.tar.gz'
  homepage 'http://librdf.org/rasqal/'
  md5 'a3662b8d9efef9d8ef0a3c182450fba2'

  depends_on 'raptor'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
