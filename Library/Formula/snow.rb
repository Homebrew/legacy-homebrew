require "formula"

class Snow < Formula
  desc "Whitespace steganography: coded messages using whitespace"
  homepage "http://www.darkside.com.au/snow/"
  url "http://www.darkside.com.au/snow/snow-20130616.tar.gz"
  sha1 "b7cc0214d24cef44f50cd9069a0052f8dcd54176"

  bottle do
    cellar :any
    sha1 "57229cfcf76e0643a19f3b2e8eeabe5796319d01" => :yosemite
    sha1 "326c1e051f957c183f6aaef4e97782c1795945e2" => :mavericks
    sha1 "f8e1b3e318c15a62190a7bf59c0309f2bc7e8de2" => :mountain_lion
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
