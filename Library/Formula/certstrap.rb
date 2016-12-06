class Certstrap < Formula
  desc "simple certificate manager written in Go, adapted from etcd-ca."
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap.git"
  version "0.1.0"

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git",
      :revision => "5598a9815350896a2cdf9f4f1d0a3003ab9677fb"
  end

  def install
    system "./build"
    bin.install "bin/certstrap"
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "test", "--passphrase", "blah"
  end
end
