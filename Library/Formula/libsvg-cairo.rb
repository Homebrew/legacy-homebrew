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
    sha256 "7375866aa26344d381892626dccc558052addb96bb2c7f76968a5c7a530ee010" => :yosemite
    sha256 "45bcab7ac22c1ade9e3f3cbf81c77224e8e66be0dad99b23445ecf6805aa853a" => :mavericks
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
