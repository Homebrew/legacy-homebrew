require "formula"

class Kdiff3 < Formula
  homepage "http://kdiff3.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.98/kdiff3-0.9.98.tar.gz"
  sha1 "1390b4ca9c58316de49cb0aabb433f14ebf2dc3f"

  depends_on "qt"

  def install
    # configure builds the binary
    system "./configure", "qt4"
    prefix.install "releaseQt/kdiff3.app"
    bin.install_symlink prefix+"kdiff3.app/Contents/MacOS/kdiff3"
  end

  test do
    (testpath/"test1.in").write "test"
    (testpath/"test2.in").write "test"
    system "#{bin}/kdiff3", "--auto", "test1.in", "test2.in", "-o", "test.out"
    assert (testpath/"test.out").exist?
  end
end
