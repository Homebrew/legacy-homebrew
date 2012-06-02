require 'formula'

class Ddrescue < Formula
  homepage 'http://www.gnu.org/software/ddrescue/ddrescue.html'
  url 'http://ftpmirror.gnu.org/ddrescue/ddrescue-1.15.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/ddrescue/ddrescue-1.15.tar.gz'
  md5 '6b445f6246074a7fa02f3b2599031096'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make install"
  end
end
