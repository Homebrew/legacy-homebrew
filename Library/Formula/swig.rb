require 'formula'

class Swig < Formula
  homepage 'http://www.swig.org/'
  url 'http://downloads.sourceforge.net/project/swig/swig/swig-2.0.11/swig-2.0.11.tar.gz'
  sha1 'd3bf4e78824dba76bfb3269367f1ae0276b49df9'

  option :universal

  depends_on 'pcre'
  depends_on :python  # assure swig find the "right" python
  depends_on :python3 => :optional

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
