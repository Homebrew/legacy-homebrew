require 'formula'

class Swig < Formula
  homepage 'http://www.swig.org/'
  url 'http://sourceforge.net/projects/swig/files/swig/swig-2.0.10/swig-2.0.10.tar.gz'
  sha1 'ad6f95ce9b9da4a8f5b80ac1848d26c76f518d84'

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
