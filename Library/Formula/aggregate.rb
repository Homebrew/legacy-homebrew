require 'formula'

class Aggregate < Formula
  homepage 'http://freshmeat.net/projects/aggregate/'
  url 'ftp://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz'
  sha1 '13420baf4f3f93dbed3c380ab6cca175609c5d7d'

  def install
    bin.mkpath
    man1.mkpath

    # Makefile doesn't respect --mandir or MANDIR
    inreplace "Makefile.in", "$(prefix)/man/man1", "$(prefix)/share/man/man1"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"
  end
end
