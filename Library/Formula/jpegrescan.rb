class Jpegrescan < Formula
  desc "Losslessly shrink any JPEG file"
  homepage "https://github.com/kud/jpegrescan"
  url "https://github.com/kud/jpegrescan/archive/1.0.0.tar.gz"
  sha256 "faa0f6009b16a67e6a847b40e7e736e9a5a716cefb64a7c470e266219db90d02"
  head "https://github.com/kud/jpegrescan.git"

  bottle :unneeded

  depends_on "jpeg"

  def install
    bin.install "jpegrescan"
  end

  test do
    system bin/"jpegrescan", "-v", test_fixtures("test.jpg"), testpath/"out.jpg"
    File.exist? testpath/"out.jpg"
  end
end
