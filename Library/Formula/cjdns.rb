class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v17.3.tar.gz"
  sha256 "3193df651ad9c00f31ab04feb33f801645996f6647c89b63bcc327b48e17e602"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c5cd5cca2928f98e65d4e285a1eba7102ca054827cfbefd2b2d31fcc43600a7" => :el_capitan
    sha256 "3b2a279e5524d111020967495bffc11e17dd54b5842bc4c02c77b19219042bea" => :yosemite
    sha256 "2b9e97cc73dbbd14c5e1973317322a989d8c6e90d9c3a9c9348070599be1898d" => :mavericks
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
