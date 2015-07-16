class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "http://ftpmirror.gnu.org/libidn/libidn-1.31.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libidn/libidn-1.31.tar.gz"
  sha256 "afdf2fce91faea483ce24e26b5e3a9235e332029c9265d07214fd1cfaa08df08"

  bottle do
    cellar :any
    sha256 "986476acf5da5d76e837a99acc35bcf2db332f70442ca9594c1756ca1eb4d5c9" => :yosemite
    sha256 "85c4054e9504102482379386739d21bb55c5630c68c6f3f37c669c9dffadeb71" => :mavericks
    sha256 "2785cd21c1e32a7cd6d8e414b18584a41c2eb4f0e26694ea8cbe61e0ef083b38" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system "#{bin}/idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
