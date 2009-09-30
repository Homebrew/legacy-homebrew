require 'brewkit'

class Xpdf <Formula
  url 'ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02.tar.gz'
  homepage 'http://www.foolabs.com/xpdf/'
  md5 '599dc4cc65a07ee868cf92a667a913d2'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
  
  def patches
    # latest security patch
    ["ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02pl3.patch"]
  end
  
end