class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "http://www.catb.org/~esr/ascii/ascii-3.15.tar.gz"
  sha256 "ace1db8b64371d53d9ad420d341f2b542324ae70437e37b4b75646f12475ff5f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7b74752e577efa60d98732e688910980436e42fbbf1f77a041cb2af458789f5" => :yosemite
    sha256 "56cec53206fc55f1fcd63b09b69c1afe858f4097ac6a460b7c9c07fbdfeaa0ed" => :mavericks
    sha256 "1a25c357bde021b59904fc8184c45a5eb85ae6be507a1e100aa79d441ad07943" => :mountain_lion
  end

  head do
    url "git://thyrsus.com/repositories/ascii.git"
    depends_on "xmlto" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output(bin/"ascii 0x0a")
  end
end
