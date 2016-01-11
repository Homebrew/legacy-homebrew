class ExactImage < Formula
  desc "Image processing library"
  homepage "https://exactcode.com/opensource/exactimage/"
  url "https://dl.exactcode.de/oss/exact-image/exact-image-0.9.1.tar.bz2"
  sha256 "79e6a58522897f9740aa3b5a337f63ad1e0361a772141b24aaff2e31264ece7d"

  bottle do
    revision 1
    sha256 "70d2c9f04047842003395c40aab94e4d5f5f2505ed2a1caead3f2bc3b19fbb79" => :el_capitan
    sha256 "0d4f8c47de237fad9ff663f7be0227694bc2cc2010a9e909c8d7e98ee3448677" => :yosemite
    sha256 "981c8cee58d2985735f8716d1fff0db690de70eeb0e848eb0f8e340737b4134f" => :mavericks
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
