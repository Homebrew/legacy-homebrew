require 'formula'

class Freetds < Formula
  url 'http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/freetds-0.82.tar.gz'
  homepage 'http://www.freetds.org/'
  md5 '3df6b2e83fd420e90f1becbd1162990a'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-tdsver=7.0", "--enable-msdblib", "--mandir=#{man}"
    system 'make'
    system 'make install'
  end
end
