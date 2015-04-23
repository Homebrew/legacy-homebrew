class JpegArchive < Formula
  homepage "https://github.com/danielgtaylor/jpeg-archive"
  url "https://github.com/danielgtaylor/jpeg-archive/archive/2.1.1.tar.gz"
  sha256 "494534f5308f99743f11f3a7c151a8d5ca8a5f1f8b61ea119098511d401bc618"

  depends_on "mozjpeg"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/jpeg-recompress", test_fixtures("test.jpg"), "output.jpg"
  end
end
