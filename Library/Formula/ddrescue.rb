require 'formula'

class Ddrescue < Formula
  url 'http://ftp.gnu.org/gnu/ddrescue/ddrescue-1.13.tar.gz'
  homepage 'http://www.gnu.org/software/ddrescue/ddrescue.html'
  md5 '0afc4130882a993772385629d1c0a32e'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking",
           "CXX=#{ENV['CXX']}"
    system "make install"
  end
end
