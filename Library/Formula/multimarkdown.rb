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
    sha256 "19e71e5fdd1532a5cad72f7b2ec8cf233edf3fcbb48a1edec31bc83cef70cf81" => :el_capitan
    sha256 "447908fdb0e2a0ba123a4125e80473d9afad6a0f0b04c4fc031b651fec43f486" => :yosemite
    sha256 "27142eda3b7c24650c23ea4996534d7b11ee32dbd28d3e218c7f750a00784f90" => :mavericks
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
