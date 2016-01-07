require "language/go"

class PathExtractor < Formula
  desc "unix filter which outputs the filepaths found in stdin"
  homepage "https://github.com/edi9999/path-extractor"
  url "https://github.com/edi9999/path-extractor/archive/v0.1.0.tar.gz"
  sha256 "33fe041196a36161a67cddb20405ad9d53c9b6fba4f30b8e6bc6c3e1ce0ac1c8"

  head "https://github.com/edi9999/path-extractor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc2d9e129562bdc7142c186d5e8c22b7b9bbf7bbd386d020e1804eec35b6faae" => :el_capitan
    sha256 "cbb931f9afcb5178bb08ea6c09bd1a9ca9ea695e4279bf7b36461ff3eeb490f2" => :yosemite
    sha256 "8afd140f08bdb53ac36ca4e221236cd58406ff16c136aa466c5a28c8c1829714" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    (buildpath/"src/github.com/edi9999").mkpath
    ln_sf buildpath, buildpath/"src/github.com/edi9999/path-extractor"

    system "go", "build", "-o", bin/"path-extractor", "path-extractor/pe.go"
  end

  test do
    assert_equal "foo/bar/baz\n",
      pipe_output("#{bin}/path-extractor", "a\nfoo/bar/baz\nd\n")
  end
end
