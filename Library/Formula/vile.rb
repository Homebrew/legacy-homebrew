class Vile < Formula
  desc "Vi Like Emacs"
  homepage "http://invisible-island.net/vile/vile.html"
  url "http://invisible-island.net/datafiles/release/vile.tar.gz"
  version "9.8"
  sha256 "dea31c023aa7a90271056c712c826a5d16d19ad61df5cf5f299aa1025af280d6"

  depends_on "reflex"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-builtin-filters"
    system "make", "install"
  end

  test do
    system "#{bin}/vile", "-V"
  end
end
