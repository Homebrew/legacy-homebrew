class ExactImage < Formula
  homepage "http://www.exactcode.com/site/open_source/exactimage"
  url "http://dl.exactcode.de/oss/exact-image/exact-image-0.9.1.tar.bz2"
  sha256 "79e6a58522897f9740aa3b5a337f63ad1e0361a772141b24aaff2e31264ece7d"

  depends_on "pkg-config" => :build
  depends_on "libagg"
  depends_on "freetype" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bardecode"
  end
end
