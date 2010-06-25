require 'formula'

class Tig <Formula
  url 'http://jonas.nitro.dk/tig/releases/tig-0.16.tar.gz'
  homepage 'http://jonas.nitro.dk/tig/'
  md5 '684572d93033d6cbfc5ee71cffe02935'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    system "make install-doc-man"
  end
end
