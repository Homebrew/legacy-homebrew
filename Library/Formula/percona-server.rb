require 'formula'

class PerconaServer < Formula
  url 'http://www.percona.com/redir/downloads/Percona-Server-5.1/Percona-Server-5.1.57-12.8/source/Percona-Server-5.1.57.tar.gz'
  homepage 'http://www.percona.com'
  md5 '4268926cb5d56df3db61396a41b1475b'
  version '5.1.57-12.8'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}", "--infodir=#{info}"
    system "make install"
  end
end
