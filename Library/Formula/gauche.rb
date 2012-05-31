require 'formula'

class Gauche < Formula
  homepage 'http://practical-scheme.net/gauche/'
  url 'http://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.3.2.tgz'
  sha1 'e2e3f4553674d02a0800c981325de3fef858d9f6'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking',
                          '--enable-multibyte=utf-8'
    system "make"
    system "make check"
    system "make install"
  end
end
