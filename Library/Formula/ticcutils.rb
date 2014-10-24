require "formula"

class Ticcutils < Formula
  homepage "http://ilk.uvt.nl/ticcutils/"
  url "http://software.ticc.uvt.nl/ticcutils-0.7.tar.gz"
  sha1 "f58ec1a6b64a0eebc1a8a74ef625cf6398a5fafc"

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

