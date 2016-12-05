class Reflex < Formula
  desc "Variant of the flex fast lexical scanner"
  homepage "http://invisible-island.net/reflex/reflex.html"
  url "http://invisible-island.net/datafiles/release/reflex.tar.gz"
  version "2.5.4-20131209"
  sha256 "0ebbfa2d564e1e211ccf862ad6f12dbffa784164ea4492d08b9d50a592aaf0e2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/reflex", "--version"
  end
end
