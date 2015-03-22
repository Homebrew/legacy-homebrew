class Avce00 < Formula
  homepage "http://avce00.maptools.org/avce00/index.html"
  url "http://avce00.maptools.org/dl/avce00-2.0.0.tar.gz"
  sha256 "c0851f86b4cd414d6150a04820491024fb6248b52ca5c7bd1ca3d2a0f9946a40"

  conflicts_with "gdal", :because => "both install a cpl_conv.h header"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "avcimport",  "avcexport", "avcdelete", "avctest"
    lib.install "avc.a"
    include.install Dir["*.h"]
  end

  test do
    touch testpath/"test"
    system "#{bin}/avctest", "-b", "test"
  end
end
