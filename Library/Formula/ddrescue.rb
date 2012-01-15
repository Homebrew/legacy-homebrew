require 'formula'

class Ddrescue < Formula
  url 'http://ftpmirror.gnu.org/ddrescue/ddrescue-1.14.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/ddrescue/ddrescue-1.14.tar.gz'
  homepage 'http://www.gnu.org/software/ddrescue/ddrescue.html'
  md5 'd6f6cc63df9ad352bc6e43b65c975af5'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking",
           "CXX=#{ENV['CXX']}"
    system "make install"
  end
end
