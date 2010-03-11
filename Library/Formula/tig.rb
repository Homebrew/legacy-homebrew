require 'formula'

class Tig <Formula
  url 'http://jonas.nitro.dk/tig/releases/tig-0.15.tar.gz'
  homepage 'http://jonas.nitro.dk/tig/'
  md5 '8f373a99823f6db241b66642075657d3'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
    system "make install-doc-man"
  end
end