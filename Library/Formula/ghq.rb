require "language/go"

class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.7.4.tar.gz"
  sha256 "f6e79a7efec2cc11dd8489ae31619de85f15b588158d663256bc9fd45aca6a5d"

  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b54f10088af100659f5ddaa493ed0a67227a97996c476b2beb2e1f66109c4c96" => :el_capitan
    sha256 "1640e26475d3ced7964f622de92b62f1eb216d36a880b512eb27f3655d607904" => :yosemite
    sha256 "d87b3b0ab5a3a1f62d4ab34da198a20bb08abab16b21cdd98ef5c194220fb5de" => :mavericks
  end

  option "without-completions", "Disable zsh completions"

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git", :revision => "aca5b047ed14d17224157c3434ea93bf6cdaadee"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git", :revision => "981ab348d865cf048eb7d17e78ac7192632d8415"
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
