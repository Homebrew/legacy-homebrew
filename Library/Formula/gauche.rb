require 'formula'

class Gauche < Formula
  homepage 'http://practical-scheme.net/gauche/'
  url 'http://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.3.3.tgz'
  sha1 '71d7ca3eceb9adc1de33455c1616cbed89d226f7'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking',
                          '--enable-multibyte=utf-8'
    system "make"
    system "make check"
    system "make install"
  end
end
