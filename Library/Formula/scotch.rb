require 'formula'

class Scotch < Formula
  homepage 'https://gforge.inria.fr/projects/scotch'
  url 'https://gforge.inria.fr/frs/download.php/28933'
  version '5.1.12'
  md5 'f873ff2bad519f9be7bc7b117bbe0bc4'

  def install
    Dir.chdir 'src'
    ln_s 'Make.inc/Makefile.inc.i686_mac_darwin8', 'Makefile.inc'
    system 'make scotch'
    system 'make ptscotch'
    system "make", "install", "prefix=#{prefix}"
  end

end
