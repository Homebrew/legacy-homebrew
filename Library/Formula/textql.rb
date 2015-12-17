require "language/go"

class Textql < Formula
  desc "Executes SQL across text files"
  homepage "https://github.com/dinedal/textql"
  url "https://github.com/dinedal/textql/archive/2.0.3.tar.gz"
  sha256 "1fc4e7db5748938c31fe650e882aec4088d9123d46284c6a6f0ed6e8ea487e48"

  bottle do
    cellar :any_skip_relocation
    sha256 "276c9632c72120fc08e206497506bd7e9814b1ba4b36b752fc9e04b2f48e1115" => :el_capitan
    sha256 "d1103d3bb4b7b5b3b9061e72b5d94bdcee2992498a844762b213f67046720349" => :yosemite
    sha256 "8f739b640716678f52ed03a453ee44a3be23ec42da592e4baabfd861844923d9" => :mavericks
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
