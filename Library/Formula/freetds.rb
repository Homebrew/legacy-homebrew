require 'formula'

class Freetds < Formula
  url 'http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/freetds-0.91.tar.gz'
  homepage 'http://www.freetds.org/'
  md5 'b14db5823980a32f0643d1a84d3ec3ad'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-tdsver=8.0", "--enable-msdblib", "--mandir=#{man}"
    system 'make'
    system 'make install'
  end
end
