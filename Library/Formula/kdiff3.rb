class Kdiff3 < Formula
  desc "Compare and merge 2 or 3 files or directories"
  homepage "http://kdiff3.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.98/kdiff3-0.9.98.tar.gz"
  sha256 "802c1ababa02b403a5dca15955c01592997116a24909745016931537210fd668"

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
