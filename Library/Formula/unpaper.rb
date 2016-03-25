class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.eu/projects/unpaper"
  url "https://www.flameeyes.eu/files/unpaper-6.1.tar.xz"
  sha256 "237c84f5da544b3f7709827f9f12c37c346cdf029b1128fb4633f9bafa5cb930"
  revision 1

  bottle do
    cellar :any
    sha256 "7332b87cd5d0e087774f41fd0df69d5f26c616ca469a1d33cdfdcf4baa6153ff" => :el_capitan
    sha256 "c84f37be3e99fcf3d47bf4bbffba7192d451761a31056705f11d6a4a19dcd45a" => :yosemite
    sha256 "318d0e90644880ee357818a8d6d144d7ccc4873cca90a1ff77f1031f20994b93" => :mavericks
  end

  head do
    url "https://github.com/Flameeyes/unpaper.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.pbm").write <<-EOS.undent
      P1
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    system bin/"unpaper", testpath/"test.pbm", testpath/"out.pbm"
    File.exist? testpath/"out.pbm"
  end
end
