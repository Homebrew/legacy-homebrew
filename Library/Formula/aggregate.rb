class Aggregate < Formula
  desc "Optimizes lists of prefixes to reduce list lengths"
  homepage "http://freecode.com/projects/aggregate/"
  url "ftp://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz"
  sha256 "166503005cd8722c730e530cc90652ddfa198a25624914c65dffc3eb87ba5482"

  bottle do
    cellar :any
    sha256 "6c89bcfc86345dc4367c13ac78ac3a1bfaef5a43d1003afc741882a39496c9c6" => :mavericks
    sha256 "90f9a420fa1edc97cbaed1471850eba494970eb392874a562c568f94f18832e6" => :mountain_lion
    sha256 "13616e0a1b9502dd61abebe8a780688f694a777ad48d2bf19cf64f0a70c3d9f6" => :lion
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
