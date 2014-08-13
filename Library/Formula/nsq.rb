require "formula"

class Nsq < Formula
  homepage "http://bitly.github.io/nsq"
  url "https://github.com/bitly/nsq/archive/v0.2.30.tar.gz"
  sha1 "e8e9df1b472782d912bca6fe451f25ec35b9c3e6"

  bottle do
    sha1 "fa6980ba138a8448cbe330cb0f3abb994f39981f" => :mavericks
    sha1 "b3b73efccdd831f621e71450962af28b25a2e96b" => :mountain_lion
    sha1 "17b716e4f43f5608a51915ede83f1d83c9771ef2" => :lion
  end

  depends_on "go" => :build
  depends_on :hg # some package dependencies are mercurial repos

  resource "godep" do
    url "http://bitly-downloads.s3.amazonaws.com/nsq/godep.tar.gz"
    sha1 "396a62055bb5b4eb4f58cffc64b2ac8deafbacac"
  end

  def install
    # build a proper GOPATH tree for local dependencies
    (buildpath + "src/github.com/bitly/nsq").install "util", "nsqlookupd", "nsqd"
    (buildpath + "src/github.com/bitly/nsq/nsqadmin").install "nsqadmin/templates" => "templates"

    # godep is only needed to *build* so don't install somewhere permanent
    buildpath.install resource("godep")

    ENV["GOPATH"] = buildpath
    system "#{buildpath}/godep restore"
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    system "#{bin}/nsqd", "--version"
  end
end
