require "language/go"

class Gollum < Formula
  desc "n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/v0.3.2.tar.gz"
  sha256 "a4f4944d97ef06f73e7aee5688c611d49580278a6c12ded649bc92b70493ef3f"
  head "https://github.com/trivago/gollum.git"

  bottle do
    cellar :any
    sha256 "a645d12362633d918302a2dc7f814aa49b862779808a97f8db89335483f9b6de" => :yosemite
    sha256 "93fcf08659ca1ae810c5b1f4f562aeea9c2ddc2e3cfd0b0f05d1da0e408168a5" => :mavericks
    sha256 "410c0ae44cec0e4b10acaf18f0da6f92bb38cb7435fc82e27d83f08a4f341e18" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/araddon/gou" do
    url "https://github.com/araddon/gou.git", :revision => "101410571bd5319d93372a54c775b4728a46be71"
  end

  go_resource "github.com/artyom/fb303" do
    url "https://github.com/artyom/fb303.git", :revision => "fa4a241cefb113c4981dbac51a8cfcb047efa079"
  end

  go_resource "github.com/artyom/scribe" do
    url "https://github.com/artyom/scribe.git", :revision => "35c1da66e76d138c09c552b492bb341f8504ff40"
  end

  go_resource "github.com/artyom/thrift" do
    url "https://github.com/artyom/thrift.git", :revision => "388840a05deb9b7d85fdf6c225a2729fe1826cb7"
  end

  go_resource "github.com/bitly/go-hostpool" do
    url "https://github.com/bitly/go-hostpool.git", :revision => "d0e59c22a56e8dadfed24f74f452cea5a52722d2"
  end

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git", :revision => "abb85f822d057791afe0f5f883b267fb8bfe2691"
  end

  go_resource "github.com/docker/libcontainer" do
    url "https://github.com/docker/libcontainer.git", :revision => "0ec063848c588506fcb57b932d1ce57c77560c1a"
  end

  go_resource "github.com/eapache/go-resiliency" do
    url "https://github.com/eapache/go-resiliency.git", :revision => "ed0319b32e66e3295db52695ba3ee493e823fbfe"
  end

  go_resource "github.com/eapache/queue" do
    url "https://github.com/eapache/queue.git", :revision => "ded5959c0d4e360646dc9e9908cff48666781367"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git", :revision => "eaa750b9bf4dcb7cb20454be850613b66cda3273"
  end

  go_resource "github.com/jeromer/syslogparser" do
    url "https://github.com/jeromer/syslogparser.git", :revision => "812866d0389ae7e1f5a0110d47dea20224fc776f"
  end

  go_resource "github.com/mattbaird/elastigo" do
    url "https://github.com/mattbaird/elastigo.git", :revision => "09363f92cd44e47b5034719cdef78da73190d847"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git", :revision => "38f3db3860bb1812858610029b0d8188517d8b74"
  end

  go_resource "gopkg.in/Shopify/sarama.v1" do
    url "https://gopkg.in/Shopify/sarama.v1.git", :revision => "d546818f24718ecca1fe4c84c2b834109746da86"
  end

  go_resource "gopkg.in/bufio.v1" do
    url "https://gopkg.in/bufio.v1.git", :revision => "567b2bfa514e796916c4747494d6ff5132a1dfce"
  end

  go_resource "gopkg.in/docker/docker.v1" do
    url "https://gopkg.in/docker/docker.v1.git", :revision => "0baf60984522744eed290348f33f396c046b2f3a"
  end

  go_resource "gopkg.in/mcuadros/go-syslog.v2" do
    url "https://gopkg.in/mcuadros/go-syslog.v2.git", :revision => "f22fa4cce7e718c50fe7adc6e98d703f39e285e0"
  end

  go_resource "gopkg.in/redis.v2" do
    url "https://gopkg.in/redis.v2.git", :revision => "e6179049628164864e6e84e973cfb56335748dea"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git", :revision => "c1cd2254a6dd314c9d73c338c12688c9325d85c6"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/trivago/"
    ln_sf buildpath, buildpath/"src/github.com/trivago/gollum"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "gollum"
    bin.install "gollum"
  end

  test do
    (testpath/"test.conf").write <<-EOS.undent
    - "consumer.Profiler":
        Enable: true
        Runs: 100000
        Batches: 100
        Characters: "abcdefghijklmnopqrstuvwxyz .,!;:-_"
        Message: "%256s"
        Stream: "profile"
    EOS

    assert_match /parsed as ok/, shell_output("#{bin}/gollum -tc #{testpath}/test.conf")
  end
end
