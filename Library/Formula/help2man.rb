class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "http://ftpmirror.gnu.org/help2man/help2man-1.47.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/help2man/help2man-1.47.2.tar.xz"
  sha256 "c4c5606773e51039a06b7328ed4934913df142747a9a185d2a6ab9300d7f3f7c"

  bottle do
    cellar :any
    sha256 "40c09efa98f1d4a76aef58206a6e161b21f2d34e86959f1272f785a68c3f7734" => :yosemite
    sha256 "c0fd556bfa0a791590d4233c1856e492605a9078735789927dd1c2ec0653e6c2" => :mavericks
    sha256 "bc3d57b4a32e616fbc8d7da3610441a710a7eb6f855b839de0e7a1b91e1cb712" => :mountain_lion
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cmd = "#{bin}/help2man #{bin}/help2man"
    assert_match(/"help2man #{version}"/, shell_output(cmd))
  end
end
