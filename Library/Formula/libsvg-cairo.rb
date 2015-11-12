class LibsvgCairo < Formula
  desc "SVG rendering library using Cairo"
  homepage "http://cairographics.org/"
  url "http://cairographics.org/snapshots/libsvg-cairo-0.1.6.tar.gz"
  sha256 "a380be6a78ec2938100ce904363815a94068fca372c666b8cc82aa8711a0215c"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "84c8809a89f2f46b0c596611a1b340de5eaca8152d36892cd8ec8226225953b2" => :el_capitan
    sha1 "8e6ca63907708f900f23e1da966a05731ff966eb" => :yosemite
    sha1 "0ee61ff2dc93ca0eb2536c931bd187bb7d07a7ff" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libsvg"
  depends_on "libpng"
  depends_on "cairo"

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
