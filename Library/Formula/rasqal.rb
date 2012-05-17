require 'formula'

class Rasqal < Formula
  homepage 'http://librdf.org/rasqal/'
  url 'http://download.librdf.org/source/rasqal-0.9.29.tar.gz'
  sha1 'a005556bf62d44a8fa1cc2faf931f78ed4516852'

  depends_on 'raptor'

  def install
    system './configure', "--prefix=#{prefix}",
                          "--with-html-dir=#{share}/doc",
                          '--disable-dependency-tracking'
    system "make install"
  end
end
