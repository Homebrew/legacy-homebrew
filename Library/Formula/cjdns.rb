class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v17.3.tar.gz"
  sha256 "3193df651ad9c00f31ab04feb33f801645996f6647c89b63bcc327b48e17e602"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23d12cadbd43e5971b74cf47767258d62c5d5a18810dce0f3a81c0065f63bee4" => :el_capitan
    sha256 "712e4c11ad38882b36e259f0d803b777ba982874988dfe285340e5d93e1b3df2" => :yosemite
    sha256 "4b1d2fbaba625a93273db3ec431428f4311b09f6a875ef5b57e4954798000ce7" => :mavericks
  end

  depends_on "node" => :build

  def install
    system "./do"
    bin.install "cjdroute"
    (pkgshare/"test").install "build_darwin/test_testcjdroute_c" => "cjdroute_test"
  end

  test do
    system "#{pkgshare}/test/cjdroute_test", "all"
  end
end
