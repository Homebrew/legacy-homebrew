class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v16.1.tar.gz"
  sha256 "3eebb276ee63f103c54aa9201e67d8d810ae3a88af90300dd3a3a894e73cb400"

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
