require 'formula'

class Gauche < Formula
  homepage 'http://practical-scheme.net/gauche/'
  url 'https://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.4.tgz'
  sha1 '2f0068d19adbc8e7fd3c04ab8e6576d0fac21ad6'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking',
                          '--enable-multibyte=utf-8'
    system "make"
    system "make check"
    system "make install"
  end
end
