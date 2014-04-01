require 'formula'

class Swig < Formula
  homepage 'http://www.swig.org/'
  url 'https://downloads.sourceforge.net/project/swig/swig/swig-3.0.0/swig-3.0.0.tar.gz'
  sha1 '10a1cc5ba6abbc7282b8146ccc0d8eefe233bfab'

  option :universal

  depends_on 'pcre'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
