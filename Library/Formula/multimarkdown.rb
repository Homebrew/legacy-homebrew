class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "http://fletcherpenney.net/multimarkdown/"
  # Use git tag instead of the tarball to get submodules
  url "https://github.com/fletcher/MultiMarkdown-5.git",
    :tag => "5.2.0",
    :revision => "101bbad1dc572c5d87788b2b17b6f9375f1d2bc8"

  head "https://github.com/fletcher/MultiMarkdown-5.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0ac27ece734aea62e7043fa1d5d5721371da181bcc9c7d3aefcaffdb6b79ae5" => :el_capitan
    sha256 "21ae8819f596925da49ee77152f9e8f1951b76372fc6231a1c61721ca782837b" => :yosemite
    sha256 "4b0cf6b5d9f25d4895316c59d25dd45f9d4b92ae7aafc7d38072e1c512639d86" => :mavericks
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

    bin.install Dir["scripts/*"].reject { |f| f =~ /\.bat$/ }
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"multimarkdown", "foo *bar*\n")
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"mmd", "foo *bar*\n")
  end
end
