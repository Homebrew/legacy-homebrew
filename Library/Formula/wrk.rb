class Wrk < Formula
  desc "HTTP benchmarking tool"
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/4.0.1.tar.gz"
  sha256 "c03bbc283836cb4b706eb6bfd18e724a8ce475e2c16154c13c6323a845b4327d"
  head "https://github.com/wg/wrk.git"

  bottle do
    cellar :any
    sha256 "982842de8ea8ff98e798a70b51f928e45d6ae17eabd96ba3a6112f4d4cceff50" => :yosemite
    sha256 "fa18093d7236c1d2c68b4f41d633065d716b7bbfea8723605f8793afd2161e17" => :mavericks
    sha256 "1890cb7b8fa9a9ce9ef1f495c407dba4bc5a082e5bcde939fa8d59e807c40499" => :mountain_lion
  end

  depends_on "openssl"

  conflicts_with "wrk-trello", :because => "both install `wrk` binaries"

  def install
    ENV.j1
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W[#{bin}/wrk -c 1 -t 1 -d 1 http://example.com/]
  end
end
