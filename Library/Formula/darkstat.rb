require 'formula'

class Darkstat < Formula
  homepage 'http://unix4lyfe.org/darkstat/'
  url 'http://unix4lyfe.org/darkstat/darkstat-3.0.717.tar.bz2'
  sha1 '3a774ab48f9523a3a47a5f2b89174843a1b6fa76'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{sbin}/darkstat", "--version"
  end
end
