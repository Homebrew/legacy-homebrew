require "formula"

class Wrk < Formula
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/3.1.1.tar.gz"
  sha1 "7cea5d12dc5076fed1a1c730bd3e6eba832a8f61"
  head "https://github.com/wg/wrk.git"
  revision 1

  bottle do
    cellar :any
    sha1 "98ff393448680c3eec950280a2dd70f8a28de608" => :mavericks
    sha1 "fa9c5efd2c527b08ee296ec014b925fdf99c0019" => :mountain_lion
    sha1 "105a41893e4ec2bcbf102cd78aaba5152e256eec" => :lion
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
