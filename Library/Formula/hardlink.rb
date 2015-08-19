class Hardlink < Formula
  desc "Replace file copies using hardlinks"
  homepage "http://jak-linux.org/projects/hardlink/"
  url "http://jak-linux.org/projects/hardlink/hardlink_0.3.0.tar.xz"
  sha256 "e8c93dfcb24aeb44a75281ed73757cb862cc63b225d565db1c270af9dbb7300f"

  bottle do
    cellar :any
    sha1 "620848862aa5692f5418c50158ff21ae64cbc3d7" => :yosemite
    sha1 "1fc61fc57e8bdec0f49302ba75dab3e14b6b663f" => :mavericks
    sha1 "ba185ba3f4bf55c9a25b2cf9bfd381e392563112" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-getopt"
  depends_on "pcre"

  def install
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "BINDIR=#{bin}", "install"
  end

  test do
    system "#{bin}/hardlink", "--help"
  end
end
