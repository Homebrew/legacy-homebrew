require 'formula'

class Qpdf <Formula
  url 'http://downloads.sourceforge.net/project/qpdf/qpdf/2.0.6/qpdf-2.0.6.tar.gz'
  homepage 'http://qpdf.sourceforge.net/'
  md5 '58b7300e6d966f0bcf4a5ea810a84878'

  depends_on 'pcre'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end