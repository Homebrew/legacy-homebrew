class Snow < Formula
  desc "Whitespace steganography: coded messages using whitespace"
  homepage "http://www.darkside.com.au/snow/"
  url "http://www.darkside.com.au/snow/snow-20130616.tar.gz"
  sha256 "c0b71aa74ed628d121f81b1cd4ae07c2842c41cfbdf639b50291fc527c213865"

  bottle do
    cellar :any
    sha256 "cd83ae6c6d087bdae0a3116e254cd2ebc229bdd587f143d97e69777574e5ef76" => :yosemite
    sha256 "d559c8e54528d7372872cb933eeb13288f3f3de3749f1b28e5862541012e49e3" => :mavericks
    sha256 "79ada7520a8147bd49ed617a3d62f2e83ec7942e9ed32105e7cfb4bb1940e4e2" => :mountain_lion
  end

  def install
    system "make"
    bin.install "snow"
    man1.install "snow.1"
  end

  test do
    touch "in.txt"
    touch "out.txt"
    system "#{bin}/snow", "-C", "-m", "'Secrets Abound Here'", "-p",
           "'hello world'", "in.txt", "out.txt"
    # The below should get the response 'Secrets Abound Here' when testing.
    system "#{bin}/snow", "-C", "-p", "'hello world'", "out.txt"
  end
end
