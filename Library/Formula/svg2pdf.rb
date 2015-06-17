class Svg2pdf < Formula
  desc "Renders SVG images to a PDF file (using Cairo)"
  homepage "http://cairographics.org/"
  url "http://cairographics.org/snapshots/svg2pdf-0.1.3.tar.gz"
  sha256 "854a870722a9d7f6262881e304a0b5e08a1c61cecb16c23a8a2f42f2b6a9406b"

  bottle do
    cellar :any
    sha256 "0ff81cf4177cd94c385c98b89c9620235c78fc154a6781996b4146d3777d4c5f" => :yosemite
    sha256 "ec23a2efe2fe015c475e42ceb44674e1ec4ba944081e9ce212e87ce25403fef5" => :mavericks
    sha256 "9d1880e5e4bfbc3ef676415a3c8f0480c312c3619b07efdb3249191e8f9d47a0" => :mountain_lion
  end

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
