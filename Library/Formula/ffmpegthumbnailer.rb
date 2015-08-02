class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.0.10.tar.gz"
  sha256 "68125d98d72347a676ab2f9bc93ddd3537ff39d6a81145e2a58a6de5d3958e4e"

  bottle do
    cellar :any
    sha256 "6140aa9ec7a7d6bcdfe29e196d4c6f49bd9f1d5fbcec2dd0f482d880796930c0" => :yosemite
    sha256 "31ca101a649a39f1a2e45aacb57465ae34b80eb6b5de663d397a899a35bfa0a3" => :mavericks
    sha256 "35fb2908a936f82fef0d09985648f977b35a47768d989093b5acede20e590556" => :mountain_lion
  end

  # Look for upstream to replace the GNU build process with CMake in the future
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "ffmpeg"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ffmpegthumbnailer", "-i", test_fixtures("test.jpg"),
      "-o", "out.jpg"
    assert File.exist?(testpath/"out.jpg")
  end
end
