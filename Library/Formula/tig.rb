require 'formula'

class Tig <Formula
  url 'http://jonas.nitro.dk/tig/releases/tig-0.16.2.tar.gz'
  homepage 'http://jonas.nitro.dk/tig/'
  md5 'd72b5d3437dbc538ea6f66c74988d75e'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    system "make install-doc-man"
  end
end
