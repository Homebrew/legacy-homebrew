class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "http://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "http://mirror.anl.gov/pub/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 1

  bottle do
    sha256 "d9d498b1fc3eb7075ecb76c87c8ce9d6241f00c5e82b0b03f2a4b46c25fa625f" => :el_capitan
    sha256 "543c6b217e90a61ae369db03b190f11439dd6b7de1cda32c1728a490a9b5be16" => :yosemite
    sha256 "513fe0f5454d4cd73ee77ca06478d32fdbd246149b47d6d3ce5cd80b79f4650a" => :mavericks
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match /GNU Source-highlight #{version}/, shell_output("#{bin}/source-highlight -V")
  end
end
