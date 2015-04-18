class Ascii < Formula
  homepage "http://www.catb.org/~esr/ascii/"
  url "http://www.catb.org/~esr/ascii/ascii-3.15.tar.gz"
  sha256 "ace1db8b64371d53d9ad420d341f2b542324ae70437e37b4b75646f12475ff5f"

  head do
    url "git://thyrsus.com/repositories/ascii.git"
    depends_on "xmlto" => :build
  end

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = HOMEBREW_PREFIX/"etc/xml/catalog"
    end
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert shell_output(bin/"ascii 0x0a").include?("Official name: Line Feed")
  end
end
