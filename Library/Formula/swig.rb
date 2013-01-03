require 'formula'

class Swig < Formula
  homepage 'http://www.swig.org/'
  url 'http://sourceforge.net/projects/swig/files/swig/swig-2.0.9/swig-2.0.9.tar.gz'
  sha1 '7984bf1043f522e88ea51d4bd21c97d3c68342be'

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
