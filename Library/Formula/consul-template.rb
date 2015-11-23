require "language/go"

class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.11.1",
      :revision => "134aecc73e607f09986370600232ecb8f44d0940"

  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "95b8a25581a97c295c201641756e95ad2bbe6937f9fa050e736d97317b1dd271" => :el_capitan
    sha256 "af712e022632da7f68019b3fd84fced8caff92d450df9ac9f8c69d3a184450d7" => :yosemite
    sha256 "e0423df75f407f59e97b9f6a2f64d846efd74cf2565a1cb09489096763219a0c" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "ef1967b9f538fe467e6a82fc42ec5dff966ad4ea"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  go_resource "github.com/fatih/structs" do
    url "https://github.com/fatih/structs.git",
        :revision => "c701457aaa1ff6709d5e35fccb5c129448e0a37b"
  end

  go_resource "github.com/hashicorp/consul" do
    url "https://github.com/hashicorp/consul.git",
        :revision => "ab63122a320928b290d681aaac1145b19a69cc0d"
  end

  go_resource "github.com/hashicorp/errwrap" do
    url "https://github.com/hashicorp/errwrap.git",
        :revision => "7554cd9344cec97297fa6649b055a8c98c2a1e55"
  end

  go_resource "github.com/hashicorp/go-cleanhttp" do
    url "https://github.com/hashicorp/go-cleanhttp.git",
        :revision => "5df5ddc69534f1a4697289f1dca2193fbb40213f"
  end

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git",
        :revision => "d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5"
  end

  go_resource "github.com/hashicorp/go-syslog" do
    url "https://github.com/hashicorp/go-syslog.git",
        :revision => "42a2b573b664dbf281bd48c3cc12c086b17a39ba"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
        :revision => "1688f22977e3b0bbdf1aaa5e2528cf10c2e93e78"
  end

  go_resource "github.com/hashicorp/logutils" do
    url "https://github.com/hashicorp/logutils.git",
        :revision => "0dc08b1671f34c4250ce212759ebd880f743d883"
  end

  go_resource "github.com/hashicorp/serf" do
    url "https://github.com/hashicorp/serf.git",
        :revision => "a72c0453da2ba628a013e98bf323a76be4aa1443"
  end

  go_resource "github.com/hashicorp/vault" do
    url "https://github.com/hashicorp/vault.git",
        :revision => "93f196fd75d0a13d1489c02bf05d24d2d6168466"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
        :revision => "281073eb9eb092240d33ef253c404f1cca550309"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "53feefa2559fb8dfa8d81baad31be332c97d6c77"
  end

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "386"
    revision = `git rev-parse HEAD`
    ENV["GOPATH"] = buildpath
    # For the gox buildtool used by consul-template, which doesn't need to
    # get installed permanently
    ENV.append_path "PATH", buildpath

    ctpath = buildpath/"src/github.com/hashicorp/consul-template"
    ctpath.install Dir["{*,.git}"]
    Language::Go.stage_deps resources, buildpath/"src"
    mkdir_p buildpath/"bin"

    cd "src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    cd "src/github.com/hashicorp/consul-template" do
      system "gox",
             "-os=darwin",
             "-arch=#{arch}",
             "-ldflags",
             "-X main.GitCommit #{revision}",
             "-output",
             "consul-template",
             "."
      bin.install "consul-template"
    end
  end

  test do
    (testpath/"test-template").write <<-EOS.undent
      {{"homebrew" | toTitle}}
    EOS
    system "#{bin}/consul-template", "-once", \
           "-template", "test-template:test-result"
    assert_equal "Homebrew\n", (testpath/"test-result").read
  end
end
