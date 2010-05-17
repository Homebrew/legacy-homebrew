require 'formula'

class Valgrind <Formula
  url 'http://www.valgrind.org/downloads/valgrind-3.5.0.tar.bz2'
  homepage 'http://www.valgrind.org/'
  md5 'f03522a4687cf76c676c9494fcc0a517'

  def install
    opoo "Valgrind 3.5.0 doesn't support Snow Leopard; see caveats." if MACOS_VERSION > 10.5
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end

  def caveats
    if MACOS_VERSION > 10.5
      "Valgrind does not work on Snow Leopard / 64-bit mode. See:\n"+
      "    http://bugs.kde.org/show_bug.cgi?id=205241"
    end
  end
end
