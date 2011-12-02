require 'formula'

class Ddd < Formula
  url 'http://ftpmirror.gnu.org/ddd/ddd-3.3.12.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/ddd/ddd-3.3.12.tar.gz'
  homepage 'http://www.gnu.org/s/ddd/'
  md5 'c50396db7bac3862a6d2555b3b22c34e'

  depends_on 'lesstif'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-builtin-app-defaults", "--enable-builtin-manual",
                          "--prefix=#{prefix}"

    # From MacPorts:
    # make will build the executable "ddd" and the X resource file "Ddd" in the same directory,
    # as HFS+ is case-insensitive by default, this will loosely FAIL
    system "make EXEEXT=exe"

    ENV.deparallelize
    system "make install EXEEXT=exe"

    # rename after install
    system "mv", "#{bin}/dddexe", "#{bin}/ddd"
    system "ln", "-sF", "#{bin}/ddd", "#{HOMEBREW_PREFIX}/bin/ddd"
    system "rm", "-f", "#{HOMEBREW_PREFIX}/bin/dddexe"
  end
end
