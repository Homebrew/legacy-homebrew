require "formula"

class Paq8px < Formula
  homepage "http://dhost.info/paq8/"
  url "http://dhost.info/paq8/paq8px_v69.zip"
  sha1 "77667a3c61b858d71897f47fc4c4d8eabf3d715c"

  def install
    system ENV.cxx, "paq8px_v69.cpp", "-DUNIX", "-DNOASM", "-o", "paq8px"
    bin.install "paq8px"
  end

  test do
    system "touch test.txt"
    system "echo Foobarbaz > test.txt"
    system "yes | #{bin}/paq8px test.txt"
    system "yes | #{bin}/paq8px test.txt.paq8px"
    system "rm test.txt"
    system "yes | #{bin}/paq8px test.txt.paq8px"
    system "rm test.txt"
    system "rm test.txt.paq8px"
  end
end
