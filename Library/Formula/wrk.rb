require "formula"

class Wrk < Formula
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/3.1.1.tar.gz"
  sha1 "7cea5d12dc5076fed1a1c730bd3e6eba832a8f61"
  head "https://github.com/wg/wrk.git"

  bottle do
    cellar :any
    sha1 "933b2955b11a7ffb676129775fd5499f0d1a55b9" => :mavericks
    sha1 "0cb7fe074f2b22abd4bae166da6de1a71157bec1" => :mountain_lion
    sha1 "5b3cfd7ddee6ca35d85cbd03ac0102794c0ccd44" => :lion
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
