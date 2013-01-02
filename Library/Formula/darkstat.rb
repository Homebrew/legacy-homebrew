require 'formula'


class Darkstat < Formula
  homepage 'http://unix4lyfe.org/darkstat/'
  url 'http://unix4lyfe.org/darkstat/darkstat-3.0.715.tar.bz2'
  sha1 'e635f7ae0c6dfe3a7d1fac3855ca733187163973'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{sbin}/darkstat --version"
  end
end
