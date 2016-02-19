class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.eu/projects/unpaper"
  url "https://www.flameeyes.eu/files/unpaper-6.1.tar.xz"
  sha256 "237c84f5da544b3f7709827f9f12c37c346cdf029b1128fb4633f9bafa5cb930"
  revision 1

  bottle do
    cellar :any
    sha256 "b0bb6934af1df4298a04c6d5520aac607184025cc2217d0e139a4a004d43410f" => :yosemite
    sha256 "bc7e3b90cdc1b5d285788e33024afc81a5b3632485346e34fb852d2d86917899" => :mavericks
    sha256 "a4cd97fa61392b0092b5b61e459e5e9a956193715fc6ff19a582ec6190629b38" => :mountain_lion
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
