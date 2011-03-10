require 'formula'

class Rsnapshot < Formula
  url 'http://rsnapshot.org/downloads/rsnapshot-1.3.1.tar.gz'
  homepage 'http://rsnapshot.org'
  sha1 'a3aa3560dc389e1b00155a5869558522c4a29e05'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
