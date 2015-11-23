require "language/go"

class Remarshal < Formula
  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://github.com/dbohdan/remarshal.git", :tag => "v0.3.0", :revision => "bb9ac467ca297c55587a798531886e6159acbcbd"

  head "https://github.com/dbohdan/remarshal.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "bf5b2278463be82a2a80469d35227bebbd84afb3df0c8347b85f28ab549df880" => :yosemite
    sha256 "bcdb49a223f602545591b3fd71014d4ecaa81d3032f1e046df71194672375072" => :mavericks
    sha256 "090b55a57566e88c45bd0d85adcf3eaad853a3d9603fcece459357f1ae163880" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on :hg => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git", :revision => "443a628bc233f634a75bcbdd71fe5350789f1afa"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git", :revision => "49c95bdc21843256fb6c4e0d370a05f24a0bf213"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/dbohdan/"
    ln_sf buildpath, buildpath/"src/github.com/dbohdan/remarshal"
    Language::Go.stage_deps resources, buildpath/"src"

    # Build and install
    system "go", "build", "-o", "remarshal"
    bin.install "remarshal"

    ["toml", "yaml", "json"].permutation(2).each do |informat, outformat|
      bin.install_symlink "remarshal" => "#{informat}2#{outformat}"
    end
  end

  test do
    json = <<-EOS.undent.chomp
      {
        "foo.bar": "baz",
        "qux": 1
      }

    EOS
    yaml = <<-EOS.undent.chomp
      foo.bar: baz
      qux: 1


    EOS
    toml = <<-EOS.undent.chomp
      "foo.bar" = "baz"
      qux = 1


    EOS
    assert_equal yaml, pipe_output("#{bin}/remarshal -if=json -of=yaml", json)
    assert_equal yaml, pipe_output("#{bin}/json2yaml", json)
    assert_equal toml, pipe_output("#{bin}/remarshal -if=yaml -of=toml", yaml)
    assert_equal toml, pipe_output("#{bin}/yaml2toml", yaml)
    assert_equal json, pipe_output("#{bin}/remarshal -if=toml -of=json", toml)
    assert_equal json, pipe_output("#{bin}/toml2json", toml)
  end
end
