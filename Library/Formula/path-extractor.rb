require "language/go"

class PathExtractor < Formula
  desc "unix filter which outputs the filepaths found in stdin"
  homepage "https://github.com/edi9999/path-extractor"
  url "https://github.com/edi9999/path-extractor/archive/v0.1.0.tar.gz"
  sha256 "33fe041196a36161a67cddb20405ad9d53c9b6fba4f30b8e6bc6c3e1ce0ac1c8"

  head "https://github.com/edi9999/path-extractor.git"

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
