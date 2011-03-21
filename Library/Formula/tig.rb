require 'formula'

<<<<<<< HEAD
<<<<<<< HEAD
class Tig <Formula
  url 'http://jonas.nitro.dk/tig/releases/tig-0.16.2.tar.gz'
=======
=======
>>>>>>> 0fcb6d84066603c90f68a35dddd3d709ceb82070
class Tig < Formula
  url 'http://jonas.nitro.dk/tig/releases/tig-0.17.tar.gz'
>>>>>>> 0fcb6d84066603c90f68a35dddd3d709ceb82070
  homepage 'http://jonas.nitro.dk/tig/'
  md5 'd72b5d3437dbc538ea6f66c74988d75e'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    system "make install-doc-man"
  end
end
