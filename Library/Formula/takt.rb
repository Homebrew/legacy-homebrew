class Takt < Formula
  desc "a text-based music programming language"
  homepage "http://takt.sourceforge.net"
  url "http://sourceforge.net/projects/takt/files/takt-0.309-src.tar.gz"
  version "0.309"
  sha256 "44fca667d610fba15deb441dd44e5b87dabbe5619d7fa8a13f5c8c1f054dd509"

  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"takt", "-o etude1.mid", pkgshare/"examples/etude1.takt"
  end
end
