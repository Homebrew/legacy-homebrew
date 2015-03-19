require "formula"

class Wrk < Formula
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/4.0.0.tar.gz"
  sha1 "a64f0279f4d5c04c0acece5af80981436aaa2dc0"
  head "https://github.com/wg/wrk.git"

  bottle do
    cellar :any
    sha256 "585308cd09472906c2167739795b9d1192a9980bc24016d9752e5d4c6b3db694" => :yosemite
    sha256 "4e8783cd1410197b4245ceb9e7c4ca01691e8c9ebc6e77d91c918426290f73f2" => :mavericks
    sha256 "e0d7e6087fd7b8afaf3ed40480c66bafad18d43685cb6237258e9a5e397b1c8d" => :mountain_lion
  end

  depends_on "openssl"

  conflicts_with "wrk-trello", :because => "both install `wrk` binaries"

  def install
    ENV.j1
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W{#{bin}/wrk -c 1 -t 1 -d 1 http://example.com/}
  end
end
