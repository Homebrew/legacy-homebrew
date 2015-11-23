require "language/go"

class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.7.1.tar.gz"
  sha256 "c43c469e47761ca67103c056c79d976933265905bd7ddd662035162532c76fb2"

  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any
    sha256 "df6df9c2100ad46586d62233dfdb99401bb5beab42a0d87635419bf439797212" => :yosemite
    sha256 "80a4db2f17fb2c3614604231921fd867f0a85e2034942c96e1f9d33dd6b1b136" => :mavericks
    sha256 "7d6e66fef647214c51a79a0759be423e990894c3dc03be45fc654b8e74270148" => :mountain_lion
  end

  option "without-completions", "Disable zsh completions"

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git", :revision => "565493f259bf868adb54d45d5f4c68d405117adf"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git", :revision => "1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4"
  end

  go_resource "github.com/motemen/go-colorine" do
    url "https://github.com/motemen/go-colorine.git", :revision => "49ff36b8fa42db28092361cd20dcefd0b03b1472"
  end

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git", :revision => "3b18c8575a432453d41fdafb340099fff5bba2f7"
  end

  def install
    mkdir_p "#{buildpath}/src/github.com/motemen/"
    ln_s buildpath, "#{buildpath}/src/github.com/motemen/ghq"
    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.Version #{version}", "-o", "ghq"
    bin.install "ghq"

    if build.with? "completions"
      zsh_completion.install "zsh/_ghq"
    end
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
