require "formula"

class Nsq < Formula
  homepage "http://bitly.github.io/nsq"
  url "https://github.com/bitly/nsq/archive/v0.2.24.tar.gz"
  sha1 "9f1dbaffd8c0a49715555b722df745d228bbb868"

  depends_on "go" => :build
  depends_on :hg # some package dependencies are mercurial repos

  resource "godep" do
    url "http://bitly-downloads.s3.amazonaws.com/nsq/godep.tar.gz"
    sha1 "396a62055bb5b4eb4f58cffc64b2ac8deafbacac"
  end

  def install
    (buildpath + "src/github.com/bitly/nsq").install "util"

    # godep is only needed to *build* so don't install somewhere permanent
    buildpath.install resource("godep")

    ENV["GOPATH"] = `#{buildpath}/godep path`.strip
    ENV.append_path "GOPATH", buildpath
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    system "#{bin}/nsqd", "--version"
  end
end
