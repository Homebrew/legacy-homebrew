require "language/go"

class PathExtractor < Formula
  desc "A unix filter which outputs the filepaths found in stdin"
  homepage "https://github.com/edi9999/path-extractor"
  url "https://github.com/edi9999/path-extractor/archive/54f890f142995fbc2ed737b8fff1635a8226ccc3.tar.gz"
  sha256 "4489f91b1f2bd02f7d41dc8d87bb9484034995064b48898d5769c0cdb3a6e30a"
  version "0.1.0"

  head "https://github.com/edi9999/path-extractor.git"

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/edi9999/"
    ln_sf buildpath, buildpath/"src/github.com/edi9999/path-extractor"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"path-extractor", "path-extractor/pe.go"
  end

  test do
    assert `printf 'a\nfoo/bar/baz\nd' | #{bin}/path-extractor` == "foo/bar/baz\n"
  end
end
