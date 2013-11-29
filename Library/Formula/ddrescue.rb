require 'formula'

class Ddrescue < Formula
  homepage 'http://www.gnu.org/software/ddrescue/ddrescue.html'
  url 'http://ftpmirror.gnu.org/ddrescue/ddrescue-1.17.tar.lz'
  mirror 'http://ftp.gnu.org/gnu/ddrescue/ddrescue-1.17.tar.lz'
  sha1 '2d91b070fe629f713d53a97213165a8c568f5ffd'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make install"
  end
end
