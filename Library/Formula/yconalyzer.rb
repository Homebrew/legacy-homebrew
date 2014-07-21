require 'formula'

class Yconalyzer < Formula
  homepage 'http://sourceforge.net/projects/yconalyzer/'
  url 'https://downloads.sourceforge.net/project/yconalyzer/yconalyzer-1.0.4.tar.bz2'
  sha1 'a8fcbf1ce2a0e8612448cc997e904cc572473bcc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "chmod +x ./install-sh"
    system "make install"
  end
end
