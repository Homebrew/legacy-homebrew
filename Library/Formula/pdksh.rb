require 'formula'

class Pdksh < Formula
  homepage 'http://www.cs.mun.ca/~michael/pdksh/'
  url 'http://www.cs.mun.ca/~michael/pdksh/files/pdksh-5.2.14.tar.gz'
  sha1 '8b022e45de7691ef330f13b0981f0cff30b4047d'

  # Use a sort command that works with Leopard and up
  patch :p0 do
    url "https://trac.macports.org/export/90549/trunk/dports/shells/pdksh/files/patch-siglist.sh.diff"
    sha1 "009830f37b7be86d1a1a2f187c82c25da6d9b418"
  end

  def install
    # --mandir does not work for this
    inreplace "Makefile.in",
                "$(prefix)/man/man$(manext)",
                "$(prefix)/share/man/man1"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
