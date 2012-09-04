require 'formula'

class Lemon < Formula
  url 'http://tx97.net/pub/distfiles/lemon-1.69.tar.bz2'
  homepage 'http://www.hwaci.com/sw/lemon/'
  sha1 '3f368f5f93c37890a025c3d803b3598a939d615f'

  def install
    lemon_share = share+'lemon'

    lemon_share.install 'lempar.c'

    # patch the parser generator to look for the 'lempar.c' template file where we've installed it
    lempar_path = lemon_share+'lempar.c'
    inreplace 'lemon.c', / = pathsearch\([^)]*\);/, " = \"#{lempar_path}\";"

    system ENV.cc, '-o', 'lemon', 'lemon.c'
    bin.install 'lemon'
  end
end
