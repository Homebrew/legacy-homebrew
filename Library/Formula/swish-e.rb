class SwishE < Formula
  desc "System for indexing collections of web pages"
  homepage "http://swish-e.org/"
  url "http://swish-e.org/distribution/swish-e-2.4.7.tar.gz"
  sha256 "5ddd541ff8ecb3c78ad6ca76c79e620f457fac9f7d0721ad87e9fa22fe997962"

  bottle do
    sha256 "3bbf20ce0627fe663d06fbfe8aa42bb0865e122365c118992bd76fe01b9c174d" => :yosemite
    sha256 "f6914d79d603e8ae515bd2260ab6f372a57871981f50428314fe09b6500d88e6" => :mavericks
    sha256 "11cb805ebe8e0b303b94720775ff0dd1ee60d5993579197214cb3269d72ad677" => :mountain_lion
  end

  depends_on "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"swish-e", "-S", "fs", "-i", *Dir[HOMEBREW_PREFIX/"*.md"]
    output = shell_output("#{bin}/swish-e -w respect")
    assert_match /^# Number of hits: [1-9]\d*$/, output
  end
end
