require "formula"
require "language/go"

class Nsq < Formula
  homepage "http://bitly.github.io/nsq"
  url "https://github.com/bitly/nsq/archive/v0.3.1.tar.gz"
  sha1 "f711cb61c1f5ed9865afbec95d57bcca6653b658"

  bottle do
    sha1 "6348ab65e201725cb40865ee2b5fbbbf656e54a0" => :yosemite
    sha1 "63969063698ed231f93294551ac3c2ff56701d2a" => :mavericks
    sha1 "2054e1000115aeb3934b01762881c6cb52afed19" => :mountain_lion
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
      :revision => "b2219913d42659994fd0b68a9692b64fd00e079f"
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
      :revision => "2cf7eb1fdd83e2bb3375fef6fdadb04c3ad564da"
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
