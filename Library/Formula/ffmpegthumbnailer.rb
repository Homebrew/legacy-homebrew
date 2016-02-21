class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.1.1.tar.gz"
  sha256 "e43d8aae7e80771dc700b3d960a0717d5d28156684a8ddc485572cbcbc4365e9"
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git"

  bottle do
    cellar :any
    revision 2
    sha256 "df373fd0bc41350d6869b1d91745678ebf51e8e79243235263b65ef208c48e66" => :el_capitan
    sha256 "4d6dac66db9eb7f3eddb1614e73d9ec49e9ddecfbd33162ac0b63e8712858115" => :yosemite
    sha256 "ec34bb36af0a38c0d6d94943a8b954cce6dc193a1982b2065721e685a6f0c086" => :mavericks
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
