class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.1.1.tar.gz"
  sha256 "e43d8aae7e80771dc700b3d960a0717d5d28156684a8ddc485572cbcbc4365e9"

  bottle do
    cellar :any
    sha256 "6140aa9ec7a7d6bcdfe29e196d4c6f49bd9f1d5fbcec2dd0f482d880796930c0" => :yosemite
    sha256 "31ca101a649a39f1a2e45aacb57465ae34b80eb6b5de663d397a899a35bfa0a3" => :mavericks
    sha256 "35fb2908a936f82fef0d09985648f977b35a47768d989093b5acede20e590556" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "ffmpeg"

  def install
    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ffmpegthumbnailer", "-i", test_fixtures("test.jpg"),
      "-o", "out.jpg"
    assert File.exist?(testpath/"out.jpg")
  end
end
