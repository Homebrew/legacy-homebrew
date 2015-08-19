class ExactImage < Formula
  desc "Image processing library"
  homepage "http://www.exactcode.com/site/open_source/exactimage"
  url "http://dl.exactcode.de/oss/exact-image/exact-image-0.9.1.tar.bz2"
  sha256 "79e6a58522897f9740aa3b5a337f63ad1e0361a772141b24aaff2e31264ece7d"

  bottle do
    sha256 "77f3d83c27eca6a0804c9edda52b4d49799a37b03a65f8316fa0c7e256437681" => :yosemite
    sha256 "57fab089650fdbf201037ae199caf049db95ab42db3bc16d92e6323db09fa866" => :mavericks
    sha256 "9526777ff0d57b8a8c56f23039c62495b02b419eb04e4d6e01d57b9f909594d5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libagg"
  depends_on "freetype" => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--without-libungif"
    system "make", "install"
  end

  test do
    system "#{bin}/bardecode"
  end
end
