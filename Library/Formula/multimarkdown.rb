class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "http://fletcherpenney.net/multimarkdown/"
  # Use git tag instead of the tarball to get submodules
  url "https://github.com/fletcher/MultiMarkdown-5.git",
    :tag => "v5.0",
    :revision => "47e7c4a2fac0271ee52ae0c7062a726978219341"

  head "https://github.com/fletcher/MultiMarkdown-5.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f9758705ae952f5d33d5eec397bf352a182217500c73bdd64b5c43e5d5c640c" => :el_capitan
    sha256 "3ee488167591254206ff276f3b15ec760be60ff76bf1729ef0d49ba3efd1a1a2" => :yosemite
    sha256 "e1ca2bd2e5667406abe9629a03e12b6670336e6efdcdfa71b6b53e93f6f886a1" => :mavericks
    sha256 "7b3b8c13b58c25cd8eae393275361d7442d47e285df34898818604ac6279cb94" => :mountain_lion
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", :because => "both install `mmd` binaries"
  conflicts_with "markdown", :because => "both install `markdown` binaries"
  conflicts_with "discount", :because => "both install `markdown` binaries"

  def install
    system "sh", "link_git_modules"
    system "sh", "update_git_modules"
    system "make"

    cd "build" do
      system "make"
      bin.install "multimarkdown"
    end
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"multimarkdown", "foo *bar*\n")
  end
end
