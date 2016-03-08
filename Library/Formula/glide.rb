require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.9.2.tar.gz"
  sha256 "fb5480313cbe933369b3f1e52338bccd786fde274bdd680e48bf5e550732e9b4"
  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "57f789c89536d60ff39f2391c5b2f34c57ca78535a89de129b5b7c714d3cd199" => :el_capitan
    sha256 "626ab9a35a4d259e6fb20a69f1b95c0f46de673a7508db91a7a2fa4dba822029" => :yosemite
    sha256 "5ae095d555445a3fa73f968735ab333c991b930d427b525ff0336cfc5685de84" => :mavericks
  end

  depends_on "go" => :build

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "f7716cbe52baa25d2e9b0d0da546fcf909fc16b4"
  end

  go_resource "github.com/Masterminds/vcs" do
    url "https://github.com/Masterminds/vcs.git",
      :revision => "242477a09d9db06a848c5305525168f042d96871"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "c31a7975863e7810c92e2e288a9ab074f9a88f29"
  end

  go_resource "github.com/Masterminds/semver" do
    url "https://github.com/Masterminds/semver.git",
      :revision => "513f3dcb3ecfb1248831fb5cb06a23a3cd5935dc"
  end

  def install

    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/Masterminds/"
    ln_s buildpath, buildpath/"src/github.com/Masterminds/glide"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version #{version}"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match /#{version}/, version
  end
end
