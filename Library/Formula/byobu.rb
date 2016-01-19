class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co"
  url "https://launchpad.net/byobu/trunk/5.94/+download/byobu_5.94.orig.tar.gz"
  sha256 "4917013f590110d25b18293a51af02bd1ebcd1c665474f62e2566fb9b8f62916"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "210e6c1e3e682f64decac62c00f07729f700b22e3aaa4fea115d3276136b4cee" => :el_capitan
    sha256 "5b9cd209e5607b1a24f000172bbe750906f5ec25c1f653f123332c0d7f314704" => :yosemite
    sha256 "e554b1b2db2ae5008bff7fadf2ca98e6269c4b68374da80d103379d6b22b68a5" => :mavericks
  end

  conflicts_with "ctail", :because => "both install `ctail` binaries"

  depends_on "coreutils"
  depends_on "gnu-sed" # fails with BSD sed
  depends_on "tmux"
  depends_on "newt" => "with-python"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end

  test do
    system bin/"byobu-status"
  end
end
