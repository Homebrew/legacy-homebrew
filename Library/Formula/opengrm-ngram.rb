require "formula"

class OpengrmNgram < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/NGramLibrary"
  url "http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramDownload/opengrm-ngram-1.1.0.tar.gz"
  sha1 "a2ceeaf6ac129b66d2682d76a20388cf1d4b8c31"

  depends_on "openfst"

  resource "earnest" do
    url "http://www.openfst.org/twiki/pub/GRM/NGramQuickTour/earnest.txt"
    sha1 "122c72f34a41ecb5e21102724938756fdfe349ec"
  end

  def install
    ENV.libstdcxx if ENV.compiler == :clang && MacOS.version >= :mavericks
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end

  test do
    resource("earnest").stage do
        fname = "earnest.txt"
        # tests using normalized The Importance of Being Earnest, based on
        # examples from the OpenGRM "NGram quick tour" page...
        system "ngramsymbols", fname, "e.syms"
        system "farcompilestrings", "-symbols=e.syms",
                                    "-keep_symbols=1",
                                    fname, "e.far"
        system "ngramcount", "-order=5", "e.far", "e.cnts"
        system "ngrammake", "e.cnts", "e.mod"
        system "ngramshrink", "-method=relative_entropy", "e.mod", "e.pru"
        system "ngramprint", "--ARPA", "e.mod"
        system "ngraminfo", "e.mod"
    end
  end
end
