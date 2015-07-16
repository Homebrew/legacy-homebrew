class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.0.10.tar.gz"
  sha256 "68125d98d72347a676ab2f9bc93ddd3537ff39d6a81145e2a58a6de5d3958e4e"

  bottle do
    cellar :any
    sha1 "b33cd322e1dd892c3ff492647a9d7fc4b8766388" => :mavericks
    sha1 "18607817d97b20f2fa3a886ac472f3b63e6cb62d" => :mountain_lion
    sha1 "052f2227429e215db559dcbddb2cdca838111d59" => :lion
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
