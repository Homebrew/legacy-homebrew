class Svg2png < Formula
  desc "SVG to PNG converter"
  homepage "http://cairographics.org/"
  url "http://cairographics.org/snapshots/svg2png-0.1.3.tar.gz"
  sha256 "e658fde141eb7ce981ad63d319339be5fa6d15e495d1315ee310079cbacae52b"

  bottle do
    cellar :any
    sha256 "6bdd52f199a81f7383199e6ec238486ca877976dcb90075f8f0872638ef517d1" => :yosemite
    sha256 "db17ab6f2ee3343f874c810069ad3e2b16d858d496c5f61422b607245995f896" => :mavericks
    sha256 "c1e7e5c1523c76fcdd3a994864b0c9b68e57800c95ea4ddaffd99cf5f82fad63" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libsvg-cairo"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/svg2png", test_fixtures("test.svg"), "test.png"
    assert File.exist? "test.png"
  end
end
