class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v17.tar.gz"
  sha256 "cb6f98ebee61147dbcac2fc12fdc6bed4036f3115a8ca14a575d6dacbf323afe"

  bottle do
    cellar :any_skip_relocation
    sha256 "30e0707ca8e2769bc0cf87f95b5279b5a2833e6270f567c55ef04f2a8b139f7d" => :el_capitan
    sha256 "c9ed4bd3a1aa5056404aca2f20d13d38d6195033b0e34a331d1e66b7cbf12499" => :yosemite
    sha256 "fd44d9b878d33fb3f7cbd3bdae1d607cd477b980b5580d7e8fb5161453870f5c" => :mavericks
  end

  depends_on "node" => :build

  def install
    system "./do"
    bin.install "cjdroute"
    (share+"test").install "build_darwin/test_testcjdroute_c" => "cjdroute_test"
  end

  test do
    system "#{share}/test/cjdroute_test", "all"
  end
end
