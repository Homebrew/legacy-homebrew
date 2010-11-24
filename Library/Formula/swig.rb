require 'formula'

class Swig <Formula
  url 'http://downloads.sourceforge.net/project/swig/swig/swig-2.0.1/swig-2.0.1.tar.gz'
  homepage 'http://www.swig.org/'
  md5 'df4465a62ccc5f0120fee0890ea1a31f'
  depends_on 'pcre'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
