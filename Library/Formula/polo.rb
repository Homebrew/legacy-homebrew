require "language/go"

class Polo < Formula
  desc "Static blog generator compatible with Jekyll & Pelican content"
  homepage "https://github.com/agonzalezro/polo"
  url "https://github.com/agonzalezro/polo/archive/v1.0.tar.gz"
  sha256 "39ba03b17f725faf319c97a3e9e5852e4abb8c420e3cd4216b7c1a0ba7dcb7ff"

  depends_on "go" => :build

  go_resource "github.com/constabulary/gb" do
    url "https://github.com/constabulary/gb.git",
        :revision => "23f405f2981056a97abb52b5b7e528a6cddef1bb"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/constabulary/gb" do
      system "go", "get", "./..."
    end

    system "bin/gb", "build"
    bin.install "bin/polo"
  end

  test do
    (testpath/"config.json").write <<-EOS.undent
      {
        "author": "Foo Bar",
        "title": "test blog"
      }
    EOS

    system "#{bin}/polo", ".", "myblog"
    assert File.directory? "myblog"
  end
end
