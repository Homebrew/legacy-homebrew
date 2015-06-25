class Pdf2svg < Formula
  desc "PDF converter to SVG"
  homepage "http://www.cityinthesky.co.uk/opensource/pdf2svg"
  url "https://github.com/db9052/pdf2svg/archive/v0.2.3.tar.gz"
  sha256 "4fb186070b3e7d33a51821e3307dce57300a062570d028feccd4e628d50dea8a"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-x11"
    cellar :any
    sha256 "852f856ee819872e3369a9c9aac6f8596b2efa2a5b0489fdf75fa7b83d0f8249" => :yosemite
    sha256 "048368bd4847a9ae310efcb699b0a22f6e2ef7072127187e5ba2b43430cd2566" => :mavericks
    sha256 "d02bbc276dab02d3c6290f981ce7b91b9f3c271171d9fedfc0bff87e630c8fd5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    curl "-O", "http://partners.adobe.com/public/developer/en/xml/AdobeXMLFormsSamples.pdf"
    system "#{bin}/pdf2svg", "AdobeXMLFormsSamples.pdf", "test.svg"
  end
end
