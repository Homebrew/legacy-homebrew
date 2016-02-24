require "language/go"

class Gollum < Formula
  desc "n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/v0.4.1.tar.gz"
  sha256 "73b5d4f7fa600d4d6182a80f5cea29f84296d2acf1fb9dd841beafd2620e66b6"
  revision 1

  head "https://github.com/trivago/gollum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "192fabe2a686f142e0aa156e08ee7eeccf05a39a2f1f7de0b5c3907c2573d0d2" => :el_capitan
    sha256 "611172cdba9b0be68760f38fc03e19275e07cd9b3f031895967877ff9b1c7ea9" => :yosemite
    sha256 "02f7c2fd0da3707ea9015ba0ae9645fa93387211e4eb798fbda23b10d7d12917" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/araddon/gou" do
    url "https://github.com/araddon/gou.git",
        :revision => "dc855b3278e170447f71402abf90609da4016dc4"
  end

  go_resource "github.com/artyom/fb303" do
    url "https://github.com/artyom/fb303.git",
        :revision => "fa4a241cefb113c4981dbac51a8cfcb047efa079"
  end

  go_resource "github.com/artyom/scribe" do
    url "https://github.com/artyom/scribe.git",
        :revision => "35c1da66e76d138c09c552b492bb341f8504ff40"
  end

  go_resource "github.com/artyom/thrift" do
    url "https://github.com/artyom/thrift.git",
        :revision => "388840a05deb9b7d85fdf6c225a2729fe1826cb7"
  end

  go_resource "github.com/bitly/go-hostpool" do
    url "https://github.com/bitly/go-hostpool.git",
        :revision => "d0e59c22a56e8dadfed24f74f452cea5a52722d2"
  end

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git",
        :revision => "2cec06fbcd0b4cb6107ae432d92c3997075a4035"
  end

  go_resource "github.com/eapache/go-resiliency" do
    url "https://github.com/eapache/go-resiliency.git",
        :revision => "ed0319b32e66e3295db52695ba3ee493e823fbfe"
  end

  go_resource "github.com/eapache/queue" do
    url "https://github.com/eapache/queue.git",
        :revision => "ded5959c0d4e360646dc9e9908cff48666781367"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "59b73b37c1e45995477aae817e4a653c89a858db"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
        :revision => "723cc1e459b8eea2dea4583200fd60757d40097a"
  end

  go_resource "github.com/jeromer/syslogparser" do
    url "https://github.com/jeromer/syslogparser.git",
        :revision => "ff71fe7a7d5279df4b964b31f7ee4adf117277f6"
  end

  go_resource "github.com/klauspost/crc32" do
    url "https://github.com/klauspost/crc32.git",
        :revision => "f8d2e12057f7ef26ae42ecfa42697f4bdc32d7eb"
  end

  go_resource "github.com/mattbaird/elastigo" do
    url "https://github.com/mattbaird/elastigo.git",
        :revision => "d519ca3a9c607c77ce27818bd11b0ee73ac41d10"
  end

  go_resource "github.com/miekg/pcap" do
    url "https://github.com/miekg/pcap.git",
        :revision => "fbfcc463715f6206524a6b1fcc8ed1b9e7567ba5"
  end

  go_resource "github.com/opencontainers/runc" do
    url "https://github.com/opencontainers/runc.git",
        :revision => "7291a52148da731e2b938eee5137133ae35cd18e"
  end

  go_resource "github.com/shopify/sarama" do
    url "https://github.com/shopify/sarama.git",
        :revision => "9dd45b2fbad462ea03e5dfef5e4fd9acca9e0f49"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "7654728e381988afd88e58cabfd6363a5ea91810"
  end

  go_resource "gopkg.in/Shopify/sarama.v1" do
    url "https://gopkg.in/Shopify/sarama.v1.git",
        :revision => "16b518acd0f9c96a8789f74a760828a0b98e9f40"
  end

  go_resource "gopkg.in/bufio.v1" do
    url "https://gopkg.in/bufio.v1.git",
        :revision => "567b2bfa514e796916c4747494d6ff5132a1dfce"
  end

  go_resource "gopkg.in/docker/docker.v1" do
    url "https://gopkg.in/docker/docker.v1",
        :using => :git,
        :revision => "d12ea79c9de6d144ce6bc7ccfe41c507cca6fd35"
  end

  go_resource "gopkg.in/mcuadros/go-syslog.v2" do
    url "https://gopkg.in/mcuadros/go-syslog.v2.git",
        :revision => "6cba2bfcf64a025c899aa3be061161d2b89d8b54"
  end

  go_resource "gopkg.in/redis.v2" do
    url "https://gopkg.in/redis.v2.git",
        :revision => "e6179049628164864e6e84e973cfb56335748dea"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "7ad95dd0798a40da1ccdff6dff35fd177b5edf40"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/trivago/"
    ln_sf buildpath, buildpath/"src/github.com/trivago/gollum"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gollum"
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

    assert_match "parsed as ok", shell_output("#{bin}/gollum -tc #{testpath}/test.conf")
  end
end
