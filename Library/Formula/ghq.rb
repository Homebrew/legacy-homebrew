require "language/go"

class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git", :tag => "v0.6", :revision => "b6f7aadbeb21ae18972577173ce175af83ce239d"
  sha256 "d8ab0ef7386647b30210aabc79bf0391ea5c2887be0d4c6a3fb58b8c31eb9b24"

  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any
    sha256 "243adcfa107af6b6d87d2491ef8dc56e44dacd95505bf60c03ff4aa69b37d0cd" => :yosemite
    sha256 "4348cffae023d0a300fa1cc8a1d9f5e26bced6c5330483b4437f25cd6f81bfe7" => :mavericks
    sha256 "bd653fda50b8ed0e05f336dabace93ddf9c4be58d43becd4d694c0f04327096c" => :mountain_lion
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
    url "https://github.com/daviddengcn/go-colortext.git", :revision => "13eaeb896f5985a1ab74ddea58707a73d875ba57"
  end

  def install
    mkdir_p "#{buildpath}/src/github.com/motemen/"
    ln_s buildpath, "#{buildpath}/src/github.com/motemen/ghq"
    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "ghq"
    bin.install "ghq"

    if build.with? "completions"
      zsh_completion.install "zsh/_ghq"
    end
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
