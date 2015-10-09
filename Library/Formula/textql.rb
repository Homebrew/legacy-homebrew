require "language/go"

class Textql < Formula
  desc "Executes SQL across text files"
  homepage "https://github.com/dinedal/textql"
  url "https://github.com/dinedal/textql/archive/2.0.2.tar.gz"
  sha256 "e68c0be0df3c9f8ce06224382031cbeecf4c45e9b46fc218b95e72d2f9cb551b"

  depends_on "go" => :build

  go_resource "github.com/mattn/go-sqlite3" do
    url "https://github.com/mattn/go-sqlite3.git",
      :revision => "8897bf145272af4dd0305518cfb725a5b6d0541c"
  end

  def install
    (buildpath/"src/github.com/dinedal/textql").install "inputs", "outputs", "storage", "sqlparser", "util", "textql"
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.VERSION=2.0.2",
      "-o", "#{bin}/textql", "#{buildpath}/src/github.com/dinedal/textql/textql/main.go"
  end

  test do
    assert_equal "3\n",
      pipe_output("#{bin}/textql -sql 'select count(*) from stdin'", "a\nb\nc\n")
  end
end
