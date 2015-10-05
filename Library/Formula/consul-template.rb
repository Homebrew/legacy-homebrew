require "language/go"

class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.10.0",
      :revision => "14cf110504f3089a3c96a36126bd6d5fe39df37a"

  head "https://github.com/hashicorp/consul-template.git"

  depends_on "go" => :build

  go_resource "github.com/armon/go-metrics" do
    url "https://github.com/armon/go-metrics.git",
        :revision => "6c5fa0d8f48f4661c9ba8709799c88d425ad20f0"
  end

  go_resource "github.com/armon/go-radix" do
    url "https://github.com/armon/go-radix.git",
        :revision => "fbd82e84e2b13651f3abc5ffd26b65ba71bc8f93"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
        :revision => "890e878e1bf2abba2e0c33e494daf3ca55b2e563"
  end

  go_resource "github.com/coreos/go-etcd" do
    url "https://github.com/coreos/go-etcd.git",
        :revision => "de3514f25635bbfb024fdaf2a8d5f67378492675"
  end

  go_resource "github.com/fatih/structs" do
    url "https://github.com/fatih/structs.git",
        :revision => "a9f7daa9c2729e97450c2da2feda19130a367d8f"
  end

  go_resource "github.com/go-sql-driver/mysql" do
    url "https://github.com/go-sql-driver/mysql.git",
        :revision => "527bcd55aab2e53314f1a150922560174b493034"
  end

  go_resource "github.com/hashicorp/consul" do
    url "https://github.com/hashicorp/consul.git",
        :revision => "78aa6f1443ba506e8c9bc88b6f4448ad6fee325f"
  end

  go_resource "github.com/hashicorp/errwrap" do
    url "https://github.com/hashicorp/errwrap.git",
        :revision => "7554cd9344cec97297fa6649b055a8c98c2a1e55"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
        :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git",
        :revision => "d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5"
  end

  go_resource "github.com/hashicorp/go-syslog" do
    url "https://github.com/hashicorp/go-syslog.git",
        :revision => "42a2b573b664dbf281bd48c3cc12c086b17a39ba"
  end

  go_resource "github.com/hashicorp/golang-lru" do
    url "https://github.com/hashicorp/golang-lru.git",
        :revision => "7f9ef20a0256f494e24126014135cf893ab71e9e"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
        :revision => "4de51957ef8d4aba6e285ddfc587633bbfc7c0e8"
  end

  go_resource "github.com/hashicorp/logutils" do
    url "https://github.com/hashicorp/logutils.git",
        :revision => "0dc08b1671f34c4250ce212759ebd880f743d883"
  end

  go_resource "github.com/hashicorp/vault" do
    url "https://github.com/hashicorp/vault.git",
        :revision => "e217795abd0f881b11e3c59718954e7bbbbe86d8"
  end

  go_resource "github.com/mitchellh/copystructure" do
    url "https://github.com/mitchellh/copystructure.git",
        :revision => "6fc66267e9da7d155a9d3bd489e00dad02666dc6"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
        :revision => "281073eb9eb092240d33ef253c404f1cca550309"
  end

  go_resource "github.com/mitchellh/reflectwalk" do
    url "https://github.com/mitchellh/reflectwalk.git",
        :revision => "eecf4c70c626c7cfbb95c90195bc34d386c74ac6"
  end

  go_resource "github.com/samuel/go-zookeeper" do
    url "https://github.com/samuel/go-zookeeper.git",
        :revision => "913027ed60abbe2436b35cf960193b06b00105cf"
  end

  go_resource "github.com/ugorji/go" do
    url "https://github.com/ugorji/go.git",
        :revision => "45ce7596ace4534e47b69051a92aef7b64ec7b3f"
  end

  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git",
        :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "c8b9e6388ef638d5a8a9d865c634befdc46a6784"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "53feefa2559fb8dfa8d81baad31be332c97d6c77"
  end

  def install
    contents = Dir["{*,.git,.gitignore,.travis.yml}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/consul-template").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/hashicorp/consul-template" do
      system "make"
      bin.install "bin/consul-template"
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
