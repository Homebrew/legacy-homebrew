class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.1.1.tar.gz"
  sha256 "e43d8aae7e80771dc700b3d960a0717d5d28156684a8ddc485572cbcbc4365e9"
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git"

  bottle do
    cellar :any
    revision 1
    sha256 "3d8ab9f72ae234c9ef9bc8006c3d207f4c113d54fe4847aa63e13211fa9eeafd" => :el_capitan
    sha256 "784e2a31b78ae51bb29dd5007e78091e61fb7d1d13065a4754ba42d5b8bbfc49" => :yosemite
    sha256 "7ee9048a68c5e75ca90ffe418a96e0bd8af4c4b038c093b3cb75358d3a7d0587" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "ffmpeg"

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    args = std_cmake_args
    args << "-DENABLE_GIO=ON"
    args << "-DENABLE_THUMBNAILER=ON"

    system "cmake", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ffmpegthumbnailer", "-i", test_fixtures("test.jpg"),
      "-o", "out.jpg"
    assert File.exist?(testpath/"out.jpg")
  end
end
