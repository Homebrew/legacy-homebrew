class Pstoedit < Formula
  homepage "http://www.pstoedit.net"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.70/pstoedit-3.70.tar.gz"
  sha256 "06b86113f7847cbcfd4e0623921a8763143bbcaef9f9098e6def650d1ff8138c"

  bottle do
    sha256 "5c1f3468dfae7c37570159489f5d9d351324648956bd302cdbcd4cd11db567a7" => :yosemite
    sha256 "3ac9609ace2f0b2225746186198b6c19d846f704a36c9dcc4880ea501ab84af1" => :mavericks
    sha256 "93170ba7013ef23b7dac6737b81c0084010595adf4a4f5e621650fa4a9177cb8" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "plotutils"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "xz" if MacOS.version < :mavericks

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "pdf", test_fixtures("test.ps"), "test.pdf"
    assert File.exist?("test.pdf")
  end
end
