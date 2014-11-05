require "formula"

class Snow < Formula
  homepage "http://www.darkside.com.au/snow/"
  url "http://www.darkside.com.au/snow/snow-20130616.tar.gz"
  sha1 "b7cc0214d24cef44f50cd9069a0052f8dcd54176"

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
