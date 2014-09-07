require "formula"
require "language/go"

class Nsq < Formula
  homepage "http://bitly.github.io/nsq"
  url "https://github.com/bitly/nsq/archive/v0.2.31.tar.gz"
  sha1 "614e66746c6b785cffb48a6412e44dd5e0c7b0bd"

  bottle do
    sha1 "fa6980ba138a8448cbe330cb0f3abb994f39981f" => :mavericks
    sha1 "b3b73efccdd831f621e71450962af28b25a2e96b" => :mountain_lion
    sha1 "17b716e4f43f5608a51915ede83f1d83c9771ef2" => :lion
  end

  depends_on "go" => :build

  go_resource "code.google.com/p/snappy-go" do
    url "https://code.google.com/p/snappy-go/", :using => :hg,
      :revision => "12e4b4183793ac4b061921e7980845e750679fd0"
  end

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
      :revision => "2dff11163ee667d51dcc066660925a92ce138deb"
  end

  go_resource "github.com/bitly/go-hostpool" do
    url "https://github.com/bitly/go-hostpool.git",
      :revision => "58b95b10d6ca26723a7f46017b348653b825a8d6"
  end

  go_resource "github.com/bitly/go-nsq" do
    url "https://github.com/bitly/go-nsq.git",
      :revision => "ac221df5bdb6d5bfc624a297b5b00b59d7065be2"
  end

  go_resource "github.com/bitly/go-simplejson" do
    url "https://github.com/bitly/go-simplejson.git",
      :revision => "fc395a5db941cf38922b1ccbc083640cd76fe4bc"
  end

  go_resource "github.com/bmizerany/perks" do
    url "https://github.com/bmizerany/perks.git",
      :revision => "6cb9d9d729303ee2628580d9aec5db968da3a607"
  end

  go_resource "github.com/mreiferson/go-options" do
    url "https://github.com/mreiferson/go-options.git",
      :revision => "896a539cd709f4f39d787562d1583c016ce7517e"
  end

  go_resource "github.com/mreiferson/go-snappystream" do
    url "https://github.com/mreiferson/go-snappystream.git",
      :revision => "307a466b220aaf34bcee2d19c605ed9e96b4bcdb"
  end

  def install
    # build a proper GOPATH tree for local dependencies
    (buildpath + "src/github.com/bitly/nsq").install "util", "nsqlookupd", "nsqd"
    (buildpath + "src/github.com/bitly/nsq/nsqadmin").install "nsqadmin/templates" => "templates"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    system "#{bin}/nsqd", "--version"
  end
end
