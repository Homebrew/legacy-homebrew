class Paq8px < Formula
  desc "Data compression archivers"
  homepage "http://dhost.info/paq8/"
  url "http://dhost.info/paq8/paq8px_v69.zip"
  sha256 "d39440e57a37a2be1d1bbd2ba9a5b747334238cd8d3538e709233010a5129f77"

  def install
    system ENV.cxx, "paq8px_v69.cpp", "-DUNIX", "-DNOASM", "-o", "paq8px"
    bin.install "paq8px"
  end

  test do
    touch "test.txt"
    system "echo", "Foobarbaz", ">", "test.txt"
    system "yes | #{bin}/paq8px test.txt"
    system "yes | #{bin}/paq8px test.txt.paq8px"
    rm "test.txt"
    system "yes | #{bin}/paq8px test.txt.paq8px"
    rm "test.txt"
    rm "test.txt.paq8px"
  end
end
