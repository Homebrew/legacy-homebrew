class TwoLame < Formula
  desc "Optimized MPEG Audio Layer 2 (MP2) encoder"
  homepage "http://www.twolame.org/"
  url "https://downloads.sourceforge.net/twolame/twolame-0.3.13.tar.gz"
  sha256 "98f332f48951f47f23f70fd0379463aff7d7fb26f07e1e24e42ddef22cc6112a"

  option "frontend", "Build the twolame frontend using libsndfile"

  depends_on "libsndfile" if build.include? "frontend"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
