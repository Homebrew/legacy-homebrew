require 'formula'

class Xpdf <Formula
  url 'ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02.tar.gz'
  homepage 'http://www.foolabs.com/xpdf/'
  md5 '599dc4cc65a07ee868cf92a667a913d2'

  def patches
    [ # security patches, applied sequentially
      "ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02pl1.patch",
      "ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02pl2.patch",
      "ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02pl3.patch",
      "ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02pl4.patch"
    ]
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
