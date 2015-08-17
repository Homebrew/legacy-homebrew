class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co"
  url "https://launchpad.net/byobu/trunk/5.94/+download/byobu_5.94.orig.tar.gz"
  sha256 "4917013f590110d25b18293a51af02bd1ebcd1c665474f62e2566fb9b8f62916"

  bottle do
    sha256 "3b5da5651f1d2f0b1233b1ae764c3f4a7e72a4c1725f4889c526bb83d5eca816" => :yosemite
    sha256 "00f1ef5add1a0c204aedc18c562274d8740c4699b1b28cd21b6e44f9564428ce" => :mavericks
    sha256 "85c10105b1d5a4b6b1ed3161c755643070fbd446547dbeac44bb4388ecd00669" => :mountain_lion
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
