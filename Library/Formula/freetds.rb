require 'formula'

class Freetds < Formula
  url 'http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/freetds-0.91.tar.gz'
  homepage 'http://www.freetds.org/'
  md5 'b14db5823980a32f0643d1a84d3ec3ad'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-tdsver=7.1", "--mandir=#{man}"
    system 'make'
    ENV.j1 # Or fails to install on multi-core machines
    system 'make install'
  end
end
