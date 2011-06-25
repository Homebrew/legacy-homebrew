require 'formula'

class Tig < Formula
  url 'http://jonas.nitro.dk/tig/releases/tig-0.17.tar.gz'
  homepage 'http://jonas.nitro.dk/tig/'
  md5 'f373343199422c59518776db448dec0e'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    system "make install-doc-man"
  end
end
