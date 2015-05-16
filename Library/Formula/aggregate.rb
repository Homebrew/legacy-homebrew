require 'formula'

class Aggregate < Formula
  homepage 'http://freecode.com/projects/aggregate/'
  url 'ftp://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz'
  sha1 '13420baf4f3f93dbed3c380ab6cca175609c5d7d'

  bottle do
    cellar :any
    sha1 "94eb9307d2f12e20663b6c47e3a60317ab7ac6e6" => :mavericks
    sha1 "b2f030ab1484299fa1fffbcfbcd4e84e8726e1bc" => :mountain_lion
    sha1 "c2a27bf04eb3efcafbf4b271e7cfb7b520eac7f4" => :lion
  end

  # Note - Freecode is no longer being updated & an alternative homepage should be found if possible.

  conflicts_with 'crush-tools', :because => 'both install an `aggregate` binary'

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
