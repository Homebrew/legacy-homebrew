class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.2.tar.gz"
  sha256 "b39a4814a0f53f5e09a9192c41e3e51bd658843f770399023a963eb064f6409d"

  bottle do
    cellar :any
    sha256 "5684d45dcd517ae87312fff00b4ac0eb16f3343ddd8df25d39206839b022cadd" => :yosemite
    sha256 "5d007d42d495824c89f50b8eeabd35deaf32abf343573f30d68502bf8979d157" => :mavericks
    sha256 "53345a758e705765c6473327cb91c591ab50858144490973549f89750b31656d" => :mountain_lion
  end

  option "without-check", "Skip compile-time make checks."

  depends_on "doxygen" => [:optional, :build]

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"

    system "make", "check" if build.with? "check"
    system "make", "install"

    if build.with? "doxygen"
      system "doxygen"
      doc.install "html"
    end
  end

  test do
    assert File.exist? "#{lib}/libfreexl.a"
  end
end
