require 'formula'

class Makeicns < Formula
  url 'https://bitbucket.org/mkae/makeicns/downloads/makeicns-1.4.9.tar.bz2'
  head 'https://bitbucket.org/mkae/makeicns', :using => :hg
  homepage 'http://bitbucket.org/mkae/makeicns'

  def install
    #system "./configure", "--prefix=#{prefix}"
    system "make"
    system "cp makeicns /usr/local/bin/"
  end
end
