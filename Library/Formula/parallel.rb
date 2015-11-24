class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20151122.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20151122.tar.bz2"
  sha256 "550a63be340f931b91dbfe0e726c64522f74ec5afd7a64086603533c694b165e"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "16b5500ff77aef1176ed4ff833673668c59acb54577cde7e618117ab32599c58" => :el_capitan
    sha256 "df1e6595f2b1f23409aa9a6bdf4969e200c89ee64f8f3bd59faceffaf66658ea" => :yosemite
    sha256 "d62094bce716ea935c2a8571370ba19c39c8956733b2d9391864cdeff261b1dd" => :mavericks
  end

  conflicts_with "moreutils", :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
