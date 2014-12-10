require 'formula'

class Valkyrie < Formula
  homepage 'http://valgrind.org/downloads/guis.html'
  url 'http://valgrind.org/downloads/valkyrie-2.0.0.tar.bz2'
  sha1 '999a6623eea5b7b8d59b55d59b8198f4fcd08add'

  head 'svn://svn.valgrind.org/valkyrie/trunk'

  depends_on 'qt'
  depends_on 'valgrind'

  def install
    system "qmake", "PREFIX=#{prefix}"
    system "make install"
    prefix.install bin/'valkyrie.app'
  end
end
