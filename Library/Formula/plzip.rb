class Plzip < Formula
  desc "Data compressor"
  homepage "http://www.nongnu.org/lzip/plzip.html"
  url "http://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.3.tar.gz"
  sha1 "e339c06093d8e7905390cc7c39f28f6198a66471"

  bottle do
    cellar :any
    sha1 "c555c0fff979bfdbd28e91b992395bc1f78c8ad1" => :yosemite
    sha1 "991dad931e4083afa7a5c50ebbf9bb8459bb266e" => :mavericks
    sha1 "3371a5b356a73f401951dd621c2d5782be2b275b" => :mountain_lion
  end

  devel do
    url "http://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.4-pre1.tar.gz"
    sha1 "817b9d1635be6db35907733f7eedcd2b7642ccdd"
    version "1.4-pre1"
  end

  depends_on "lzlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make"
    system "make", "check"
    system "make", "-j1", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
