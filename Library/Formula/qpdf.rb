require 'formula'

class Qpdf < Formula
  url 'http://downloads.sourceforge.net/project/qpdf/qpdf/2.3.0/qpdf-2.3.0.tar.gz'
  homepage 'http://qpdf.sourceforge.net/'
  md5 'af6d60984055e6a2c988d53c55b1a7ca'

  depends_on 'pcre'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
