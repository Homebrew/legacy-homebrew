class Svg2png < Formula
  homepage "http://cairographics.org/"
  url "http://cairographics.org/snapshots/svg2png-0.1.3.tar.gz"
  sha256 "e658fde141eb7ce981ad63d319339be5fa6d15e495d1315ee310079cbacae52b"

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
