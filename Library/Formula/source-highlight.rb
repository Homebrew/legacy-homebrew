class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "http://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "http://mirror.anl.gov/pub/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"

  bottle do
    sha256 "95e2bf837d2e57cfb86e15657071855dcf82271602f2f7dec85741890a0ffb8c" => :yosemite
    sha256 "4bdbb164bc86bea12c70ef09dae5a6786975593b1ccca016a202bd2d8bb0d21f" => :mavericks
    sha256 "11a48a7f05a11261678d22c4caecd47d84ea65edd8441dbacbc868c717aad243" => :mountain_lion
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end
end
