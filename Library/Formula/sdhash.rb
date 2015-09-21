class Sdhash < Formula
  desc "Tool for correlating binary blobs of data"
  homepage "http://roussev.net/sdhash/sdhash.html"
  url "http://roussev.net/sdhash/releases/packages/sdhash-3.1.tar.gz"
  sha256 "b991d38533d02ae56e0c7aeb230f844e45a39f2867f70fab30002cfa34ba449c"
  revision 1

  bottle do
    cellar :any
    sha256 "f42674a03668b9187d618b457240de90e676bcb311fa1946b5a236685fbf2860" => :el_capitan
    sha256 "97b9d8bd401ec5976b17794da9b907433c18a839c9360fa574d51ea19de245bf" => :yosemite
    sha256 "bb4951185ede8233e4dccb48fa0da53a812e1af61dac9babbdf41e781b78a1e9" => :mavericks
  end

  depends_on "openssl"

  def install
    inreplace "Makefile" do |s|
      # Remove space between -L and the path (reported upstream)
      s.change_make_var! "LDFLAGS", "-L. -L./external/stage/lib -lboost_regex -lboost_system -lboost_filesystem -lboost_program_options -lc -lm -lcrypto -lboost_thread -lpthread"
    end
    system "make", "boost"
    system "make", "stream"
    bin.install "sdhash"
    man1.install Dir["man/*.1"]
  end

  test do
    system "#{bin}/sdhash"
  end
end
