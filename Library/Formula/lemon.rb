require 'formula'

class Lemon < Formula
  homepage 'http://www.hwaci.com/sw/lemon/'
  url 'http://tx97.net/pub/distfiles/lemon-1.69.tar.bz2'
  sha1 '3f368f5f93c37890a025c3d803b3598a939d615f'

  def install
    (share/'lemon').install 'lempar.c'

    # patch the parser generator to look for the 'lempar.c' template file where we've installed it
    inreplace 'lemon.c', / = pathsearch\([^)]*\);/, " = \"#{share}/lemon/lempar.c\";"

    system ENV.cc, '-o', 'lemon', 'lemon.c'
    bin.install 'lemon'
  end
end
