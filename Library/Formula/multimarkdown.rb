require 'formula'

class Multimarkdown < Formula
  homepage 'http://fletcherpenney.net/multimarkdown/'
  # Use git tag instead of the tarball to get submodules
  url 'https://github.com/fletcher/MultiMarkdown-4.git', :tag => '4.6'
  head 'https://github.com/fletcher/MultiMarkdown-4.git'

  bottle do
    cellar :any
    sha1 "7d7a8d34fba87f3987da64b5fe13ceff78a29372" => :yosemite
    sha1 "10a6c6a46a72678ba24fc3b9f244c346a24a8116" => :mavericks
    sha1 "3dbf424f3b1537ce8b8c973e5c0392af241708e9" => :mountain_lion
  end

  conflicts_with 'mtools', :because => 'both install `mmd` binaries'

  def install
    ENV.append 'CFLAGS', '-g -O3 -include GLibFacade.h'
    system "make"
    bin.install 'multimarkdown', Dir['scripts/*']
    prefix.install 'Support'
  end

  def caveats; <<-EOS.undent
    Support files have been installed to:
      #{opt_prefix}/Support
    EOS
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"mmd", "foo *bar*\n")
  end
end
