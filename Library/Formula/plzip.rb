class Plzip < Formula
  desc "Data compressor"
  homepage "http://www.nongnu.org/lzip/plzip.html"
  url "http://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.4.tar.gz"
  sha256 "2a152ee429495cb96c22a51b618d1d19882db3e24aff79329d9c755a2a2f67bb"

  bottle do
    cellar :any
    sha1 "c555c0fff979bfdbd28e91b992395bc1f78c8ad1" => :yosemite
    sha1 "991dad931e4083afa7a5c50ebbf9bb8459bb266e" => :mavericks
    sha1 "3371a5b356a73f401951dd621c2d5782be2b275b" => :mountain_lion
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
