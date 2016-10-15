class Yass < Formula
  desc "Yet Another Similarity Searcher genomic similarity search tool"
  homepage "http://bioinfo.lifl.fr/yass/"
  url "http://bioinfo.lifl.fr/yass/files/yass-current/yass-1.14.tar.gz"
  sha256 "2ea4d2a32bb17fb6de590b0e8bce5231e2506b490b3456700b4bc029544a1982"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "yass"
  end
end
