require 'formula'

class Qpdf <Formula
  url 'http://downloads.sourceforge.net/project/qpdf/qpdf/2.1.5/qpdf-2.1.5.tar.gz'
  homepage 'http://qpdf.sourceforge.net/'
  md5 '8c4eb57066761778a9e745bfa9a70f64'

  depends_on 'pcre'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
