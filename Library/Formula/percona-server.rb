require 'formula'

class PerconaServer < Formula
  url 'http://www.percona.com/redir/downloads/Percona-Server-5.1/Percona-Server-5.1.55-12.6/source/Percona-Server-5.1.55-rel12.6.tar.gz'
  homepage 'http://www.percona.com'
  md5 '616c3221774cb3fd72c92798cf9059d7'
  version '5.1.55-12.6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}", "--infodir=#{info}"
    system "make install"
  end
end
