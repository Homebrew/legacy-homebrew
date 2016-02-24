require "language/go"

class Textql < Formula
  desc "Executes SQL across text files"
  homepage "https://github.com/dinedal/textql"
  url "https://github.com/dinedal/textql/archive/2.0.3.tar.gz"
  sha256 "1fc4e7db5748938c31fe650e882aec4088d9123d46284c6a6f0ed6e8ea487e48"

  bottle do
    cellar :any_skip_relocation
    sha256 "f958e30ce6df17f9dabddbb5a6a4af0d9d7690844983cfae8eb864ec2bdf0913" => :el_capitan
    sha256 "aed185329089c37638d1cf3aec6dbcf51180772f6f62d6b8fc74de733e664d6c" => :yosemite
    sha256 "5d31dc62316f04fea50b4fa1e75230e80a8c2c749c33e1f22aa74b26f26074f8" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/mattn/go-sqlite3" do
    url "https://github.com/mattn/go-sqlite3.git",
      :revision => "8897bf145272af4dd0305518cfb725a5b6d0541c"
  end

  def install
    (buildpath/"src/github.com/dinedal/textql").install "inputs", "outputs", "storage", "sqlparser", "util", "textql"
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.VERSION=2.0.3",
      "-o", "#{bin}/textql", "#{buildpath}/src/github.com/dinedal/textql/textql/main.go"
    man1.install "man/textql.1"
  end

  test do
    assert_equal "3\n",
      pipe_output("#{bin}/textql -sql 'select count(*) from stdin'", "a\nb\nc\n")
  end
end
