class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.1.1.tar.gz"
  sha256 "e43d8aae7e80771dc700b3d960a0717d5d28156684a8ddc485572cbcbc4365e9"

  bottle do
    cellar :any
    sha256 "1af9077b6ce1748399965fdb5b626def8f5cd23b4c867b4af6739aded3ef88b7" => :el_capitan
    sha256 "75d88ac9cd1b220e64215064a5949fe0f1785867e81b8be2b422f82b25cb4794" => :yosemite
    sha256 "908c358ea02baf6a7b10a0239fdb5e4aac238ae4268b2e4e36d4d7721a9c3c94" => :mavericks
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
