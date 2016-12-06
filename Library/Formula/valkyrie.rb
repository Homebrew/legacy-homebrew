require 'formula'

class Valkyrie < Formula
  homepage 'http://valgrind.org/downloads/guis.html'
  url 'http://valgrind.org/downloads/valkyrie-2.0.0.tar.bz2'
  md5 'a411dfb803f548dae5f988de0160aeb5'
  head 'svn://svn.valgrind.org/valkyrie/trunk', :using => :svn

  depends_on 'qt'
  depends_on 'valgrind'

  def install
    system "qmake", "PREFIX=#{prefix}"
    system "make install"

    #Move app to where homebrew expects it to be
    system "mv #{bin}/valkyrie.app #{prefix}"
  end
end
