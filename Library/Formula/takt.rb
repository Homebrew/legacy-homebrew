class Takt < Formula
  desc "text-based music programming language"
  homepage "http://takt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/takt/takt-0.309-src.tar.gz"
  sha256 "44fca667d610fba15deb441dd44e5b87dabbe5619d7fa8a13f5c8c1f054dd509"

  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-lispdir=#{share}/emacs/site-lisp/#{name}"
    system "make", "install"
  end

  test do
    system bin/"takt", "-o etude1.mid", pkgshare/"examples/etude1.takt"
  end
end
