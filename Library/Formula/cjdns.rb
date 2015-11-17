class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v16.1.tar.gz"
  sha256 "3eebb276ee63f103c54aa9201e67d8d810ae3a88af90300dd3a3a894e73cb400"

  bottle do
    cellar :any
    sha256 "0b87bde24768d2f23f87d0dc09fbb47cb05f99c438757939ede4d03b1fd0af3f" => :yosemite
    sha256 "16f751bff106f62330f10907394620743d5f043c640a65edaa392d74a068ecfb" => :mavericks
    sha256 "7868e1bb787eb0fd4c0039c2b70b7f6db0553438eb31d8c2bc98cc6d38381b95" => :mountain_lion
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
