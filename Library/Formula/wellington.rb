require "language/go"

class Wellington < Formula
  desc "Sass project tool with spriting using libSass"
  homepage "https://github.com/wellington/wellington"

  stable do
    # git required to resolve submodule
    url "https://github.com/wellington/wellington.git", :tag => "v1.0.2", :revision => "afa2957ac2df46ebf7208322089b6ef27dc4df88"
    sha256 "8936a7dde95e5620055732d5f73c1d1f5f581c1ad69cd86072a797e18b0c1fea"
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "3656e211a96b653dbb5d32a8e4f51a6b68bd3ee95019aad8cd0f4d512352da38" => :el_capitan
    sha256 "8fcca3d1cc4f4ae6f2821b4b215c58ab6c7d88178b5c4cffe7adc72e86da38c5" => :yosemite
    sha256 "2ef26afb326f22102249daee8c795fb467ce9716a2aae306efd23efc65020df3" => :mavericks
  end

  needs :cxx11

  head do
    url "https://github.com/wellington/wellington.git"
  end

  depends_on "go" => :build

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    version = File.read("version.txt").chomp
    ENV["GOPATH"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"

    # move all the files into expected Go path
    wtpath = buildpath/"src/github.com/wellington/wellington"
    wtpath.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd wtpath do
      system "go", "build", "-ldflags", "-X github.com/wellington/wellington/version.Version #{version}", "-o", "dist/wt", "wt/main.go"
      bin.install "dist/wt"
    end
  end

  test do
    s = "div { p { color: red; } }"
    expected = <<-EOS.undent
      Reading from stdin, -h for help
      /* line 1, stdin */
      div p {
        color: red; }
    EOS
    assert_equal expected, pipe_output("#{bin}/wt", s, 0)
  end
end
