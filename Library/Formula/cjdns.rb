class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v17.tar.gz"
  sha256 "cb6f98ebee61147dbcac2fc12fdc6bed4036f3115a8ca14a575d6dacbf323afe"

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
