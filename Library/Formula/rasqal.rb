require 'formula'

class Rasqal < Formula
  homepage 'http://librdf.org/rasqal/'
  url 'http://download.librdf.org/source/rasqal-0.9.30.tar.gz'
  sha1 '8e104acd68fca9b3b97331746e08d53d07d2e20a'

  depends_on 'pkg-config' => :build
  depends_on 'raptor'

  def install
    system './configure', "--prefix=#{prefix}",
                          "--with-html-dir=#{share}/doc",
                          '--disable-dependency-tracking'
    system "make install"
  end
end
