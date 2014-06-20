require "formula"

class Nsq < Formula
  homepage "http://bitly.github.io/nsq"
  url "https://github.com/bitly/nsq/archive/v0.2.27.tar.gz"
  sha1 "3d8a1d28d76e3ea8e788192b0e9a39800b112791"

  depends_on "go" => :build
  depends_on :hg # some package dependencies are mercurial repos

  resource "godep" do
    url "http://bitly-downloads.s3.amazonaws.com/nsq/godep.tar.gz"
    sha1 "396a62055bb5b4eb4f58cffc64b2ac8deafbacac"
  end

  def install
    # build a proper GOPATH tree for local dependencies
    (buildpath + "src/github.com/bitly/nsq").install "util", "nsqlookupd"
    (buildpath + "src/github.com/bitly/nsq/nsqadmin").install "nsqadmin/templates" => "templates"

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
