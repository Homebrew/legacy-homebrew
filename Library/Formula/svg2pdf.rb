class Svg2pdf < Formula
  homepage "http://cairographics.org/"
  url "http://cairographics.org/snapshots/svg2pdf-0.1.3.tar.gz"
  sha256 "854a870722a9d7f6262881e304a0b5e08a1c61cecb16c23a8a2f42f2b6a9406b"

  depends_on "pkg-config" => :build
  depends_on "libsvg-cairo"

  resource("svg.svg") do
    url "https://raw.githubusercontent.com/mathiasbynens/small/master/svg.svg"
    sha256 "900fbe934249ad120004bd24adf66aad8817d89586273c0cc50e187bddebb601"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    resource("svg.svg").stage do
      system "#{bin}/svg2pdf", "svg.svg", "test.pdf"
      assert File.exist? "test.pdf"
    end
  end
end
