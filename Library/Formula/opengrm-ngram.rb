require 'formula'

class OpengrmNgram < Formula
  homepage 'http://www.openfst.org/twiki/bin/view/GRM/NGramLibrary'
  url 'http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramDownload/opengrm-ngram-1.1.0.tar.gz'
  sha1 'a2ceeaf6ac129b66d2682d76a20388cf1d4b8c31'

  depends_on 'openfst'

  def install
    ENV.libstdcxx if ENV.compiler == :clang && MacOS.version >= :mavericks
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system 'make install'
  end

  test do
    # based on the examples at the OpenGRM "NGram quick tour" page...
    # tests using a tokenized variant of The Importance of Being Earnest
    system 'curl', 'http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramQuickTour/earnest.txt', '-o', 'e.txt'
    system 'ngramsymbols', 'e.txt', 'e.syms'
    system 'farcompilestrings', '-symbols=e.syms', '-keep_symbols=1', 'e.txt', 'e.far'
    system 'ngramcount', '-order=5', 'e.far', 'e.cnts'
    system 'ngrammake', 'e.cnts', 'e.mod'
    system 'ngramshrink', '-method=relative_entropy', 'e.mod', 'e.pru'
    system 'ngramprint', '--ARPA', 'e.mod'
    system 'ngraminfo', 'e.mod'
    system 'ngramrandgen', '--max_sents=1', 'e.mod'
  end
end
