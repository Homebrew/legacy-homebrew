require 'formula'

class Rsnapshot < Formula
  homepage 'http://rsnapshot.org'
  url 'http://rsnapshot.org/downloads/rsnapshot-1.3.1.tar.gz'
  sha1 'a3aa3560dc389e1b00155a5869558522c4a29e05'

  head 'cvs://:pserver:anonymous@rsnapshot.cvs.sourceforge.net:/cvsroot/rsnapshot:rsnapshot'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
