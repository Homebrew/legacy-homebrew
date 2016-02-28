class Aggregate < Formula
  desc "Optimizes lists of prefixes to reduce list lengths"
  homepage "http://freecode.com/projects/aggregate/"
  url "https://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz"
  sha256 "166503005cd8722c730e530cc90652ddfa198a25624914c65dffc3eb87ba5482"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "87507a739f2bd5ba57ccd23b34f2b7c41d68a897c128231dbbc32ba23b869ed5" => :el_capitan
    sha256 "813ccd28b00f94e1574079f7f6816858e32c5d8f9a964b783307d25c7e449d2b" => :yosemite
    sha256 "169598a0d41382215ba51ed0c377c98857804e82fb1658414dd04ee94ddbb993" => :mavericks
  end

  # Note - Freecode is no longer being updated & an alternative homepage should be found if possible.

  conflicts_with "crush-tools", :because => "both install an `aggregate` binary"

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
